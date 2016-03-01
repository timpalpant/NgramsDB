package main

import (
	"bufio"
	"flag"
	"fmt"
	"io"
	"log"
	"os"
	"strconv"
	"strings"

	"github.com/timpalpant/ngramsdb"
)

// Represents one parsed line from the ngram input files.
type ngramRecord struct {
	// IDs for ngram in word and POS lookup tables.
	ngram string
	// Counts stored as (year, freq, vol, ...)
	yearFreq []uint64
}

func (nr *ngramRecord) Equals(other *ngramRecord) bool {
	if other == nil {
		return false
	}

	return nr.ngram == other.ngram
}

func (nr *ngramRecord) MergeCounts(other *ngramRecord) {
	nr.yearFreq = append(nr.yearFreq, other.yearFreq...)
}

func writeToOutput(nr *ngramRecord, word2id map[string]string, out io.Writer) {
	ids, err := ngramIds(nr.ngram, word2id)
	if ids == nil {
		return
	}
	if err != nil {
		log.Printf("Error getting ids for ngram: %v", nr.ngram)
		return
	}
	idStr := strings.Join(ids, "\t")
	totalFreq, totalVol := ngramsdb.ComputeTotals(nr.yearFreq)
	fmt.Fprintf(out, "%v\t%v\t%v\t%v\n", idStr, totalFreq, totalVol,
		ngramsdb.EncodeFreq(nr.yearFreq))
}

func ngramIds(ngram string, word2id map[string]string) ([]string, error) {
	tokens := strings.Fields(ngram)
	for i, token := range tokens {
		word := ngramsdb.SplitWordFromPOS(token)
		if word == "" { // POS-tagged or other special word, skip.
			return nil, nil
		}

		id, ok := word2id[word]
		if !ok {
			return nil, fmt.Errorf("Word '%s' not found in word2id table", word)
		}
		tokens[i] = id
	}

	return tokens, nil
}

func parseNgramRecord(line string) (*ngramRecord, error) {
	entry := strings.SplitN(line, "\t", 4)

	yearFreq := make([]uint64, 0, 3)
	for i := 1; i < len(entry); i++ {
		n, err := strconv.ParseUint(entry[i], 10, 64)
		if err != nil {
			return nil, fmt.Errorf("Invalid number %v in line: %v", entry[i], line)
		}
		yearFreq = append(yearFreq, n)
	}

	return &ngramRecord{
		ngram:    entry[0],
		yearFreq: yearFreq,
	}, nil
}

func processNgrams(inReader io.Reader, outWriter io.Writer,
	word2id map[string]string) {
	scanner := bufio.NewScanner(inReader)
	var curNgram *ngramRecord
	for scanner.Scan() {
		line := scanner.Text()
		ngram, err := parseNgramRecord(line)
		if err != nil {
			log.Printf("Skipping line (error): %v", err)
			continue
		} else if curNgram != nil {
			if curNgram.Equals(ngram) {
				curNgram.MergeCounts(ngram)
			} else {
				writeToOutput(curNgram, word2id, outWriter)
				curNgram = ngram
			}
		} else {
			curNgram = ngram
		}
	}

	if err := scanner.Err(); err != nil {
		panic(err)
	}

	// Write the last result.
	if curNgram != nil {
		writeToOutput(curNgram, word2id, outWriter)
	}
}

func main() {
	wordFile := flag.String("word_file", "word.txt", "File with id -> word table")
	flag.Parse()

	word2id, err := ngramsdb.LoadLookupTable(*wordFile)
	if err != nil {
		panic(err)
	}
	log.Printf("%v words in initial word DB", len(word2id))

	inReader := bufio.NewReader(os.Stdin)
	outWriter := bufio.NewWriter(os.Stdout)
	defer outWriter.Flush()
	processNgrams(inReader, outWriter, word2id)
}
