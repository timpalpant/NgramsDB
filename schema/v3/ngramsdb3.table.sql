-- -----------------------------------------------------
-- Table `ngram`.`1gram`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ngram`.`1gram` (
  `id` INT UNSIGNED NOT NULL,
  `word` VARCHAR(45) CHARACTER SET 'utf8' COLLATE 'utf8_bin' NOT NULL,
  `total_freq` BIGINT UNSIGNED,
  `total_vol` BIGINT UNSIGNED,
  `year_freq` BLOB)
ENGINE = MyISAM;

-- -----------------------------------------------------
-- Table `ngram`.`2gram`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ngram`.`2gram` (
  `word1_id` INT UNSIGNED NOT NULL,
  `word2_id` INT UNSIGNED NOT NULL,
  `total_freq` BIGINT UNSIGNED,
  `total_vol` BIGINT UNSIGNED,
  `year_freq` BLOB)
ENGINE = MyISAM;

-- -----------------------------------------------------
-- Table `ngram`.`3gram`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ngram`.`3gram` (
  `word1_id` INT UNSIGNED NOT NULL,
  `word2_id` INT UNSIGNED NOT NULL,
  `word3_id` INT UNSIGNED NOT NULL,
  `total_freq` BIGINT UNSIGNED,
  `total_vol` BIGINT UNSIGNED,
  `year_freq` BLOB)
ENGINE = MyISAM;

-- -----------------------------------------------------
-- Table `ngram`.`4gram`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ngram`.`4gram` (
  `word1_id` INT UNSIGNED NOT NULL,
  `word2_id` INT UNSIGNED NOT NULL,
  `word3_id` INT UNSIGNED NOT NULL,
  `word4_id` INT UNSIGNED NOT NULL,
  `total_freq` BIGINT UNSIGNED,
  `total_vol` BIGINT UNSIGNED,
  `year_freq` BLOB)
ENGINE = MyISAM;

-- -----------------------------------------------------
-- Table `ngram`.`5gram`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ngram`.`5gram` (
  `word1_id` INT UNSIGNED NOT NULL,
  `word2_id` INT UNSIGNED NOT NULL,
  `word3_id` INT UNSIGNED NOT NULL,
  `word4_id` INT UNSIGNED NOT NULL,
  `word5_id` INT UNSIGNED NOT NULL,
  `total_freq` BIGINT UNSIGNED,
  `total_vol` BIGINT UNSIGNED,
  `year_freq` BLOB)
ENGINE = MyISAM;
