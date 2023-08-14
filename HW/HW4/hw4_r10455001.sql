/***** use database *****/
USE DB_class;

/***** info *****/
CREATE TABLE self (
    StuID varchar(10) NOT NULL,
    Department varchar(10) NOT NULL,
    SchoolYear int DEFAULT 1,
    Name varchar(10) NOT NULL,
    PRIMARY KEY (StuID)
);

INSERT INTO self
VALUES ('r10455001', '基蛋所', 2, '陳品瑄');

SELECT DATABASE();
SELECT * FROM self;

/* Prepared statement */
PREPARE output FROM
'SELECT 身份,系所,年級,學號,姓名 FROM STUDENT  
WHERE 系所 = ?';

SET @department = "基蛋所";
EXECUTE output USING @department;

SET @other_department = "經濟系";
EXECUTE output USING @other_department;


/* Stored-function */
DELIMITER //
DROP FUNCTION IF EXISTS Split_Chinese //
CREATE FUNCTION Split_Chinese(姓名 varchar(225)) RETURNS varchar(225)
DETERMINISTIC 
BEGIN
     DECLARE Chinese varchar(225);
     SET Chinese = SUBSTRING_INDEX(姓名, '(', 1);
     RETURN Chinese;
END //

DELIMITER ;

DELIMITER //
DROP FUNCTION IF EXISTS Split_English //
CREATE FUNCTION Split_English(姓名 varchar(225)) RETURNS varchar(225)
DETERMINISTIC
BEGIN
     DECLARE English varchar(225);
     SET English = SUBSTRING_INDEX( SUBSTRING_INDEX(姓名, '(', -1), ')' , 1);
     RETURN English;
END //

DELIMITER ;

SELECT 姓名, Split_Chinese(姓名), Split_English(姓名), 系所, 年級, 學號, final_group, final_captain FROM STUDENT
WHERE final_group = "5";


/* Stored procedure */
DELIMITER //
DROP PROCEDURE IF EXISTS count_std //
CREATE PROCEDURE count_std(IN depart varchar(225), OUT STCOUNT int) 
BEGIN 
    SELECT COUNT(*)  FROM STUDENT WHERE 系所 = depart; 
END //

DELIMITER ;

SET @depart='基蛋所';
CALL count_std(@depart, @STCOUNT);
SET @depart='經濟系';  
CALL count_std(@depart, @STCOUNT);


/* Trigger I  */
DELIMITER //
DROP TRIGGER IF EXISTS captin_number //
CREATE TRIGGER captin_number AFTER UPDATE ON STUDENT FOR EACH ROW 
BEGIN
    SET @NUMCAPS = (SELECT COUNT(*) FROM STUDENT WHERE final_captain = 'Y');
END //

DELIMITER ;

SET @NUMCAPS = 1;
SELECT @NUMCAPS AS 'Number of Captain in table';
SELECT * FROM STUDENT WHERE final_captain = 'Y';

UPDATE STUDENT SET final_captain = 'Y'
WHERE 學號='R11246002' OR 學號='B07202043' OR 學號='B08305037' OR 學號='B08B01073' OR 學號='R10227105';

SELECT @NUMCAPS AS 'Number of Captain in table';
SELECT * FROM STUDENT WHERE final_captain = 'Y';


/* Trigger II */
CREATE TABLE INSERT_log (
     insert_ID varchar(225) primary key,
     user varchar(225),
     time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE DELETE_log (
     delete_ID varchar(225) primary key,
     user varchar(225),
     time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


DELIMITER //
DROP TRIGGER IF EXISTS insert_record //
CREATE TRIGGER insert_record AFTER INSERT ON STUDENT FOR EACH ROW 
BEGIN
    DECLARE performer varchar(225);
    SELECT USER() INTO performer;
    INSERT INTO INSERT_log VALUES (NEW.學號, performer,DEFAULT);
END //

DELIMITER ;


DELIMITER //
DROP TRIGGER IF EXISTS delete_record //
CREATE TRIGGER delete_record AFTER DELETE ON STUDENT FOR EACH ROW         
BEGIN
    DECLARE performer varchar(225);
    SELECT USER() INTO performer;
    INSERT INTO DELETE_log VALUES (OLD.學號, performer,DEFAULT);
END //

DELIMITER ;

SELECT * FROM INSERT_log;
SELECT * FROM DELETE_log;

INSERT INTO STUDENT VALUES ('學生', '測試系','1','R0000001','測試1','1.com','資料庫',DEFAULT, DEFAULT);
INSERT INTO STUDENT VALUES ('學生', '測試系','2','R0000002','測試2','2.com','資>料庫',DEFAULT, DEFAULT);
INSERT INTO STUDENT VALUES ('學生', '測試系','3','R0000003','測試3','3.com','資>料庫',DEFAULT, DEFAULT);

SELECT * FROM INSERT_log;

DELETE FROM STUDENT WHERE 學號 = 'R0000001';
DELETE FROM STUDENT WHERE 學號 = 'R0000002';

SELECT * FROM DELETE_log;

/* drop database */
DROP DATABASE DB_class;
