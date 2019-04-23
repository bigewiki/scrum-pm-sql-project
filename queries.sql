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

-- display task, story, and owner
SELECT t.name AS `task name`, s.name as `story name`, CONCAT(u.fname,' ',u.lname) AS owner
FROM tasks AS t JOIN stories s ON (t.story_id=s.id)
LEFT JOIN users u ON (t.owner=u.id) ORDER BY s.name;

-- diplay a sprint's story
SELECT sp.id AS 'sprint', sp.quarter, st.name
FROM stories st JOIN sprints sp ON (st.sprint_id=sp.id);

-- update sprint's story
UPDATE stories SET sprint_id = 2 WHERE id = 1;

-- select current sprint
SELECT * FROM sprints WHERE start_date < current_date AND end_date > current_date;

-- select incomplete stories from last sprint
SELECT * FROM stories WHERE sprint_id = lastSprint();

-- select comments for a story and display their user
SELECT c.id,c.content,c.owner,s.name
FROM comments c JOIN stories s ON (c.story_id=s.id);
