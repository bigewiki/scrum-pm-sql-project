-- test
-- humble beignings right here...
delimiter EOF
CREATE function test1()
RETURNS INT
READS SQL DATA
BEGIN
    set @result = 1;
    RETURN (select @result);
END EOF
delimiter ;

-- test2
-- pass in the id for a user
delimiter EOF
CREATE function test2(passedUser INT)
RETURNS CHAR(30)
READS SQL DATA
BEGIN
    SELECT CONCAT(fname,' ',lname) INTO @result FROM users WHERE id = passedUser;
    RETURN (@result);
END EOF
delimiter ;


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

-- get current next sprint
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
