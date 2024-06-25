USE play;

SET STATISTICS IO ON;
SET STATISTICS TIME ON;



SET NOCOUNT ON;
DROP TABLE IF EXISTS one;
GO
CREATE TABLE one
(
	FirstColumn VARCHAR(40),
	SecondColumn VARCHAR(40),
	ThirdColumn VARCHAR(40),
	[timestamp] DATETIME DEFAULT GETDATE()
);
GO

INSERT INTO one(FirstColumn, SecondColumn, ThirdColumn)
SELECT CAST(NEWID() AS VARCHAR(40)), CAST(NEWID() AS VARCHAR(40)), CAST(NEWID() AS VARCHAR(40))
GO 200000




DROP TABLE IF EXISTS two;
GO
CREATE TABLE two
(
	FirstColumn VARCHAR(40),
	SecondColumn VARCHAR(40),
	ThirdColumn VARCHAR(40),
	[timestamp] DATETIME DEFAULT GETDATE(),
	CONSTRAINT PK_FirstColumn PRIMARY KEY (FirstColumn)
);
GO

INSERT INTO two(FirstColumn, SecondColumn, ThirdColumn)
SELECT CAST(NEWID() AS VARCHAR(40)), CAST(NEWID() AS VARCHAR(40)), CAST(NEWID() AS VARCHAR(40))
GO 200000

DROP TABLE IF EXISTS three;
GO
CREATE TABLE three
(
	FirstColumn VARCHAR(40),
	SecondColumn VARCHAR(40),
	ThirdColumn VARCHAR(40),
	[timestamp] DATETIME DEFAULT GETDATE(),
	CONSTRAINT PK_FirstColumn_2 PRIMARY KEY (FirstColumn)
	
);
GO

CREATE NONCLUSTERED INDEX IX_three_ThirdColumn ON three(ThirdColumn);
GO
INSERT INTO three(FirstColumn, SecondColumn, ThirdColumn)
SELECT CAST(NEWID() AS VARCHAR(40)), CAST(NEWID() AS VARCHAR(40)), CAST(NEWID() AS VARCHAR(40))
GO 200000

DROP TABLE IF EXISTS four;
GO
CREATE TABLE four
(
	FirstColumn VARCHAR(40),
	SecondColumn VARCHAR(40),
	ThirdColumn VARCHAR(40),
	[timestamp] DATETIME DEFAULT GETDATE(),
	CONSTRAINT PK_FirstColumn_4 PRIMARY KEY (FirstColumn)
	
);
GO
CREATE NONCLUSTERED INDEX IX_four_ThirdColumn_include ON four(ThirdColumn) INCLUDE (SecondColumn, [timestamp]);
CREATE NONCLUSTERED INDEX IX_four_ThirdColumn_1_include ON four(ThirdColumn) INCLUDE (SecondColumn);
CREATE NONCLUSTERED INDEX IX_four_ThirdColumn_2_include ON four(ThirdColumn);
drop index IX_four_ThirdColumn_23_include ON four
CREATE NONCLUSTERED INDEX IX_four_ThirdColumn_23_include ON four(ThirdColumn, SecondColumn);
go

INSERT INTO four(FirstColumn, SecondColumn, ThirdColumn)
SELECT CAST(NEWID() AS VARCHAR(40)), CAST(NEWID() AS VARCHAR(40)), CAST(NEWID() AS VARCHAR(40))
GO 200000


SELECT * FROM one

SELECT * FROM two

SELECT * FROM three

SELECT * FROM four

GO


SELECT * FROM one order by FirstColumn

SELECT * FROM two order by FirstColumn

SELECT * FROM three order by FirstColumn

SELECT * FROM four order by FirstColumn
GO

SELECT * FROM one where FirstColumn = '79A16434-65A7-47C6-BC89-FFFF433F7AEA'
SELECT * FROM two where FirstColumn = '79A16434-65A7-47C6-BC89-FFFF433F7AEA'
SELECT * FROM three where FirstColumn = '79A16434-65A7-47C6-BC89-FFFF433F7AEA'
SELECT * FROM four where FirstColumn = '79A16434-65A7-47C6-BC89-FFFF433F7AEA'
GO

