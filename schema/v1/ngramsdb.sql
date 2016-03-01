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
ENGINE = InnoDB
AUTO_INCREMENT = 41
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `ngram`.`arc`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ngram`.`arc` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `n` TINYINT UNSIGNED NOT NULL,
  `freq` BIGINT UNSIGNED NULL,
  PRIMARY KEY (`id`),
  INDEX `n_idx` (`n` ASC),
  INDEX `freq_idx` (`freq` ASC),
  INDEX `lookup_idx` (`n` ASC, `freq` DESC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ngram`.`arc_freq`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ngram`.`arc_freq` (
  `arc_id` BIGINT UNSIGNED NOT NULL,
  `year` SMALLINT(5) UNSIGNED NOT NULL,
  `freq` INT(10) UNSIGNED NOT NULL DEFAULT '0',
  PRIMARY KEY (`arc_id`, `year`),
  INDEX `year_idx` (`year` ASC),
  INDEX `freq_idx` (`freq` DESC),
  INDEX `lookup_idx` (`year` ASC, `freq` ASC),
  CONSTRAINT `arc_id_fk`
    FOREIGN KEY (`arc_id`)
    REFERENCES `ngram`.`arc` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `ngram`.`pos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ngram`.`pos` (
  `id` TINYINT(3) UNSIGNED NOT NULL AUTO_INCREMENT,
  `tag` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `pos_UNIQUE` (`tag` ASC))
ENGINE = InnoDB
AUTO_INCREMENT = 39
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `ngram`.`word`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ngram`.`word` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `word` VARCHAR(45) CHARACTER SET 'utf8' COLLATE 'utf8_bin' NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `word_UNIQUE` (`word` ASC))
ENGINE = InnoDB
AUTO_INCREMENT = 10888385
DEFAULT CHARACTER SET = utf8
ROW_FORMAT = COMPRESSED;


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
  PRIMARY KEY (`arc_id`, `ordinal`),
  INDEX `lookup_idx` (`word_id` ASC, `pos_id` ASC, `dep_id` ASC),
  INDEX `pos_id_fk_idx` (`pos_id` ASC),
  INDEX `dep_id_fk_idx` (`dep_id` ASC),
  CONSTRAINT `arc_id_fk`
    FOREIGN KEY (`arc_id`)
    REFERENCES `ngram`.`arc` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `word_id_fk`
    FOREIGN KEY (`word_id`)
    REFERENCES `ngram`.`word` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `pos_id_fk`
    FOREIGN KEY (`pos_id`)
    REFERENCES `ngram`.`pos` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `dep_id_fk`
    FOREIGN KEY (`dep_id`)
    REFERENCES `ngram`.`dep` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ngram`.`ngram`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ngram`.`ngram` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `n` TINYINT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ngram`.`ngram_freq`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ngram`.`ngram_freq` (
  `ngram_id` BIGINT UNSIGNED NOT NULL,
  `year` SMALLINT UNSIGNED NOT NULL,
  `freq` INT UNSIGNED NOT NULL,
  `vol` SMALLINT UNSIGNED NULL,
  PRIMARY KEY (`ngram_id`, `year`),
  CONSTRAINT `ngram_id_fk`
    FOREIGN KEY (`ngram_id`)
    REFERENCES `ngram`.`ngram` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ngram`.`ngram_word`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ngram`.`ngram_word` (
  `ngram_id` BIGINT UNSIGNED NOT NULL,
  `ordinal` TINYINT UNSIGNED NOT NULL,
  `word_id` INT UNSIGNED NOT NULL,
  `pos_id` TINYINT UNSIGNED NULL,
  PRIMARY KEY (`ngram_id`, `ordinal`),
  INDEX `word_id_fk_idx` (`word_id` ASC),
  INDEX `pos_id_fk_idx` (`pos_id` ASC),
  FOREIGN KEY (ngram_id) REFERENCES ngram(id),
  FOREIGN KEY (word_id) REFERENCES word(id),
  FOREIGN KEY (pos_id) REFERENCES pos(id))
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
