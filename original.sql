-- set foreign_key_checks=0;

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

-- --- --- --- --
-- Test Data
-- --- --- --- --

--sprints
INSERT INTO `sprints` (`quarter`,`number`,`start_date`,`end_date`) VALUES
(2,1,'2019-04-01','2019-04-14'),
(2,2,'2019-04-15','2019-04-28'),
(2,3,'2019-04-29','2019-05-12'),
(2,4,'2019-05-13','2019-05-26');

--epics
INSERT INTO `epics` (`name`,`description`) VALUES
('Build a better empire','This place needs some improvements'),
('Take the iron throne','Its time to put someone worthy in charge');

--roles
INSERT INTO `roles` (`role_name`,`role_description`) VALUES
('Specialist',''),
('Commander','In charge of the army'),
('Advisor','Helps the queen control impulsive action'),
('Queen','Is in charge of all the things');

--users
INSERT INTO `users` (`fname`,`lname`,`role_id`) VALUES
('Grey','Worm',2),
('Jorah','Mormont',3),
('Tyrion','Lannister',3),
('Daenerys','Targaryen',4);

--stories
INSERT INTO `stories` (`name`,`description`,`owner`,`sprint_id`,`priority`,`dependency`,`time_size`,`epic_id`) VALUES
('Raise dragons','These things require a lot of upkeep, business wants to automate',3,NULL,'medium',NULL,1,2),
('Build army','Business wants us to add this feature yesterday',1,NULL,'high',NULL,6,2),
('Crush resistance','We have some bug fixes needing attention',1,NULL,'medium',3,9,1),
('Get Navy','We need to optimize our deployments','2',NULL,'high',NULL,4,2);

--comments
INSERT INTO `comments` (`content`,`owner`,`parent`,`story_id`) VALUES
('I like dragons...',3,NULL,1),
('I love them',4,1,1),
('The dragons arent eating',4,NULL,1),
('The army needs more food',1,NULL,2),
('Ill see what I can do',3,4,2),
('I can give you a hand',2,5,2),
('Thank you all for doing your part',4,6,2),
('No problem Khaleesi',2,7,2),
('I live to serve...',3,8,2),
('My men were attacked on patrol',1,NULL,3),
('Who did it?',3,11,3),
('You know who',1,12,3),
('We can buy ships from Bravos',2,13,4),
('We cannot afford it',3,14,4),
('Let me talk to them...',4,15,4);

--tasks
INSERT INTO `tasks` (`name`,`description`,`owner`,`story_id`) VALUES
('feed dragons',NULL,NULL,1),
('feed army',NULL,NULL,2),
('discover source of support','Someone is funding them, lets find out who',3,3),
('identify leadership','someone is leading these guys',2,3),
('discredit their cause','lets diminish their popularity',4,3),
('discover costs','this could be expensive',3,4),
('get captains for ships','I dont know how to drive a ship',2,4),
('find source for ships','We have a limited budget, lets shop around',2,4);

--issues
INSERT INTO `issues` (`name`,`description`,`story_id`,`priority`) VALUES
('Bad monarchs','Down with the queen',NULL,'medium'),
('Flea Bottom isnt safe','I cant even park my horse outside',NULL,'low'),
('The dead are coming','Stop telling me you cant replicate and take this issue seriously or I want to talk to the queen',NULL,'high'),
('We need ships','Theres a sea between here and there...',4,'high');






-- --- --- --- --
-- Queries
-- --- --- --- --

--simple display of users and roles
SELECT u.fname, u.lname, r.role_name, r.role_description
FROM users AS u JOIN roles r ON (u.role_id=r.id);

--display story owners
SELECT s.name,s.description,s.priority,CONCAT(u.fname,' ',u.lname) AS owner
FROM stories AS s JOIN users u ON (u.id=s.owner)\G

--display story owners and their role!
SELECT s.name,s.description,s.priority,CONCAT(u.fname,' ',u.lname) AS owner,r.role_name
FROM stories AS s JOIN users u ON (u.id=s.owner)
JOIN roles r ON (u.role_id=r.id)\G

--display issues and their stories
SELECT i.name, i.description, s.name AS story
FROM issues AS i LEFT JOIN stories s ON (i.story_id=s.id);

--display task, story, and owner
SELECT t.name AS `task name`, s.name as `story name`, CONCAT(u.fname,' ',u.lname) AS owner
FROM tasks AS t JOIN stories s ON (t.story_id=s.id)
LEFT JOIN users u ON (t.owner=u.id) ORDER BY s.name;
