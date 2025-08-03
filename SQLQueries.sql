--***** CREATE DATABASE *****
CREATE DATABASE ExaminationDB;
go 
USE ExaminationDB;
--***** CREATE SCHEMAS *****
--auth, academic, exams
CREATE SCHEMA auth;
go
CREATE SCHEMA academic;
go
CREATE SCHEMA exams;
--***** CREATE TABLES ******

--1.USERS table
CREATE TABLE auth.USERS
(
userId INT IDENTITY(1,1) PRIMARY KEY,
Fname VARCHAR(20) NOT NULL,
Lname VARCHAR(20) NOT NULL,
Email VARCHAR(255) UNIQUE,
Password VARCHAR(255) CHECK (LEN(password)>=8) NOT NULL,
Role VARCHAR(255),
lastLogin DATE DEFAULT GETDATE()
);
go
--2.STUDENTS table
CREATE TABLE auth.STUDENTS
(
studentID INT PRIMARY KEY,
personalInfo VARCHAR(255),
Status VARCHAR(255)
);
go
--3.INSTRUCTORS table
CREATE TABLE auth.INSTRUCTORS
(
instructorId INT PRIMARY KEY,
Specilization VARCHAR(255),
Qualifications VARCHAR(255),
yearsOfExperience INT
);
go
--4.MANGER table
CREATE TABLE auth.training_manager
(
managerId INT PRIMARY KEY
);
go
--5.BRANCHES table
CREATE TABLE academic.BRANCHES
(
branchId INT PRIMARY KEY,
Name VARCHAR(255),
Description VARCHAR(255)
);
go
--6.INTAKES table
CREATE TABLE academic.INTAKES 
(
IntakeID INT PRIMARY KEY,
StartDate DATE,
EndDATE DATE,
TrackID INT 
);
go
--7.TRACKS table
CREATE TABLE academic.TRACKS
(
TrackID INT PRIMARY KEY,
Name VARCHAR(255),
Description VARCHAR(255),
BranchID INT
);
go
--8.COURSES table
CREATE TABLE academic.COURSES
(
CourseID INT PRIMARY KEY,
Name VARCHAR(255),
Description VARCHAR(255),
MaxDegree INT,
MinDegree INT,
mng_id INT,
intake_id INT
);
go
--9.instr_intake_course table
CREATE TABLE academic.instr_intake_course
(
instructor_id INT,
intake_id INT,
course_id INT,
HireDate DATE,
PRIMARY KEY(instructor_id,intake_id, course_id)
);
go
--10.QUESTIONS table
CREATE TABLE exams.QUESTIONS
(
QuestionID INT PRIMARY KEY,
Content VARCHAR(255),
Type VARCHAR(255),
Points INT,
CorrectAnswer VARCHAR(255),
BestAcceptedAnswer VARCHAR(255),
course_id INT
);
go
--11.Student_Answers table
CREATE TABLE exams.student_answer
(
StudentAnswerID INT PRIMARY KEY,
student_id INT,
question_id INT,
answer_option_id INT,
TextAnswer varchar(255),
points INT 
);

go
--12.answer_options table
CREATE TABLE exams.answer_options
(
AnswerOptionID INT PRIMARY KEY,
Content VARCHAR(225),
IsCorrect CHAR(1),
question_id INT
);
go
--13.EXAMS table
CREATE TABLE exams.EXAMS
(
ExamID INT PRIMARY KEY,
StartTime DATETIME,
EndTime DATETIME,
TotalPoints INT,
Type VARCHAR(30) DEFAULT 'exam',
course_id INT,
instructor_id INT
);
go
--14.exam_questions table
CREATE TABLE exams.exam_questions
(
ExamID INT,
QuestionID INT,
PRIMARY KEY(ExamID, QuestionID)
);

--***** ADDING GOREIGN KEY CONSTRAINT TO TABLES *****


--1.STUDENTS table
ALTER TABLE auth.STUDENTS
ADD CONSTRAINT student_FK FOREIGN KEY(StudentID) REFERENCES auth.USERS(UserID);
--3.INSTRUCTORS table
ALTER TABLE auth.INSTRUCTORS
ADD CONSTRAINT instructor_FK FOREIGN KEY(InstructorID) REFERENCES auth.USERS(UserID);
--4.MANGER table
ALTER TABLE auth.training_manager
ADD CONSTRAINT manager_FK FOREIGN KEY(ManagerID) REFERENCES auth.USERS(UserID);
--6.INTAKES table
ALTER TABLE academic.INTAKES
ADD CONSTRAINT intake_FK FOREIGN KEY (TrackID) REFERENCES [academic].[TRACKS](TrackID);
--7.TRACKS table
ALTER TABLE academic.TRACKS
ADD CONSTRAINT track_FK FOREIGN KEY([BranchID]) REFERENCES [academic].[BRANCHES](branchId);
--8.COURSES table
ALTER TABLE [academic].[COURSES]
ADD CONSTRAINT track_FK1 FOREIGN KEY([intake_id]) REFERENCES[academic].[INTAKES](IntakeID),
    CONSTRAINT track_FK2 FOREIGN KEY([mng_id]) REFERENCES[auth].[training_manager](managerId);
