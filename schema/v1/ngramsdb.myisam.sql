SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema ngram
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `ngram` DEFAULT CHARACTER SET utf8 ;
USE `ngram` ;

-- -----------------------------------------------------
-- Table `ngram`.`dep`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ngram`.`dep` (
  `id` TINYINT(3) UNSIGNED NOT NULL AUTO_INCREMENT,
  `label` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `label_UNIQUE` (`label` ASC))
ENGINE = MyISAM
AUTO_INCREMENT = 41
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_bin
ROW_FORMAT = Fixed;


-- -----------------------------------------------------
-- Table `ngram`.`arc`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ngram`.`arc` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `n` TINYINT UNSIGNED NOT NULL,
  `freq` BIGINT UNSIGNED NULL,
  PRIMARY KEY (`id`))
ENGINE = MyISAM
ROW_FORMAT = Fixed;


-- -----------------------------------------------------
-- Table `ngram`.`arc_freq`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ngram`.`arc_freq` (
  `arc_id` BIGINT UNSIGNED NOT NULL,
  `year` SMALLINT(5) UNSIGNED NOT NULL,
  `freq` INT(10) UNSIGNED NOT NULL DEFAULT '0',
  PRIMARY KEY (`arc_id`, `year`))
ENGINE = MyISAM
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_bin
ROW_FORMAT = Fixed;


-- -----------------------------------------------------
-- Table `ngram`.`pos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ngram`.`pos` (
  `id` TINYINT(3) UNSIGNED NOT NULL AUTO_INCREMENT,
  `tag` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `pos_UNIQUE` (`tag` ASC))
ENGINE = MyISAM
AUTO_INCREMENT = 39
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_bin
ROW_FORMAT = Fixed;


-- -----------------------------------------------------
-- Table `ngram`.`word`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ngram`.`word` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `word` VARCHAR(45) CHARACTER SET 'utf8' COLLATE 'utf8_bin' NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `word_UNIQUE` (`word` ASC))
ENGINE = MyISAM
AUTO_INCREMENT = 1
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_bin
ROW_FORMAT = Default;


-- -----------------------------------------------------
-- Table `ngram`.`arc_word`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ngram`.`arc_word` (
  `arc_id` BIGINT UNSIGNED NOT NULL,
  `ordinal` TINYINT UNSIGNED NOT NULL DEFAULT 0,
  `word_id` INT UNSIGNED NOT NULL,
  `pos_id` TINYINT UNSIGNED NULL,
  `dep_id` TINYINT UNSIGNED NULL,
  `head_index` TINYINT UNSIGNED NULL,
  PRIMARY KEY (`arc_id`, `ordinal`))
ENGINE = MyISAM
ROW_FORMAT = Fixed;


-- -----------------------------------------------------
-- Table `ngram`.`ngram`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ngram`.`ngram` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `n` TINYINT UNSIGNED NOT NULL,
  `freq` BIGINT UNSIGNED NULL,
  PRIMARY KEY (`id`))
ENGINE = MyISAM
ROW_FORMAT = Fixed;


-- -----------------------------------------------------
-- Table `ngram`.`ngram_freq`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ngram`.`ngram_freq` (
  `ngram_id` BIGINT UNSIGNED NOT NULL,
  `year` SMALLINT UNSIGNED NOT NULL,
  `freq` INT UNSIGNED NOT NULL,
  `vol` SMALLINT UNSIGNED NULL,
  PRIMARY KEY (`ngram_id`, `year`))
ENGINE = MyISAM
ROW_FORMAT = Fixed;


-- -----------------------------------------------------
-- Table `ngram`.`ngram_word`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ngram`.`ngram_word` (
  `ngram_id` BIGINT UNSIGNED NOT NULL,
  `ordinal` TINYINT UNSIGNED NOT NULL,
  `word_id` INT UNSIGNED NOT NULL,
  `pos_id` TINYINT UNSIGNED NULL,
  PRIMARY KEY (`ngram_id`, `ordinal`))
ENGINE = MyISAM
ROW_FORMAT = Fixed;


-- -----------------------------------------------------
-- Table `ngram`.`ngram_prefix`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ngram`.`ngram_prefix` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `prefix_id` BIGINT UNSIGNED NULL,
  `word_id` INT UNSIGNED NOT NULL,
  `pos_id` TINYINT UNSIGNED NULL,
  `freq` BIGINT UNSIGNED NULL,
  PRIMARY KEY (`id`))
ENGINE = MyISAM
ROW_FORMAT = Fixed;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
