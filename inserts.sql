-- --- --- --- --
-- Test Data
-- --- --- --- --

-- sprints
INSERT INTO `sprints` (`quarter`,`number`,`start_date`,`end_date`) VALUES
(2,1,'2019-04-01','2019-04-14'),
(2,2,'2019-04-15','2019-04-28'),
(2,3,'2019-04-29','2019-05-12'),
(2,4,'2019-05-13','2019-05-26');

-- epics
INSERT INTO `epics` (`name`,`description`) VALUES
('Build a better empire','This place needs some improvements'),
('Take the iron throne','Its time to put someone worthy in charge');

-- roles
INSERT INTO `roles` (`role_name`,`role_description`) VALUES
('Specialist',''),
('Commander','In charge of the army'),
('Advisor','Helps the queen control impulsive action'),
('Queen','Is in charge of all the things');

-- users
INSERT INTO `users` (`fname`,`lname`,`role_id`) VALUES
('Grey','Worm',2),
('Jorah','Mormont',3),
('Tyrion','Lannister',3),
('Daenerys','Targaryen',4);

-- stories
INSERT INTO `stories` (`name`,`description`,`owner`,`sprint_id`,`priority`,`dependency`,`time_size`,`epic_id`) VALUES
('Raise dragons','These things require a lot of upkeep, business wants to automate',3,NULL,'medium',NULL,1,2),
('Build army','Business wants us to add this feature yesterday',1,NULL,'high',NULL,6,2),
('Crush resistance','We have some bug fixes needing attention',1,NULL,'medium',3,9,1),
('Get Navy','We need to optimize our deployments','2',NULL,'high',NULL,4,2);

-- comments
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

-- tasks
INSERT INTO `tasks` (`name`,`description`,`owner`,`story_id`) VALUES
('feed dragons',NULL,NULL,1),
('feed army',NULL,NULL,2),
('discover source of support','Someone is funding them, lets find out who',3,3),
('identify leadership','someone is leading these guys',2,3),
('discredit their cause','lets diminish their popularity',4,3),
('discover costs','this could be expensive',3,4),
('get captains for ships','I dont know how to drive a ship',2,4),
('find source for ships','We have a limited budget, lets shop around',2,4);

-- issues
INSERT INTO `issues` (`name`,`description`,`story_id`,`priority`) VALUES
('Bad monarchs','Down with the queen',NULL,'medium'),
('Flea Bottom isnt safe','I cant even park my horse outside',NULL,'low'),
('The dead are coming','Stop telling me you cant replicate and take this issue seriously or I want to talk to the queen',NULL,'high'),
('We need ships','Theres a sea between here and there...',4,'high');
