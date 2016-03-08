# NgramsDB
Load the Google Books Ngram dataset into MySQL.

Lowercases N-grams from the 20120701 dataset and collapses years into a single record
for import into MySQL. Frequencies and volume counts for each year are varint encoded
and stored in a BLOB column. A small JSON server is provided for easy count decoding.

For the schema, see `schema/v3/ngramsdb3.table.sql`.

Download all N-grams (~2.2 TB).
```$ ./download_all.sh
```

Build the scripts
```$ ./build.sh
$ mkdir -p processed
```

Make unigrams table.
```$ pigz -d -c googlebooks-eng-all-1gram*.gz | ./unigrams_prep > processed/1gram.txt
```

Make word -> id lookup table.
```$ cut -f 1-2 processed/1gram.txt > word.txt
```

Process 2-, 3-, 4-, and 5-grams.
```$ ./process_ngrams.sh
```

Create the MySQL tables.
```$ mysql < schema/v3/ngramsdb3.table.sql
```

Bulk load N-grams into MySQL.
```$ ./bulk_load.sh
```

Create indexes.
```$ mysql ngram < schema/v3/ngramsdb3.constraints.sql
```

Start the server.
```$ ./server
```

Test the server
```$ ./test_server.sh
{"result":{"TotalFreq":12893,"TotalVol":6866,"Years":[1938,1939,1945,1949,1950,1954,1955,1957,1958,1959,1960,1961,1962,1963,1964,1965,1966,1967,1968,1969,1970,1971,1972,1973,1974,1975,1976,1977,1978,1979,1980,1981,1982,1983,1984,1985,1986,1987,1988,1989,1990,1991,1992,1993,1994,1995,1996,1997,1998,1999,2000,2001,2002,2003,2004,2005,2006,2007,2008],"Freqs":[6,6,7,3,3,3,3,6,9,3,2,2,1,1,1,1,1,7,4,8,3,10,11,3,3,2,8,5,3,4,31,10,2,13,9,6,18,5,32,35,16,16,19,29,35,56,79,54,58,82,126,97,97,90,147,139,87,82,112],"Vols":[2,2,1,1,1,1,1,1,4,3,2,1,1,1,1,1,1,1,2,7,3,6,5,3,2,1,4,5,3,4,6,8,2,8,6,6,11,5,15,14,14,13,15,22,32,37,39,38,45,65,74,70,73,61,71,80,70,68,85]},"error":null,"id":1}
```
