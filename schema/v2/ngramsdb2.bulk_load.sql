LOAD DATA INFILE '/mnt/data/google-ngrams/processed/word.txt' INTO TABLE word;
LOAD DATA INFILE '/mnt/data/google-ngrams/processed/pos.txt' INTO TABLE pos;
LOAD DATA INFILE '/mnt/data/google-ngrams/processed/1gram.txt' INTO TABLE 1gram (word_id, pos_id, @var1)
SET year_freq = UNHEX(@var1);
