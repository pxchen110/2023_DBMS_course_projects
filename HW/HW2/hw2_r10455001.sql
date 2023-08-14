/* create and use database */
CREATE DATABASE Patient_Medical_RecordDB;
USE Patient_Medical_RecordDB;


/* info */
CREATE TABLE self ( 
     StuID varchar(10) NOT NULL,
     Name varchar(10) NOT NULL,
     Department varchar(10) NOT NULL,
     SchoolYear int DEFAULT 1,
     PRIMARY KEY (StuID)
     );

INSERT INTO self VALUES ("R10455001","陳品瑄","基蛋所","2");

SELECT DATABASE();
SELECT * FROM self;


/* create table */
CREATE TABLE Patient (
    PID varchar(10) primary key NOT NULL,       
    PName varchar(10) NOT NULL,
    Pblood enum('A','B','O','AB'),
    PCountry varchar(20) DEFAULT ('台灣')
    );

CREATE TABLE Allergy_list (
    PID varchar(10) NOT NULL,
    Allergy_type varchar(10) NOT NULL,
    primary key (PID,Allergy_type),
    foreign key (PID) REFERENCES Patient(PID)
    );

CREATE TABLE HealthQ (
    PID varchar(10) NOT NULL,
    Habit varchar(20) NOT NULL,
    Comment varchar(20) DEFAULT '有益健康',
    Frequency varchar(10) DEFAULT '每月一次',
    primary key (PID, Habit),
    foreign key (PID) REFERENCES Patient(PID) ON UPDATE CASCADE
   );

CREATE TABLE Medicine (
    MName varchar(10) primary key NOT NULL,
    MPRICE int, 
    Mtaking int,
    Mtime enum('飯後','睡前','其他'),
    CONSTRAINT taking_maximum CHECK (Mtaking <= 5)
    );

CREATE TABLE Side_effect (
   MName varchar(10) NOT NULL,
   Mside_effect varchar(20) NOT NULL,
   primary key (MName, Mside_effect),
   foreign key (MName) REFERENCES Medicine(MName)
   );

CREATE TABLE Oral_Medicine (
   MName varchar(10) primary key NOT NULL,
   Mtaking_type varchar(20) DEFAULT '口服',
   foreign key (MName) REFERENCES Medicine(MName)
   );

CREATE TABLE Injection_Medicine (
   MName varchar(10) primary key NOT NULL,
   Mtaking_type varchar(20) DEFAULT '注射',
   foreign key (MName) REFERENCES Medicine(MName)
   );

CREATE TABLE Doctor (
   DID varchar(10) primary key NOT NULL,
   DName varchar(20) NOT NULL,
   D_Position enum('醫師','主任醫師'),
   D_SupervisorID varchar(10),
   foreign key (D_SupervisorID) REFERENCES Doctor(DID) ON UPDATE CASCADE
   );

CREATE TABLE HealthEP (
   PID varchar(10) primary key NOT NULL,
   Pname varchar(20) NOT NULL,
   Pmax int, 
   Pfee int DEFAULT 0,
   CONSTRAINT max_participate CHECK (Pmax <= 30 AND Pmax >= 0),
   CONSTRAINT max_join_price CHECK (Pfee <= 500)
   );

CREATE TABLE Plocation (
   PID varchar(10) primary key NOT NULL,
   Floor int,
   Room int NOT NULL,
   foreign key (PID) REFERENCES HealthEP(PID)
   );

CREATE TABLE Weekly_Project (
   PID varchar(10) primary key NOT NULL,
   PFrequency varchar(20) DEFAULT '每週一次',
   foreign key (PID) REFERENCES HealthEP(PID)
   );

CREATE TABLE Monthly_Project (
   PID varchar(10) primary key NOT NULL,
   PFrequency varchar(20) DEFAULT '每月一次',
   foreign key (PID) REFERENCES HealthEP(PID)
   );

CREATE TABLE Patient_take_Medicine (
   PatientID varchar(10) NOT NULL,
   MedID varchar(10) NOT NULL,
   CONSTRAINT PM_p_info_refer foreign key (PatientID) REFERENCES Patient(PID),
   CONSTRAINT PM_m_info_refer foreign key (MedID) REFERENCES Medicine(MName),
   CONSTRAINT take_PM_unique UNIQUE (PatientID, MedID)
   );

