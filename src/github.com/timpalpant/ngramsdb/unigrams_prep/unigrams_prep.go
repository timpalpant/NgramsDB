package main

import (
	"bufio"
	"fmt"
	"io"
	"log"
	"os"
	"strconv"
	"strings"

	"github.com/timpalpant/ngramsdb"
)

func printWord(outWriter io.Writer, word string, word2id map[string]int, yearFreq []uint64) {
	id, ok := word2id[word]
	if !ok {
		id = len(word2id) + 1
		word2id[word] = id
	}
	escapedWord := strings.Replace(word, `\`, `\\`, -1)
	totalFreq, totalVol := ngramsdb.ComputeTotals(yearFreq)
	fmt.Fprintf(outWriter, "%v\t%s\t%v\t%v\t%v\n",
		id, escapedWord, totalFreq, totalVol, ngramsdb.EncodeFreq(yearFreq))
}

func processUnigrams(inReader io.Reader, outWriter io.Writer) {
	word2id := make(map[string]int)
	yearFreq := make([]uint64, 0)
	var curWord string

	scanner := bufio.NewScanner(inReader)
	for scanner.Scan() {
		line := scanner.Text()
		entry := strings.SplitN(line, "\t", 4)
		word := ngramsdb.SplitWordFromPOS(entry[0])

		if word != curWord { // New word
			// Write previous ngram results to output.
			if curWord != "" {
				printWord(outWriter, curWord, word2id, yearFreq)
			}

			curWord = word
			yearFreq = yearFreq[:0]
		}

		for i := 1; i < len(entry); i++ {
			n, err := strconv.ParseUint(entry[i], 10, 64)
			if err != nil {
				log.Printf("Invalid number %v in line: %v", entry[i], line)
			}
			yearFreq = append(yearFreq, n)
		}
	}

	if err := scanner.Err(); err != nil {
		panic(err)
	}

	// Write the last result.
	if curWord != "" {
		printWord(outWriter, curWord, word2id, yearFreq)
	}
}

func main() {
	inReader := bufio.NewReader(os.Stdin)
	outWriter := bufio.NewWriter(os.Stdout)
	defer outWriter.Flush()
	processUnigrams(inReader, outWriter)
}
