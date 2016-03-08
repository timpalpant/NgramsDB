mkdir -p processed
time ls googlebooks-eng-all-2gram-20120701-*.gz | parallel -j 6 time pigz -d -c {} '|' ./ngramsdb_prep -word_file=word.txt '|' sort -k1,2n -S 5% '|' ./collapse_dups '>' processed/{/.}.txt
time ls googlebooks-eng-all-3gram-20120701-*.gz | parallel -j 6 time pigz -d -c {} '|' ./ngramsdb_prep -word_file=word.txt '|' sort -k1,3n -S 5% '|' ./collapse_dups '>' processed/{/.}.txt
time ls googlebooks-eng-all-4gram-20120701-*.gz | parallel -j 6 time pigz -d -c {} '|' ./ngramsdb_prep -word_file=word.txt '|' sort -k1,4n -S 5% '|' ./collapse_dups '>' processed/{/.}.txt
time ls googlebooks-eng-all-5gram-20120701-*.gz | parallel -j 6 time pigz -d -c {} '|' ./ngramsdb_prep -word_file=word.txt '|' sort -k1,5n -S 5% '|' ./collapse_dups '>' processed/{/.}.txt