CREATE TABLE Patient_attend_Project (
   PatientID varchar(10) NOT NULL,
   ProjectID varchar(10) NOT NULL,
   CONSTRAINT PP_pat_info_refer foreign key (PatientID) REFERENCES Patient(PID),
   CONSTRAINT PP_pro_info_refer foreign key (ProjectID) REFERENCES HealthEP(PID),
   CONSTRAINT take_PP_unique UNIQUE (PatientID, ProjectID)
   );

CREATE TABLE Patient_seek_Doctor (
   PatientID varchar(10) NOT NULL,
   DoctorID varchar(10) NOT NULL,
   CONSTRAINT PD_p_info_refer foreign key (PatientID) REFERENCES Patient(PID),
   CONSTRAINT PD_d_info_refer foreign key (DoctorID) REFERENCES Doctor(DID),
   CONSTRAINT take_PD_unique UNIQUE (PatientID, DoctorID)
   );

CREATE TABLE Doctor_hold_Project (
   DoctorID varchar(10) NOT NULL,
   ProjectID varchar(10) NOT NULL,
   CONSTRAINT DP_d_info_refer foreign key (DoctorID) REFERENCES Doctor(DID),
   CONSTRAINT DP_p_info_refer foreign key (ProjectID) REFERENCES HealthEP(PID),
   CONSTRAINT take_DP_unique UNIQUE (DoctorID, ProjectID)
   ); 


/* insert */
INSERT INTO Patient VALUES ("123","王大明","A",DEFAULT),("124","安娜","B","美國"),("125","林珊珊","O",DEFAULT),("126","吳所謂","A","美國");
INSERT INTO Allergy_list VALUES ("123","抗生素"),("123","阿斯匹靈"),("124","無"),("125","抗生素"),("126","無");
INSERT INTO HealthQ VALUES ("123","運動",DEFAULT,DEFAULT),("124","規律睡眠","有精神","每天"),("125","低鈉飲食",DEFAULT,"每天");
INSERT INTO Medicine VALUES ("阿斯匹靈",50,1,"飯後"),("抗組織胺",20,1,"睡前"),("胰島素",200,1,"飯後"),("抗生素",150,2,"其他");
INSERT INTO Side_effect VALUES ("阿斯匹靈","紅疹"),("阿斯匹靈","噁心想吐"),("抗組織胺","嗜睡"),("胰島素","低血糖"),("胰島素","水腫"),("抗生素","發燒");
INSERT INTO Oral_Medicine VALUES ("阿斯匹靈",DEFAULT),("抗組織胺",DEFAULT),("抗生素",DEFAULT);
INSERT INTO Injection_Medicine VALUES ("抗組織胺",DEFAULT),("胰島素",DEFAULT),("抗生素",DEFAULT);
INSERT INTO Doctor VALUES ("D103","洪大偉","主任醫師",NULL),("D101","林忠偉","醫師","D103"),("D105","吳曉偉","醫師","D101"),("D106","孫曉偉","醫師","D101");
INSERT INTO HealthEP VALUES ("Weight101","減重講座",20,DEFAULT),("Drug101","藥物使用講座",15,100),("Allergy102","過敏防治",30,50),("Allergy103","進階過敏防治",30,50),("Diabete2","糖尿病衛教",15,0),("Diet201","健康外食",30,100);
INSERT INTO Plocation VALUES ("Weight101",2,209),("Drug101",5,505),("Allergy102",3,317),("Allergy103",3,317),("Diabete2",1,105),("Diet201",3,302);
INSERT INTO Weekly_Project VALUES ("Weight101",DEFAULT),("Drug101",DEFAULT),("Diabete2",DEFAULT);
INSERT INTO Monthly_Project VALUES ("Allergy102",DEFAULT),("Allergy103",DEFAULT),("Diet201",DEFAULT);
INSERT INTO Patient_take_Medicine VALUES ("123","抗組織胺"),("124","阿斯匹靈"),("124","胰島素"),("125","阿斯匹靈"),("126","抗生素");
INSERT INTO Patient_attend_Project VALUES ("123","Drug101"),("123","Allergy102"),("124","Diabete2"),("125","Drug101"),("126","Allergy102");
INSERT INTO Patient_seek_Doctor VALUES ("123","D103"),("123","D106"),("124","D101"),("125","D101"),("126","D105"),("126","D103");
INSERT INTO Doctor_hold_Project VALUES ("D103","Drug101"),("D103","Allergy102"),("D103","Allergy103"),("D101","Weight101"),("D101","Diabete2"),("D101","Diet201"),("D106","Drug101");


