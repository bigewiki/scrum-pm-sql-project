-- if a task is created without an owner the status will be 'not started'
delimiter $
CREATE TRIGGER statusCheckTasks BEFORE INSERT on tasks
FOR EACH ROW BEGIN
    IF NEW.status IS NULL THEN
        set NEW.status = 'not started';
    END IF;
END$
delimiter ;

-- to test:
INSERT INTO `tasks` (`name`,`owner`,`story_id`) VALUES
('train specialists',1,2);
select * from tasks where name like 'train specialists';
-- IT WORKS!


-- when we create a story with no owner and no status update status to 'unassigned'
-- also check if the story is owned but there's not status, update to 'not started'
delimiter $
CREATE TRIGGER statusCheckStories BEFORE INSERT on stories
FOR EACH ROW BEGIN
    IF NEW.status IS NULL AND NEW.owner is NULL THEN
        set NEW.status = 'unassigned';
    ELSEIF NEW.status IS NULL THEN
        set NEW.status = 'not started';
    END IF;
END$
delimiter ;

-- to test first case:
INSERT INTO `stories` (`name`) VALUES
('gain favor of people');
select * from stories where name like 'gain favor of people'\G
-- to test second case:
INSERT INTO `stories` (`name`,`owner`) VALUES
('secure trading partners',3);
select * from stories where name like 'secure trading partners'\G
-- hooray they both work
