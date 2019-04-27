-- --- --- --- --
-- Queries
-- --- --- --- --

-- simple display of users and roles
SELECT u.fname, u.lname, r.role_name, r.role_description
FROM users AS u JOIN roles r ON (u.role_id=r.id);

-- display story owners
SELECT s.name,s.description,s.priority,CONCAT(u.fname,' ',u.lname) AS owner
FROM stories AS s JOIN users u ON (u.id=s.owner)\G

-- display story owners and their role!
SELECT s.name,s.description,s.priority,CONCAT(u.fname,' ',u.lname) AS owner,r.role_name
FROM stories AS s JOIN users u ON (u.id=s.owner)
JOIN roles r ON (u.role_id=r.id)\G

-- display issues and their stories
SELECT i.name, i.description, s.name AS story
FROM issues AS i LEFT JOIN stories s ON (i.story_id=s.id)\G

-- display task, story, and owner sorted by story
-- relates to 2a and 2b in ./explain.txt
SELECT t.name AS `task name`, s.name as `story name`, CONCAT(u.fname,' ',u.lname) AS owner
FROM tasks AS t JOIN stories s ON (t.story_id=s.id)
LEFT JOIN users u ON (t.owner=u.id) ORDER BY s.name;

-- adding unique key to the story names
-- relates to 2b in ./explain.txt
ALTER TABLE stories ADD UNIQUE (name);

-- diplay a sprint's stories
SELECT sp.id AS 'sprint', sp.quarter, st.name
FROM stories st JOIN sprints sp ON (st.sprint_id=sp.id);

-- update story's sprint to the current sprint
-- requires the currentSprint function
UPDATE stories SET sprint_id = currentSprint() WHERE id = 1;

-- updating a couple stories to next sprint
-- requires the nextSprint function
UPDATE stories SET sprint_id = nextSprint() WHERE id = 2;
UPDATE stories SET sprint_id = nextSprint() WHERE id = 4;

-- select those stories from nextSprint
-- requires the nextSprint function
select * from stories WHERE sprint_id = nextSprint()\G

-- getting the sum of the time_size for the stories in the nextSprint
-- requires the nextSprint function
SELECT SUM(time_size) AS 'Total Sprint Size' FROM stories WHERE sprint_id = nextSprint();

-- select current sprint
-- function was created to do this called currentSprint
SELECT * FROM sprints WHERE start_date < current_date AND end_date > current_date;

-- select incomplete stories from last sprint
SELECT * FROM stories WHERE sprint_id = lastSprint();

-- select comments for a story and display their user
SELECT c.id,c.content,c.owner,s.name
FROM comments c JOIN stories s ON (c.story_id=s.id);

-- select comments for a story and nest their children...
-- 'an insane set of self joins'
SELECT CONCAT(c1.owner,': ',c1.content), CONCAT(c2.owner,': ',c2.content), CONCAT(c3.owner,': ',c3.content), CONCAT(c4.owner,': ',c4.content), CONCAT(c5.owner,': ',c5.content), CONCAT(c6.owner,': ',c6.content)
FROM comments AS c1
LEFT JOIN comments AS c2 ON (c1.id=c2.parent)
LEFT JOIN comments AS c3 ON (c2.id=c3.parent)
LEFT JOIN comments AS c4 ON (c3.id=c4.parent)
LEFT JOIN comments AS c5 ON (c4.id=c5.parent)
LEFT JOIN comments AS c6 ON (c5.id=c6.parent)
WHERE c1.story_id = 2;

-- search story by owner (bad way)
-- this relates to 3a in ./explain.txt
SELECT s.name AS 'story name', CONCAT(u.fname,' ',u.lname) AS 'name'
FROM stories AS s JOIN users AS u ON (u.id = s.owner)
WHERE CONCAT(u.fname,' ',u.lname) = 'Tyrion Lannister';

-- search story by owner (better way)
-- this relates to 3b in ./explain.txt
SELECT s.name AS 'story name', CONCAT(u.fname,' ',u.lname) AS 'name'
FROM stories AS s JOIN users AS u ON (u.id = s.owner)
WHERE u.fname like 'Tyrion' AND u.lname like 'Lannister';

-- delete a task
-- we just fired Jora so lets delete his tasks
-- we should've reassigned them but...
-- -- first lets find his tasks;
SELECT * FROM tasks AS t JOIN users u ON (t.owner = u.id) WHERE u.id = 2\G
-- -- now lets delete them, but syntax needs to be changed up a bit
DELETE t FROM tasks AS t JOIN users u ON (t.owner = u.id)
WHERE u.id = 2;

-- if we had hindsigh we wouldn't updated the owners of that task:
UPDATE tasks set owner = 3 WHERE owner = 2;

-- lets find out what stories Jora owns since we just canned him...
-- we'll use a subquery to get those
SELECT * FROM stories WHERE owner IN (
  SELECT id FROM users WHERE id = 2
)\G

-- if we didn't know Jorah's id:
SELECT * FROM stories WHERE owner IN (
  SELECT id FROM users WHERE fname = 'Jorah'
)\G

-- we want to add a status column to the tasks table
-- NOTE this has been added to the appropriate column in ./tables.sql
ALTER TABLE tasks
ADD COLUMN `status` VARCHAR(30) NULL DEFAULT NULL;

--
