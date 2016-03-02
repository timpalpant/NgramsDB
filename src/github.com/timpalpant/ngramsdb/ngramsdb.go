package ngramsdb

import (
	"bufio"
	"encoding/binary"
	"encoding/hex"
	"fmt"
	"os"
	"sort"
	"strings"
)

// Max wordlength in DB. Words are truncated if they are
// longer than this.
const kMaxWordLength = 40

var kPOSTags = map[string]string{
	"NOUN": "1",
	"VERB": "2",
	"ADJ":  "3",
	"ADV":  "4",
	"PRON": "5",
	"DET":  "6",
	"ADP":  "7",
	"NUM":  "8",
	"CONJ": "9",
	"PRT":  "10",
	"X":    "11",
	".":    "12",
}

// Encodes the array of [year1, freq1, year2, freq2, ...]
// using unsigned LEB128 varint (like protobufs). The resulting
// bytestring is then hex-encoded (it should be UNHEXed) when
// bulk loading into MySQL.
func EncodeFreq(yearFreq []uint64) string {
	// Allocate a byte array large enough to hold the max possible result.
	bs := make([]byte, binary.MaxVarintLen64*len(yearFreq))
	b := bs
	for _, value := range yearFreq {
		n := binary.PutUvarint(b, value)
		b = b[n:] // Shift, so next value starts at next byte.
	}

	// Trim off any extra bytes that were unused.
	bs = bs[:len(bs)-len(b)]
	return hex.EncodeToString(bs)
}

// Decodes the array of [year1, freq1, year2, freq2, ...]
// using unsigned LEB128 varint (like protobufs).
func DecodeFreq(hexString string) ([]uint64, error) {
	bs, err := hex.DecodeString(hexString)
	if err != nil {
		return nil, err
	}

	result := make([]uint64, 0)
	for len(bs) > 0 {
		v, nRead := binary.Uvarint(bs)
		if nRead <= 0 {
			return nil, fmt.Errorf("Error decoding frequencies: %s", hexString)
		}

		result = append(result, v)
		bs = bs[nRead:]
	}

	return result, nil
}

// Takes a map of year -> (freq, vol) and returns an array
// [year1, freq1, vol1, year2, freq2, vol2, ...]
// where the years are guaranteed to be sorted in ascending order.
func FreqMapToArray(freq map[int][]uint64) []uint64 {
	years := make([]int, 0, len(freq))
	for year, _ := range freq {
		years = append(years, year)
	}
	sort.Ints(years)

	result := make([]uint64, 3*len(years))
	for i, year := range years {
		result[3*i] = uint64(year)
		result[3*i+1] = freq[year][0]
		result[3*i+2] = freq[year][1]
	}

	return result
}

// Separate word from its POS anntation.
// POS annotations are appended after an underscore (_),
// but some word tokens also have underscores, so check to make
// sure that the putative POS is in the POSTag set.
func SplitWordFromPOS(word string) string {
	// Check for words that are POS tags
	if len(word) > 2 && word[0] == '_' && word[len(word)-1] == '_' {
		possiblePOS := word[1 : len(word)-1]
		if _, ok := kPOSTags[possiblePOS]; ok {
			// Exclude POS tag words
			return ""
		}
	}

	idx := strings.LastIndex(word, "_")
	if idx != -1 {
		pos := word[idx+1:]
		if _, ok := kPOSTags[pos]; ok {
			// Exclude words with POS tags.
			return ""
		}
	}

	// Truncate overlong words.
	if len(word) > kMaxWordLength {
		word = word[:kMaxWordLength]
	}
	// lowercase all words.
	word = strings.ToLower(word)

	return word
}

// Computes total freq and volumes from yearFreq array.
func ComputeTotals(yearFreq []uint64) (uint64, uint64) {
	totalFreq := uint64(0)
	for i := 1; i < len(yearFreq); i += 3 {
		totalFreq += yearFreq[i]
	}

	totalVol := uint64(0)
	for i := 2; i < len(yearFreq); i += 3 {
		totalVol += yearFreq[i]
	}

	return totalFreq, totalVol
}

// Load previous lookup table from file.
func LoadLookupTable(filename string) (map[string]string, error) {
	value2id := make(map[string]string)
	if _, err := os.Stat(filename); err == nil { // File exists
		f, err := os.Open(filename)
		if err != nil { // It's an error if the file exists and we can't open it
			return nil, err
		}
		defer f.Close()
		scanner := bufio.NewScanner(f)
		for scanner.Scan() {
			line := scanner.Text()
			entry := strings.Split(line, "\t")
			value2id[entry[1]] = entry[0]
		}

		if err := scanner.Err(); err != nil {
			return nil, err
		}
	}

	return value2id, nil
}
