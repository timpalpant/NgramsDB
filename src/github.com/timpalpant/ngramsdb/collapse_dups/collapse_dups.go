// This script collapses duplicate N-grams, summing their
// frequency counts. It assumes the input is sorted, so that
// duplicate N-grams appear adjacent to each other.

package main

import (
	"bufio"
	"fmt"
	"io"
	"os"
	"strconv"
	"strings"

	"github.com/timpalpant/ngramsdb"
)

type ngramRecord struct {
	ngram     []string
	totalFreq uint64
	totalVol  uint64
	yearFreq  map[int][2]uint64
}

func parseNgramRecord(line string) (*ngramRecord, error) {
	entry := strings.Split(line, "\t")
	ngram := entry[:len(entry)-3]
	totalFreq, err := strconv.ParseUint(entry[len(entry)-3], 10, 64)
	if err != nil {
		return nil, err
	}
	totalVol, err := strconv.ParseUint(entry[len(entry)-2], 10, 64)
	if err != nil {
		return nil, err
	}

	yf, err := ngramsdb.DecodeFreq(entry[len(entry)-1])
	if err != nil {
		return nil, err
	}
	yearFreq := make(map[int][2]uint64)
	for i := 0; i < len(yf)-2; i += 3 {
		year := int(yf[i])
		freq := yf[i+1]
		vol := yf[i+2]
		yearFreq[year] = [2]uint64{freq, vol}
	}

	return &ngramRecord{
		ngram:     ngram,
		totalFreq: totalFreq,
		totalVol:  totalVol,
		yearFreq:  yearFreq,
	}, nil
}

func (nr *ngramRecord) Equals(other *ngramRecord) bool {
	if other == nil {
		return false
	}

	if len(nr.ngram) != len(other.ngram) {
		return false
	}

	for i := range nr.ngram {
		if nr.ngram[i] != other.ngram[i] {
			return false
		}
	}

	return true
}

func (nr *ngramRecord) MergeCounts(other *ngramRecord) {
	nr.totalFreq += other.totalFreq
	nr.totalVol += other.totalVol

	for year, counts := range other.yearFreq {
		if f, ok := nr.yearFreq[year]; ok {
			f[0] += counts[0]
			f[1] += counts[1]
		} else {
			nr.yearFreq[year] = counts
		}
	}
}

func writeToOutput(nr *ngramRecord, out io.Writer) {
	row := nr.ngram
	row = append(row, strconv.FormatUint(nr.totalFreq, 10),
		strconv.FormatUint(nr.totalVol, 10),
		ngramsdb.EncodeFreq(ngramsdb.FreqMapToArray(nr.yearFreq)))
	fmt.Fprintf(out, "%v\n", strings.Join(row, "\t"))
}

func collapseDups(inReader io.Reader, outWriter io.Writer) {
	scanner := bufio.NewScanner(inReader)

	var prevNgram *ngramRecord
	for scanner.Scan() {
		line := scanner.Text()
		ngram, err := parseNgramRecord(line)
		if err != nil {
			panic(err)
		}

		if ngram.Equals(prevNgram) {
			prevNgram.MergeCounts(ngram)
		} else if prevNgram != nil {
			writeToOutput(prevNgram, outWriter)
			prevNgram = ngram
		} else {
			prevNgram = ngram
		}
	}

	if err := scanner.Err(); err != nil {
		panic(err)
	}

	// Write final N-gram to disk.
	writeToOutput(prevNgram, outWriter)
}

func main() {
	inReader := bufio.NewReader(os.Stdin)
	outWriter := bufio.NewWriter(os.Stdout)
	defer outWriter.Flush()
	collapseDups(inReader, outWriter)
}