--9.instr_intake_course table
ALTER TABLE [academic].[instr_intake_course]
ADD CONSTRAINT FK11 FOREIGN KEY([course_id]) REFERENCES[academic].[COURSES]([CourseID]),
    CONSTRAINT FK22 FOREIGN KEY([instructor_id]) REFERENCES[auth].[INSTRUCTORS]([instructorId]),
    CONSTRAINT FK33 FOREIGN KEY([intake_id]) REFERENCES[academic].[INTAKES]([IntakeID]);
--10.QUESTIONS table
ALTER TABLE exams.QUESTIONS
ADD CONSTRAINT question_FK FOREIGN KEY([course_id]) REFERENCES [academic].[COURSES]([CourseID]);
--11.Student_Answers table
ALTER TABLE [exams].[student_answer]
ADD CONSTRAINT Student_Answer_FK1 FOREIGN KEY([student_id]) REFERENCES[auth].[STUDENTS]([studentID]),
    CONSTRAINT Student_Answer_FK2 FOREIGN KEY([question_id]) REFERENCES[exams].[QUESTIONS]([QuestionID]),
    CONSTRAINT Student_Answers_FK3 FOREIGN KEY([answer_option_id]) REFERENCES[exams].[answer_options]([AnswerOptionID])
    ;
--12.Answer_Options table
ALTER TABLE exams.answer_options
ADD CONSTRAINT Answer_Option_FK FOREIGN KEY([question_id]) REFERENCES[exams].[QUESTIONS]([QuestionID]);
--13.EXAMS table
ALTER TABLE exams.Exams
ADD CONSTRAINT exam_FK1 FOREIGN KEY([course_id]) REFERENCES[academic].[COURSES]([CourseID]) ,
    CONSTRAINT exam_FK2 FOREIGN KEY([instructor_id]) REFERENCES [auth].[INSTRUCTORS]([instructorId]);
--14.exam_questions table
ALTER TABLE exams.exam_questions
ADD CONSTRAINT exam_question_FK1 FOREIGN KEY([ExamID]) REFERENCES [exams].[EXAMS]([ExamID]),
    CONSTRAINT exam_question_FK2 FOREIGN KEY([QuestionID]) REFERENCES[exams].[QUESTIONS]([QuestionID]);

--***** INSERTING DATA INTO TABLE *****

--1.ADD BRANCHES 
INSERT INTO [academic].[BRANCHES] (branchId, Name, Description)
VALUES
(1, 'Giza', 'Main branch in Giza'),
(2, 'Nasr City', 'Branch in Nasr City'),
(3, 'Alexandria', 'Branch in Alexandria'),
(4, 'Assiut', 'Branch in Assiut'),
(5, 'Mansoura', 'Branch in Mansoura');
;
        
--2.ADD INTAKES 
INSERT INTO [academic].[INTAKES]
VALUES;
--3.ADD TRACKS
INSERT INTO [academic].[TRACKS]
VALUES;
--4.ADD STUDENT
CREATE PROCEDURE AddStudent
(
@userId INT,
@Fname VARCHAR(20),
@Lname VARCHAR(20),
@Email VARCHAR(255),
@Password VARCHAR(255),
@Role VARCHAR(255),
@personalInfo VARCHAR(255),
@Status VARCHAR(255)
)
AS
BEGIN
INSERT INTO auth.USERS(userId, Fname, Lname, Email, Password, Role)
VALUES (@userId, @Fname, @Lname, @Email, @Password, @Role)

INSERT INTO auth.STUDENTS(studentID, personalInfo, Status)
VALUES (@userId, @personalInfo, @Status)
END;
--5.ADD INSTRUCTOR 
--6.ADD MANAGER 
--7.ADD QUESTIONS 
--8.Student_Answers table
--9.Answer_Options table
--10.COURSES table
--11.EXAMS table
--12.instr_intake_course table
--13.exam_questions table

--***** CREATE VIEWS *****