SELECT * FROM one where SecondColumn = '79A16434-65A7-47C6-BC89-FFFF433F7AEA'
SELECT * FROM two where SecondColumn = '79A16434-65A7-47C6-BC89-FFFF433F7AEA'
SELECT * FROM three where SecondColumn = '79A16434-65A7-47C6-BC89-FFFF433F7AEA'
SELECT * FROM four where SecondColumn = '79A16434-65A7-47C6-BC89-FFFF433F7AEA'
GO

SELECT * FROM one where ThirdColumn = '79A16434-65A7-47C6-BC89-FFFF433F7AEA'
SELECT * FROM two where ThirdColumn = '79A16434-65A7-47C6-BC89-FFFF433F7AEA'
SELECT * FROM three where ThirdColumn = '79A16434-65A7-47C6-BC89-FFFF433F7AEA'
SELECT * FROM four where ThirdColumn = '79A16434-65A7-47C6-BC89-FFFF433F7AEA'
GO

select SecondColumn, timestamp from one where ThirdColumn = '79A16434-65A7-47C6-BC89-FFFF433F7AEA'
select SecondColumn, timestamp from two where ThirdColumn = '79A16434-65A7-47C6-BC89-FFFF433F7AEA'
select SecondColumn, timestamp from three where ThirdColumn = '79A16434-65A7-47C6-BC89-FFFF433F7AEA'
select SecondColumn, timestamp from four where ThirdColumn = '79A16434-65A7-47C6-BC89-FFFF433F7AEA'
GO

select SecondColumn, timestamp from one where TRIM(ThirdColumn) = '79A16434-65A7-47C6-BC89-FFFF433F7AEA'
select SecondColumn, timestamp from two where TRIM(ThirdColumn) = '79A16434-65A7-47C6-BC89-FFFF433F7AEA'
select SecondColumn, timestamp from three where TRIM(ThirdColumn) = '79A16434-65A7-47C6-BC89-FFFF433F7AEA'
select SecondColumn, timestamp from four where TRIM(ThirdColumn) = '79A16434-65A7-47C6-BC89-FFFF433F7AEA'
GO

select SecondColumn, timestamp from one where ThirdColumn like '%7%'
select SecondColumn, timestamp from two where ThirdColumn like '%7%'
select SecondColumn, timestamp from three where ThirdColumn like '%7%'
select SecondColumn, timestamp from four where ThirdColumn like '%7%'

select SecondColumn, timestamp from one where ThirdColumn like '%7'
select SecondColumn, timestamp from two where ThirdColumn like '%7'
select SecondColumn, timestamp from three where ThirdColumn like '%7'
select SecondColumn, timestamp from four where ThirdColumn like '%7'

select SecondColumn, timestamp from one where ThirdColumn like '7%'
select SecondColumn, timestamp from two where ThirdColumn like '7%'
select SecondColumn, timestamp from three where ThirdColumn like '7%'
select SecondColumn, timestamp from four where ThirdColumn like '7%'

select ThirdColumn, timestamp from three where ThirdColumn like '7%'
select ThirdColumn, timestamp  from four where ThirdColumn like '7%'

select ThirdColumn, FirstColumn, SecondColumn from three where ThirdColumn like '7%'






--7FFFB35A-D590-46FD-92D8-B11C9FA4D89B

Insert Into one(FirstColumn, SecondColumn, ThirdColumn) VALUES (CAST(NEWID() AS VARCHAR(40)), CAST(NEWID() AS VARCHAR(40)), CAST(NEWID() AS VARCHAR(40)));
Insert Into two(FirstColumn, SecondColumn, ThirdColumn) VALUES (CAST(NEWID() AS VARCHAR(40)), CAST(NEWID() AS VARCHAR(40)), CAST(NEWID() AS VARCHAR(40)));
Insert Into three(FirstColumn, SecondColumn, ThirdColumn) VALUES (CAST(NEWID() AS VARCHAR(40)), CAST(NEWID() AS VARCHAR(40)), CAST(NEWID() AS VARCHAR(40)));
Insert Into four(FirstColumn, SecondColumn, ThirdColumn) VALUES (CAST(NEWID() AS VARCHAR(40)), CAST(NEWID() AS VARCHAR(40)), CAST(NEWID() AS VARCHAR(40)));



