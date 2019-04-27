-- create a temptable view for stories, status, and owners
-- drop view story_status;
Create algorithm = temptable view story_status AS
SELECT s.name,s.status,CONCAT(u.fname,' ',u.lname) AS 'owner'
FROM stories AS s JOIN users u ON (s.owner=u.id);
-- view the temp table:
-- SELECT * from story_status;


-- create another temptable for all users and their roles
-- drop view user_roles;
Create algorithm = temptable view user_roles AS
SELECT CONCAT(u.fname,' ',u.lname) AS 'user',r.role_name
FROM users AS u JOIN roles r ON (u.role_id=r.id);
-- view the temp table:
-- SELECT * from user_roles;
