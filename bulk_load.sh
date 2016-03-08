DATA_DIR=$(pwd)

mysql -u root ngram -e "LOAD DATA INFILE '${DATA_DIR}/processed/1gram.txt INTO TABLE 1gram (id, word, total_freq, total_vol, @var1) SET year_freq = UNHEX(@var1);";

for INPUT in $(ls *2gram*.txt); do
    echo Loading $INPUT; mysql -u root ngram -e "LOAD DATA INFILE '${DATA_DIR}/processed/${INPUT}' INTO TABLE 2gram (word1_id, word2_id, total_freq, total_vol, @var1) SET year_freq = UNHEX(@var1);";
done

for INPUT in $(ls *3gram*.txt); do
    echo Loading $INPUT;
    mysql -u root ngram -e "LOAD DATA INFILE '${DATA_DIR}/processed/${INPUT}' INTO TABLE 3gram (word1_id, word2_id, word3_id, total_freq, total_vol, @var1) SET year_freq = UNHEX(@var1);";
done

for INPUT in $(ls *4gram*.txt); do
    echo Loading $INPUT;
    mysql -u root ngram -e "LOAD DATA INFILE '${DATA_DIR}/processed/${INPUT}' INTO TABLE 4gram (word1_id, word2_id, word3_id, word4_id, total_freq, total_vol, @var1) SET year_freq = UNHEX(@var1);";
done

for INPUT in $(ls *5gram*.txt); do
    echo Loading $INPUT;
    mysql -u root ngram -e "LOAD DATA INFILE '${DATA_DIR}/processed/${INPUT}' INTO TABLE 5gram (word1_id, word2_id, word3_id, word4_id, word5_id, total_freq, total_vol, @var1) SET year_freq = UNHEX(@var1);";
done
