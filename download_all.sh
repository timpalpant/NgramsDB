#!/bin/bash

for i in {0..9}; do
  wget -N http://storage.googleapis.com/books/ngrams/books/googlebooks-eng-all-0gram-20120701-${i}.gz; 
  wget -N http://storage.googleapis.com/books/ngrams/books/googlebooks-eng-all-1gram-20120701-${i}.gz;
  wget -N http://storage.googleapis.com/books/ngrams/books/googlebooks-eng-all-2gram-20120701-${i}.gz;
  wget -N http://storage.googleapis.com/books/ngrams/books/googlebooks-eng-all-3gram-20120701-${i}.gz;
  wget -N http://storage.googleapis.com/books/ngrams/books/googlebooks-eng-all-4gram-20120701-${i}.gz;
  wget -N http://storage.googleapis.com/books/ngrams/books/googlebooks-eng-all-5gram-20120701-${i}.gz;
done

for X in {a..z}; do
  wget -N http://storage.googleapis.com/books/ngrams/books/googlebooks-eng-all-0gram-20120701-${X}.gz; d
  wget -N http://storage.googleapis.com/books/ngrams/books/googlebooks-eng-all-1gram-20120701-${X}.gz
done

for N in {2..5}; do 
  for X in {a..z}; do
    wget -N http://storage.googleapis.com/books/ngrams/books/googlebooks-eng-all-${N}gram-20120701-${X}_.gz; 
    for Y in {a..z}; do
      wget -N http://storage.googleapis.com/books/ngrams/books/googlebooks-eng-all-${N}gram-20120701-${X}${Y}.gz;
    done
  done
done

for N in {2..5}; do 
    for POS in ADJ ADP ADV CONJ DET NOUN NUM PRON PRT VERB; do 
        wget -N http://storage.googleapis.com/books/ngrams/books/googlebooks-eng-all-${N}gram-20120701-_${POS}_.gz; 
    done;
done

for POS in ADJ ADP ADV CONJ DET NOUN NUM PRON PRT VERB; do 
    wget -N http://storage.googleapis.com/books/ngrams/books/googlebooks-eng-all-0gram-20120701-_${POS}_.gz; 
done