update one set one.ThirdColumn = CAST(NEWID() AS VARCHAR(40)) where FirstColumn = '79A16434-65A7-47C6-BC89-FFFF433F7AEA' ;
update two set two.ThirdColumn = CAST(NEWID() AS VARCHAR(40)) where FirstColumn = '79A16434-65A7-47C6-BC89-FFFF433F7AEA';
update three set three.ThirdColumn = CAST(NEWID() AS VARCHAR(40)) where FirstColumn = '79A16434-65A7-47C6-BC89-FFFF433F7AEA';
update four set four.ThirdColumn = CAST(NEWID() AS VARCHAR(40)) where FirstColumn = '79A16434-65A7-47C6-BC89-FFFF433F7AEA';


update one set one.SecondColumn = CAST(NEWID() AS VARCHAR(40)) where ThirdColumn = '79A16434-65A7-47C6-BC89-FFFF433F7AEA' ;
update two set two.SecondColumn = CAST(NEWID() AS VARCHAR(40)) where ThirdColumn = '79A16434-65A7-47C6-BC89-FFFF433F7AEA';
update three set three.SecondColumn = CAST(NEWID() AS VARCHAR(40)) where ThirdColumn = '79A16434-65A7-47C6-BC89-FFFF433F7AEA';
update four set four.SecondColumn = CAST(NEWID() AS VARCHAR(40)) where ThirdColumn = '79A16434-65A7-47C6-BC89-FFFF433F7AEA';


update one set one.ThirdColumn = CAST(NEWID() AS VARCHAR(40)) where ThirdColumn = '79A16434-65A7-47C6-BC89-FFFF433F7AEA' ;
update two set two.ThirdColumn = CAST(NEWID() AS VARCHAR(40)) where ThirdColumn = '79A16434-65A7-47C6-BC89-FFFF433F7AEA';
update three set three.ThirdColumn = CAST(NEWID() AS VARCHAR(40)) where ThirdColumn = '79A16434-65A7-47C6-BC89-FFFF433F7AEA';
update four set four.ThirdColumn = CAST(NEWID() AS VARCHAR(40)) where ThirdColumn = '79A16434-65A7-47C6-BC89-FFFF433F7AEA';

go


delete one where FirstColumn = '79A16434-65A7-47C6-BC89-FFFF433F7AEA' ;
delete two where FirstColumn = '79A16434-65A7-47C6-BC89-FFFF433F7AEA';
delete three  where FirstColumn = '79A16434-65A7-47C6-BC89-FFFF433F7AEA';
delete four  where FirstColumn = '79A16434-65A7-47C6-BC89-FFFF433F7AEA';


delete one  where SecondColumn = '79A16434-65A7-47C6-BC89-FFFF433F7AEA' ;
delete two  where SecondColumn = '79A16434-65A7-47C6-BC89-FFFF433F7AEA';
delete three  where SecondColumn = '79A16434-65A7-47C6-BC89-FFFF433F7AEA';
delete four  where SecondColumn = '79A16434-65A7-47C6-BC89-FFFF433F7AEA';


delete one  where ThirdColumn = '79A16434-65A7-47C6-BC89-FFFF433F7AEA' ;
delete two  where ThirdColumn = '79A16434-65A7-47C6-BC89-FFFF433F7AEA';
delete three  where ThirdColumn = '79A16434-65A7-47C6-BC89-FFFF433F7AEA';
delete four  where ThirdColumn = '79A16434-65A7-47C6-BC89-FFFF433F7AEA';