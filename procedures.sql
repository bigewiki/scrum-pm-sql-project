-- drop the procedures if they exist
DROP procedure IF EXISTS allStories;
DROP procedure IF EXISTS storyToSprint;
DROP procedure IF EXISTS storyToCurrentSprint;
DROP procedure IF EXISTS storyToNextSprint;
DROP procedure IF EXISTS moveOverdueStories;
DROP procedure IF EXISTS upgradeOverdueStories;
DROP procedure IF EXISTS createFutureSprint;

-- display all stories
delimiter EOF
CREATE PROCEDURE allStories()
BEGIN
  SELECT s.name,s.description,CONCAT(u.fname,' ',u.lname) AS owner
  FROM stories AS s JOIN users u ON (u.id=s.owner);
END EOF
delimiter ;

-- uddate story to sprint
delimiter EOF
CREATE PROCEDURE storyToSprint(storyid INT, sprintid INT)
BEGIN
  UPDATE stories SET sprint_id = sprintid WHERE id = storyid;
END EOF
delimiter ;

-- assign to current sprint
-- dependency: currentSprint() from functions.sql
delimiter EOF
CREATE PROCEDURE storyToCurrentSprint(storyid INT)
BEGIN
  UPDATE stories SET sprint_id = currentSprint() WHERE id = storyid;
END EOF
delimiter ;

-- assign to next sprint
-- dependency: nextSprint() from functions.sql
delimiter EOF
CREATE PROCEDURE storyToNextSprint(storyid INT)
BEGIN
  UPDATE stories SET sprint_id = nextSprint() WHERE id = storyid;
END EOF
delimiter ;

-- move last sprints stories into this sprint if they're not complete
-- note that comparing against NULL requires 'IS' and otherwise will not behave as expected
delimiter EOF
CREATE PROCEDURE moveOverdueStories()
BEGIN
  UPDATE stories SET sprint_id = currentSprint() WHERE sprint_id = lastSprint() AND status NOT LIKE 'complete' OR sprint_id = lastSprint() AND status IS NULL;
END EOF
delimiter ;

-- move last sprint's stories AND promote the priority
-- undo for testing:
-- UPDATE stories set sprint_id = lastSprint() where sprint_id = currentSprint();
delimiter EOF
CREATE PROCEDURE upgradeOverdueStories()
BEGIN
  DECLARE n INT DEFAULT 0;
  DECLARE i INT DEFAULT 0;
  DECLARE resultId INT DEFAULT NULL;
  DECLARE resultPriority VARCHAR(20) DEFAULT NULL;
  SET i = 0;
  SELECT COUNT(*) INTO n FROM stories WHERE sprint_id = lastSprint() AND status NOT LIKE 'complete' OR sprint_id = lastSprint() AND status IS NULL;
  WHILE i < n DO
    SELECT id,priority INTO resultId,resultPriority FROM stories WHERE sprint_id = lastSprint() AND status NOT LIKE 'complete' OR sprint_id = lastSprint() AND status IS NULL LIMIT 1;
    IF resultPriority like 'low' THEN
      UPDATE stories SET sprint_id = currentSprint(), priority = 'medium' WHERE id = resultId;
    ELSEIF resultPriority like 'medium' THEN
      UPDATE stories SET sprint_id = currentSprint(), priority = 'high' WHERE id = resultId;
    ELSE
      UPDATE stories SET sprint_id = currentSprint(), priority = 'low' WHERE id = resultId;
    END IF;
    SET i = i + 1;
  END WHILE;
END EOF
delimiter ;


DROP procedure IF EXISTS displayStoryComments;
-- display a passed story's comments in the appropriate hierarchy
-- CALL displayStoryComments(3);
delimiter EOF
CREATE PROCEDURE displayStoryComments(storyId INT)
BEGIN
  SELECT c.id as 'comment_id', c.parent as 'parent_id', c.content ,CONCAT(u.fname,' ',u.lname) AS 'user'
  FROM comments c JOIN stories s ON (c.story_id=s.id)
  JOIN users u ON (c.owner=u.id)
  WHERE s.id = storyId
  GROUP BY c.story_id,c.parent;
END EOF
delimiter ;


DROP procedure IF EXISTS displayStoryTasks;
-- display a passed story's task and owner
-- CALL displayStoryTasks(3);
delimiter EOF
CREATE PROCEDURE displayStoryTasks(storyId INT)
BEGIN
  SELECT t.id AS 'task_id', t.name AS 'task_name', s.name as 'story_name', u.id AS 'owner_id', CONCAT(u.fname,' ',u.lname) AS 'owner_name'
  FROM tasks AS t JOIN stories s ON (t.story_id=s.id)
  LEFT JOIN users u ON (t.owner=u.id)
  WHERE s.id = storyId;
