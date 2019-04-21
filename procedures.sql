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
