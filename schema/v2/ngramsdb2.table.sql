-- -----------------------------------------------------
-- Table `ngram`.`pos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ngram`.`pos` (
  `id` TINYINT(3) UNSIGNED NOT NULL,
  `tag` VARCHAR(45) NULL DEFAULT NULL)
ENGINE = MyISAM
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_bin;

-- -----------------------------------------------------
-- Table `ngram`.`word`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ngram`.`word` (
  `id` INT UNSIGNED NOT NULL,
  `word` VARCHAR(45) CHARACTER SET 'utf8' COLLATE 'utf8_bin' NULL DEFAULT NULL)
ENGINE = MyISAM
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_bin;

-- -----------------------------------------------------
-- Table `ngram`.`1gram`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ngram`.`1gram` (
  `word1_id` INT UNSIGNED NOT NULL,
  `pos1_id` TINYINT UNSIGNED,
  `total_freq` BIGINT UNSIGNED,
  `total_vol` BIGINT UNSIGNED,
  `year_freq` BLOB)
ENGINE = MyISAM;

-- -----------------------------------------------------
-- Table `ngram`.`2gram`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ngram`.`2gram` (
  `word1_id` INT UNSIGNED NOT NULL,
  `pos1_id` TINYINT UNSIGNED,
  `word2_id` INT UNSIGNED NOT NULL,
  `pos2_id` TINYINT UNSIGNED,
  `total_freq` BIGINT UNSIGNED,
  `total_vol` BIGINT UNSIGNED,
  `year_freq` BLOB)
ENGINE = MyISAM;

-- -----------------------------------------------------
-- Table `ngram`.`3gram`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ngram`.`3gram` (
  `word1_id` INT UNSIGNED NOT NULL,
  `pos1_id` TINYINT UNSIGNED,
  `word2_id` INT UNSIGNED NOT NULL,
  `pos2_id` TINYINT UNSIGNED,
  `word3_id` INT UNSIGNED NOT NULL,
  `pos3_id` TINYINT UNSIGNED,
  `total_freq` BIGINT UNSIGNED,
  `total_vol` BIGINT UNSIGNED,
  `year_freq` BLOB)
ENGINE = MyISAM;

-- -----------------------------------------------------
-- Table `ngram`.`4gram`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ngram`.`4gram` (
  `word1_id` INT UNSIGNED NOT NULL,
  `pos1_id` TINYINT UNSIGNED,
  `word2_id` INT UNSIGNED NOT NULL,
  `pos2_id` TINYINT UNSIGNED,
  `word3_id` INT UNSIGNED NOT NULL,
  `pos3_id` TINYINT UNSIGNED,
  `word4_id` INT UNSIGNED NOT NULL,
  `pos4_id` TINYINT UNSIGNED,
  `total_freq` BIGINT UNSIGNED,
  `total_vol` BIGINT UNSIGNED,
  `year_freq` BLOB)
ENGINE = MyISAM;

-- -----------------------------------------------------
-- Table `ngram`.`5gram`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ngram`.`5gram` (
  `word1_id` INT UNSIGNED NOT NULL,
  `pos1_id` TINYINT UNSIGNED,
  `word2_id` INT UNSIGNED NOT NULL,
  `pos2_id` TINYINT UNSIGNED,
  `word3_id` INT UNSIGNED NOT NULL,
  `pos3_id` TINYINT UNSIGNED,
  `word4_id` INT UNSIGNED NOT NULL,
  `pos4_id` TINYINT UNSIGNED,
  `word5_id` INT UNSIGNED NOT NULL,
  `pos5_id` TINYINT UNSIGNED,
  `total_freq` BIGINT UNSIGNED,
  `total_vol` BIGINT UNSIGNED,
  `year_freq` BLOB)
ENGINE = MyISAM;
