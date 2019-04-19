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
