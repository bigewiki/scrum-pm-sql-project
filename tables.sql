set foreign_key_checks=0;

-- ---
-- Table 'users'
--
-- ---

DROP TABLE IF EXISTS `users`;

CREATE TABLE `users` (
  `id` INTEGER NOT NULL AUTO_INCREMENT,
  `fname` VARCHAR(30) NULL DEFAULT NULL,
  `lname` VARCHAR(30) NULL DEFAULT NULL,
  `role_id` SMALLINT(3) NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) engine=InnoDB Default charset utf8mb4 collate=utf8mb4_unicode_ci;

-- ---
-- Table 'epics'
--
-- ---

DROP TABLE IF EXISTS `epics`;

CREATE TABLE `epics` (
  `id` INTEGER NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(30) NULL DEFAULT NULL,
  `description` TEXT(65535) NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) engine=InnoDB Default charset utf8mb4 collate=utf8mb4_unicode_ci;

-- ---
-- Table 'issues'
--
-- ---

DROP TABLE IF EXISTS `issues`;

CREATE TABLE `issues` (
  `id` INTEGER NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(30) NULL DEFAULT NULL,
  `description` TEXT(65535) NULL DEFAULT NULL,
  `story_id` INTEGER NULL DEFAULT NULL,
  `priority` VARCHAR(10) NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) engine=InnoDB Default charset utf8mb4 collate=utf8mb4_unicode_ci;

-- ---
-- Table 'stories'
--
-- ---

DROP TABLE IF EXISTS `stories`;

CREATE TABLE `stories` (
  `id` INTEGER NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(30) NULL DEFAULT NULL,
  `description` TEXT(65535) NULL DEFAULT NULL,
  `owner` INTEGER NULL DEFAULT NULL,
  `sprint_id` INTEGER NULL DEFAULT NULL,
  `priority` VARCHAR(10) NULL DEFAULT NULL,
  `dependency` INTEGER NULL DEFAULT NULL,
  `time_size` TINYINT NULL DEFAULT NULL,
  `epic_id` INTEGER NULL DEFAULT NULL,
  `status` VARCHAR(30) NULL DEFAULT NULL
  PRIMARY KEY (`id`)
) engine=InnoDB Default charset utf8mb4 collate=utf8mb4_unicode_ci;

-- ---
-- Table 'tasks'
--
-- ---

DROP TABLE IF EXISTS `tasks`;

CREATE TABLE `tasks` (
  `id` INTEGER NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(30) NULL DEFAULT NULL,
  `description` TEXT(65535) NULL DEFAULT NULL,
  `owner` INTEGER NULL DEFAULT NULL,
  `story_id` INTEGER NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) engine=InnoDB Default charset utf8mb4 collate=utf8mb4_unicode_ci;

-- ---
-- Table 'roles'
--
-- ---

DROP TABLE IF EXISTS `roles`;

CREATE TABLE `roles` (
  `id` SMALLINT(3) NOT NULL AUTO_INCREMENT,
  `role_name` VARCHAR(30) NULL DEFAULT NULL,
  `role_description` VARCHAR(255) NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) engine=InnoDB Default charset utf8mb4 collate=utf8mb4_unicode_ci;

-- ---
-- Table 'comments'
--
-- ---

DROP TABLE IF EXISTS `comments`;

CREATE TABLE `comments` (
  `id` INTEGER NOT NULL AUTO_INCREMENT,
  `content` TEXT(10000) NULL DEFAULT NULL,
  `owner` INTEGER NULL DEFAULT NULL,
  `parent` INTEGER NULL DEFAULT NULL,
  `story_id` INTEGER NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) engine=InnoDB Default charset utf8mb4 collate=utf8mb4_unicode_ci;

-- ---
-- Table 'sprints'
--
-- ---

DROP TABLE IF EXISTS `sprints`;

CREATE TABLE `sprints` (
  `id` INTEGER NOT NULL AUTO_INCREMENT,
  `quarter` TINYINT NULL DEFAULT NULL,
  `number` TINYINT NULL DEFAULT NULL,
  `start_date` DATE NULL DEFAULT NULL,
  `end_date` DATE NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) engine=InnoDB Default charset utf8mb4 collate=utf8mb4_unicode_ci;

-- ---
-- Foreign Keys
-- ---

ALTER TABLE `users` ADD FOREIGN KEY (role_id) REFERENCES `roles` (`id`);
ALTER TABLE `issues` ADD FOREIGN KEY (story_id) REFERENCES `stories` (`id`);
ALTER TABLE `stories` ADD FOREIGN KEY (owner) REFERENCES `users` (`id`);
ALTER TABLE `stories` ADD FOREIGN KEY (sprint_id) REFERENCES `sprints` (`id`);
ALTER TABLE `stories` ADD FOREIGN KEY (dependency) REFERENCES `stories` (`id`);
ALTER TABLE `stories` ADD FOREIGN KEY (epic_id) REFERENCES `epics` (`id`);
ALTER TABLE `tasks` ADD FOREIGN KEY (owner) REFERENCES `users` (`id`);
ALTER TABLE `tasks` ADD FOREIGN KEY (story_id) REFERENCES `stories` (`id`);
ALTER TABLE `comments` ADD FOREIGN KEY (owner) REFERENCES `users` (`id`);
ALTER TABLE `comments` ADD FOREIGN KEY (parent) REFERENCES `comments` (`id`);
ALTER TABLE `comments` ADD FOREIGN KEY (story_id) REFERENCES `stories` (`id`);

set foreign_key_checks=1;
