-- drop functions if they exist:
DROP function IF EXISTS getRole;
DROP function IF EXISTS getOwner;
DROP function IF EXISTS currentSprint;
DROP function IF EXISTS nextSprint;
DROP function IF EXISTS lastSprint;
DROP function IF EXISTS futureSprint;
DROP function IF EXISTS whatQuarter;

-- display role of passed user
delimiter EOF
CREATE function getRole(passedUser INT)
RETURNS CHAR(30)
READS SQL DATA
BEGIN
    SELECT r.role_name into @result
    FROM users AS u JOIN roles r ON (u.role_id=r.id)
    WHERE u.id = passedUser;
    RETURN (@result);
END EOF
delimiter ;

-- get story's owner
delimiter EOF
CREATE function getOwner(passedStory INT)
RETURNS VARCHAR(30)
READS SQL DATA
BEGIN
    SELECT CONCAT(u.fname,' ',u.lname) INTO @result
    FROM stories AS s JOIN users u ON (u.id=s.owner) WHERE s.id = passedStory;
    RETURN(@result);
END EOF
delimiter ;

-- get current sprint
delimiter EOF
CREATE function currentSprint()
RETURNS INT
READS SQL DATA
BEGIN
  DECLARE result INT DEFAULT NULL;
  SELECT id INTO result FROM sprints WHERE start_date < current_date AND end_date > current_date;
  RETURN(result);
END EOF
delimiter ;

-- get next sprint
delimiter EOF
CREATE function nextSprint()
RETURNS INT
READS SQL DATA
BEGIN
  DECLARE result INT DEFAULT NULL;
  SELECT id INTO result FROM sprints WHERE start_date < current_date AND end_date > current_date;
  set result = result + 1;
  RETURN(result);
END EOF
delimiter ;

-- get last sprint
delimiter EOF
CREATE function lastSprint()
RETURNS INT
READS SQL DATA
BEGIN
  DECLARE result INT DEFAULT NULL;
  SELECT id INTO result FROM sprints WHERE start_date < current_date AND end_date > current_date;
  set result = result - 1;
  RETURN(result);
END EOF
delimiter ;

-- the sprint after next sprint
delimiter EOF
CREATE function futureSprint()
RETURNS INT
READS SQL DATA
BEGIN
  DECLARE result INT DEFAULT NULL;
  SELECT id INTO result FROM sprints WHERE start_date < current_date AND end_date > current_date;
  set result = result + 2;
  RETURN(result);
END EOF
delimiter ;

-- output which quarter it is
-- drop function whatQuarter;
-- select whatQuarter(current_date);
delimiter EOF
CREATE function whatQuarter(dateParam DATE)
RETURNS TINYINT(1)
READS SQL DATA
BEGIN
  DECLARE result TINYINT(1);
  IF MONTH(dateParam) < 4 THEN
    SET result = 1;
  ELSEIF MONTH(dateParam) > 3 AND MONTH(dateParam) < 7 THEN
    SET result = 2;
  ELSEIF MONTH(dateParam) > 6 AND MONTH(dateParam) < 10 THEN
    SET result = 3;
  ELSE
    SET result = 4;
  END IF;
  RETURN(result);
END EOF
delimiter ;
