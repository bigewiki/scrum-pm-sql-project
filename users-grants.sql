-- creating a super admin user for Daenerys Targaryen with all grants
create user 'daenerystargaryen'@'localhost' Identified WITH SHA256_PASSWORD by '14MTheUnburnt!';
GRANT ALL ON *.* TO 'daenerystargaryen'@'localhost';

-- creating a user for Grey Worm
-- this is a more restricted user
create user 'greyworm'@'localhost' Identified WITH SHA256_PASSWORD by 'ILoveMissandei123!';
-- give greyworm some permissions
GRANT select,insert,update,delete,show view
on scrumpm1.tasks to 'greyworm'@'localhost';
GRANT select,insert,update,delete,show view
on scrumpm1.comments to 'greyworm'@'localhost';
GRANT select,insert,update,delete,show view
on scrumpm1.issues to 'greyworm'@'localhost';
GRANT select,insert,update,delete,show view
on scrumpm1.issues to 'greyworm'@'localhost';
GRANT select
on scrumpm1.epics to 'greyworm'@'localhost';
GRANT select
on scrumpm1.stories to 'greyworm'@'localhost';
GRANT select
on scrumpm1.users to 'greyworm'@'localhost';
GRANT select
on scrumpm1.sprints to 'greyworm'@'localhost';
GRANT select
on scrumpm1.roles to 'greyworm'@'localhost';


-- creating a user for Tyrion
create user 'tyrionlannister'@'localhost' Identified WITH SHA256_PASSWORD by 'IDr1nk&IKn0wTh1ng5';
-- give tyrionlannister some permissions
GRANT DELETE,INSERT,SELECT,UPDATE
on scrumpm1.* to 'tyrionlannister'@'localhost';
-- Khaleesi wants him to have some escalated privilages
GRANT ALTER ROUTINE,CREATE ROUTINE,CREATE VIEW,
EVENT,EXECUTE,INDEX,INSERT,REFERENCES,SHOW VIEW
on scrumpm1.* to 'tyrionlannister'@'localhost';


-- creating a guest user who can only really read stuff
create user 'guest'@'localhost' Identified WITH SHA256_PASSWORD by '1AmN0On3?';
-- grant only select
GRANT SELECT on scrumpm1.* to 'guest'@'localhost';
