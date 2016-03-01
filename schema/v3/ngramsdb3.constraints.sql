ALTER TABLE 1gram ADD CONSTRAINT 1gram_pkey PRIMARY KEY (id),
  ADD UNIQUE INDEX word_idx (word),
  ADD INDEX total_freq_idx (total_freq);

ALTER TABLE 2gram ADD INDEX word1_idx (word1_id),
  ADD INDEX word2_idx (word2_id),
  ADD INDEX total_freq_idx (total_freq);

ALTER TABLE 3gram ADD INDEX word1_idx (word1_id),
  ADD INDEX word2_idx (word2_id),
  ADD INDEX word3_idx (word3_id),
  ADD INDEX total_freq_idx (total_freq);

ALTER TABLE 4gram ADD INDEX word1_idx (word1_id),
  ADD INDEX word2_idx (word2_id),
  ADD INDEX word3_idx (word3_id),
  ADD INDEX word4_idx (word4_id),
  ADD INDEX total_freq_idx (total_freq);

ALTER TABLE 5gram ADD INDEX word1_idx (word1_id),
  ADD INDEX word2_idx (word2_id),
  ADD INDEX word3_idx (word3_id),
  ADD INDEX word4_idx (word4_id),
  ADD INDEX word5_idx (word5_id),
  ADD INDEX total_freq_idx (total_freq);