/* create two views (Each view should be based on two tables.)*/
CREATE VIEW patient_Taiwan_allergy_and_medicine AS
SELECT Patient.PID, PName, PCountry, Allergy_type, MName 
FROM Patient_take_Medicine PM
INNER JOIN Medicine ON Medicine.MName = PM.MedID
INNER JOIN Patient ON Patient.PID = PM.PatientID 
INNER JOIN Allergy_list ON Allergy_list.PID = Patient.PID
WHERE PCountry = "台灣";

CREATE VIEW patient_USA_doctor AS
SELECT Patient.PID, PName, PCountry, DName
FROM Patient_seek_Doctor PD
INNER JOIN Doctor ON Doctor.DID = PD.DoctorID
INNER JOIN Patient ON Patient.PID = PD.PatientID
WHERE PCountry = "美國"; 

/* select from all tables and views */
SELECT Patient.PID, PName, Pblood ,PCountry, Allergy_type
FROM Patient
INNER JOIN Allergy_list  
ON Patient.PID = Allergy_list.PID;

SELECT Patient.PID, PName, Pblood ,PCountry, Habit, Comment, Frequency
FROM Patient
INNER JOIN HealthQ
ON Patient.PID = HealthQ.PID;

SELECT Medicine.MName, MPRICE, Mtaking, Mtime, Mside_effect 
FROM Medicine 
INNER JOIN Side_effect 
ON Medicine.MName = Side_effect.MName;

SELECT Medicine.*, Mside_effect, Mtaking_type 
FROM Oral_Medicine OM
INNER JOIN Medicine ON OM.MName = Medicine.MName
INNER JOIN Side_effect ON OM.MName = Side_effect.MName; 
 
SELECT Medicine.*, Mside_effect, Mtaking_type
FROM Injection_Medicine IM
INNER JOIN Medicine ON IM.MName = Medicine.MName
INNER JOIN Side_effect ON IM.MName = Side_effect.MName;

SELECT *
FROM Doctor;

SELECT HealthEP.PID, Pname, Floor, Room 
FROM HealthEP
INNER JOIN Plocation
ON HealthEP.PID = Plocation.PID;

SELECT HealthEP.*, Floor, Room,  PFrequency
FROM Weekly_Project WP
INNER JOIN HealthEP ON WP.PID = HealthEP.PID
INNER JOIN Plocation ON WP.PID = Plocation.PID;

SELECT HealthEP.*, Floor, Room, PFrequency
FROM Monthly_Project MP
INNER JOIN HealthEP ON MP.PID = HealthEP.PID
INNER JOIN Plocation ON MP.PID = Plocation.PID; 

SELECT Patient.*, Medicine.*
  FROM Patient_take_Medicine PM
INNER JOIN Patient 
ON Patient.PID = PM.PatientID
INNER JOIN Medicine
ON Medicine.MName = PM.MedID;

SELECT Patient.*, HealthEP.* 
  FROM Patient_attend_Project PP
INNER JOIN Patient
ON Patient.PID = PP.PatientID
INNER JOIN HealthEP
ON HealthEP.PID = PP.ProjectID;

SELECT Patient.*, Doctor.*
  FROM Patient_seek_Doctor PD
INNER JOIN Patient
ON Patient.PID = PD.PatientID
INNER JOIN Doctor
ON Doctor.DID = PD.DoctorID;

SELECT Doctor.*, HealthEP.*
  FROM Doctor_hold_Project DP
INNER JOIN Doctor
ON Doctor.DID = DP.DoctorID
INNER JOIN HealthEP
ON HealthEP.PID = DP.ProjectID;

SELECT * FROM patient_Taiwan_allergy_and_medicine;

SELECT * FROM patient_USA_doctor;

/* drop database */
DROP DATABASE Patient_Medical_RecordDB;