END EOF
delimiter ;



-- create the futureSprint() if it doesn't exist
-- drop procedure createFutureSprint;
-- call createFutureSprint();
-- DELETE FROM sprints WHERE id = futureSprint();
-- SELECT * FROM sprints WHERE id = futureSprint();
delimiter EOF
CREATE PROCEDURE createFutureSprint()
BEGIN
  DECLARE futureSprint INT;
  DECLARE startDate DATE;
  DECLARE endDate Date;
  DECLARE sprintNum INT;
  SELECT id INTO futureSprint FROM sprints WHERE id = futureSprint();
  IF futureSprint = futureSprint() THEN
    signal SQLSTATE '45000' set MESSAGE_TEXT = "The future sprint already exists";
  ELSE
    SELECT end_date INTO startDate FROM sprints WHERE id = nextSprint();
    SELECT DATE_ADD(startDate, INTERVAL 1 DAY) INTO startDate;
    SELECT DATE_ADD(startDate, INTERVAL 13 DAY) INTO endDate;
    SELECT `number` INTO sprintNum FROM sprints
    WHERE `quarter` = whatQuarter(startDate) AND YEAR(start_date) = YEAR(startDate)
    ORDER BY `number` DESC LIMIT 1;
    IF sprintNum IS NOT NULL THEN
      SET sprintNum = sprintNum + 1;
    ELSE
      SET sprintNum = 1;
    END IF;
    INSERT INTO `sprints` (`id`,`quarter`,`number`,`start_date`,`end_date`) VALUES
    (nextSprint()+1,whatQuarter(startDate),sprintNum,startDate,endDate);
  END IF;
END EOF
delimiter ;


-- create the current sprint
DROP PROCEDURE IF EXISTS createCurrentSprint;
-- CALL createCurrentSprint('2019-10-10');
delimiter EOF
CREATE PROCEDURE createCurrentSprint(startDate DATE)
BEGIN
  DECLARE endDate Date;
  DECLARE sprintNum INT;
  DECLARE prevSprintNum INT;
  IF currentSprint() IS NOT NULL THEN
    signal SQLSTATE '45000' set MESSAGE_TEXT = "The current sprint already exists";
  ELSE
    select MAX(number) INTO prevSprintNum from sprints WHERE quarter = whatQuarter(CURDATE());
    SELECT DATE_ADD(startDate, INTERVAL 13 DAY) INTO endDate;
    IF prevSprintNum IS NULL OR prevSprintNum = '' THEN
        SET sprintNum = 1;
    ELSE
        SET sprintNum = prevSprintNum + 1;
    END IF;
    INSERT INTO `sprints` (`quarter`,`number`,`start_date`,`end_date`)
    VALUES (whatQuarter(CURDATE()) ,sprintNum,startDate,endDate);
  END IF;
END EOF
delimiter ;

            
            
-- display a sprint and its stories, param is the sprint id            
DROP PROCEDURE IF EXISTS displaySprint;
-- CALL displaySprint(currentSprint());
delimiter EOF
CREATE PROCEDURE displaySprint(sprintNum INT)
BEGIN
  SELECT st.id AS 'story_id',sp.quarter,sp.number AS 'sprint_number',sp.start_date AS 'sprint_start',sp.end_date AS 'sprint_end',st.name AS "story_name",CONCAT(u.fname,' ',u.lname) AS 'story_owner'
  FROM sprints sp JOIN stories st ON (st.sprint_id=sp.id)
  JOIN users u ON (st.owner=u.id)
  WHERE sp.id = sprintNum;
END EOF
delimiter ;

            
-- display a story's details, param is the story id
DROP PROCEDURE IF EXISTS displayStory;
-- CALL displayStory(3);
delimiter EOF
CREATE PROCEDURE displayStory(storyNum INT)
BEGIN
  SELECT st.id AS 'story_id',st.name AS "story_name",CONCAT(u.fname,' ',u.lname) AS 'story_owner',sp.id AS 'sprint_id',sp.start_date AS 'sprint_start',sp.end_date AS 'sprint_end'
  FROM stories st LEFT JOIN sprints sp ON (sp.id=st.sprint_id)
  LEFT JOIN users u ON (st.owner=u.id)
  WHERE st.id = storyNum
  ;
END EOF
delimiter ;
