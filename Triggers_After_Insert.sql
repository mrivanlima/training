SET STATISTICS IO ON;
SET STATISTICS TIME ON;

DROP TABLE IF EXISTS ErrorLog;
GO
CREATE TABLE ErrorLog(
	[ErrorLogId] [bigint] IDENTITY(1,1) NOT NULL,
	[ErrorNumber] [varchar](10) NULL,
	[ErrorSeverity] [varchar](10) NULL,
	[ErrorState] [varchar](10) NULL,
	[ErrorProcedure] [varchar](100) NULL,
	[ErrorLine] [varchar](10) NULL,
	[ErrorMessage] [varchar](250) NULL,
	[UserName] [varchar](100) NULL,
	[ErrorDate] [datetime] NULL,
 CONSTRAINT [PK_ErrorLog] PRIMARY KEY CLUSTERED ([ErrorLogId])
 )
GO


DROP TABLE IF EXISTS Person;
CREATE TABLE Person
(
	PersonId INT IDENTITY (1, 1) PRIMARY KEY,
	FirstName VARCHAR(10),
	LastName VARCHAR(10),
	[Timestamp] DATETIME DEFAULT GETDATE()
);

DROP TABLE IF EXISTS PersonAudit;
CREATE TABLE PersonAudit
(
	PersonId INT,
	FirstName VARCHAR(10),
	LastName VARCHAR(10),
	[Timestamp] DATETIME
);

--CREATE CLUSTERED INDEX IX_PersonAudit_PersonId ON PersonAudit (PersonId);
GO

select * from Person;
select * from PersonAudit;
GO

--How it works
CREATE OR ALTER TRIGGER [TI_Person] ON Person AFTER INSERT AS
BEGIN
	PRINT 'The TI_Person trigger was called!';
END;
GO

INSERT INTO Person (FirstName, LastName)
SELECT	FirstName,
		LastName
FROM Person
WHERE 0 = 1
GO

--Check ROWCOUNT and not exists
CREATE OR ALTER TRIGGER [TI_Person] ON Person AFTER INSERT AS
BEGIN

	IF(ROWCOUNT_BIG() = 0)
	BEGIN
		PRINT 'The TI_Person trigger was called, but there is no inserts from ROWCOUNT_BIG()';
		RETURN;
	END;



	IF NOT EXISTS (SELECT 1 FROM INSERTED)
	BEGIN
		PRINT 'The TI_Person trigger was called, but there is no data in the inserted virtual table';
		RETURN;
	END;

	PRINT 'The TI_Person trigger was called and did this thing!';
END;
GO

INSERT INTO Person (FirstName, LastName)
SELECT	FirstName,
		LastName
FROM Person
WHERE 0 = 1
GO

--Statement before rowcount
CREATE OR ALTER TRIGGER [TI_Person] ON Person AFTER INSERT AS
BEGIN

	DECLARE @Process VARCHAR(20) = 'TI_Person';
	IF(ROWCOUNT_BIG() = 0)
	BEGIN
		PRINT 'The TI_Person trigger was called, but there is no inserts from ROWCOUNT_BIG()';
		RETURN;
	END;

	IF NOT EXISTS (SELECT 1 FROM INSERTED)
	BEGIN
		PRINT 'The TI_Person trigger was called, but there is no data in the inserted virtual table';
		RETURN;
	END;

	PRINT 'The TI_Person trigger was called and did it''s thing!';
END;
GO

INSERT INTO Person (FirstName, LastName) VALUES ('Ivan', 'Lima');

SELECT * FROM Person;
SELECT * FROM PersonAudit;

INSERT INTO Person (FirstName, LastName)
SELECT	FirstName,
		LastName
FROM Person
WHERE 0 = 1
GO

--Change statement to after ROWCOUNT
CREATE OR ALTER TRIGGER [TI_Person] ON Person AFTER INSERT AS
BEGIN

	
	IF(ROWCOUNT_BIG() = 0)
	BEGIN
		PRINT 'The TI_Person trigger was called, but there is no inserts from ROWCOUNT_BIG()';
		RETURN;
	END;

	DECLARE @Process VARCHAR(20) = 'TI_Person';

	IF NOT EXISTS (SELECT 1 FROM INSERTED)
	BEGIN
		PRINT 'The TI_Person trigger was called, but there is no data in the inserted virtual table';
		RETURN;
	END;

	PRINT 'The TI_Person trigger was called and did it''s thing!';
END;
GO

INSERT INTO Person (FirstName, LastName) VALUES ('Ivan', 'Lima');

SELECT * FROM Person;
SELECT * FROM PersonAudit;

INSERT INTO Person (FirstName, LastName)
SELECT	FirstName,
		LastName
FROM Person
WHERE 0 = 1
GO


--insert into personAudit
CREATE OR ALTER TRIGGER [TI_Person] ON Person AFTER INSERT AS
BEGIN
    

	IF(ROWCOUNT_BIG() = 0)
	BEGIN
		PRINT'The TI_Person trigger was called, but there is no inserts from ROWCOUNT_BIG()';
		RETURN;
	END;

	SET NOCOUNT ON;
	DECLARE @Process VARCHAR(20) = 'TI_Person';

	IF NOT EXISTS (SELECT 1 FROM INSERTED)
	BEGIN
		PRINT 'The TI_Person trigger was called, but there is no data in the inserted virtual table';
		RETURN;
	END;

	INSERT INTO PersonAudit
	(
		PersonId, 
		FirstName, 
		LastName, 
		[Timestamp]
	)
	SELECT PersonId, 
		   FirstName, 
		   LastName, 
		   [Timestamp]
	FROM inserted;


	PRINT 'The TI_Person trigger was fired and worked succefully!';
END;
GO

INSERT INTO Person (FirstName, LastName)
SELECT	FirstName,
		LastName
FROM Person
WHERE 0 = 1
GO

SELECT * FROM Person;
SELECT * FROM PersonAudit;

INSERT INTO Person (FirstName, LastName) VALUES ('Ivan', 'Lima');

SELECT * FROM Person;
SELECT * FROM PersonAudit;
GO


--Force an error in the trigger
CREATE OR ALTER TRIGGER [TI_Person] ON Person AFTER INSERT AS
BEGIN
   
	IF(ROWCOUNT_BIG() = 0)
	BEGIN
		PRINT'The TI_Person trigger was called, but there is no inserts from ROWCOUNT_BIG()';
		RETURN;
	END;

	SET NOCOUNT ON;
	DECLARE @Process VARCHAR(20) = 'TI_Person';

	IF NOT EXISTS (SELECT 1 FROM INSERTED)
	BEGIN
		PRINT 'The TI_Person trigger was called, but there is no data in the inserted virtual table';
		RETURN;
	END;


	INSERT INTO PersonAudit
	(
		PersonId, 
		FirstName, 
		LastName, 
		[Timestamp]
	)
	SELECT PersonId, 
			CONCAT(FirstName, FirstName, FirstName, FirstName), 
			LastName, 
			[Timestamp]
	FROM inserted;
	
	PRINT'The TI_Person trigger was called and worked succefully!';
END;
GO

INSERT INTO Person (FirstName, LastName)
SELECT	FirstName,
		LastName
FROM Person
WHERE 0 = 1
GO

SELECT * FROM Person;
SELECT * FROM PersonAudit;

INSERT INTO Person (FirstName, LastName) VALUES ('Ivan', 'Lima');

SELECT * FROM Person;
SELECT * FROM PersonAudit;
GO


--See transaction count
CREATE OR ALTER TRIGGER [TI_Person] ON Person AFTER INSERT AS
BEGIN
   
	IF(ROWCOUNT_BIG() = 0)
	BEGIN
		PRINT'The TI_Person trigger was called, but there is no inserts from ROWCOUNT_BIG()';
		RETURN;
	END;

	SET NOCOUNT ON;
	DECLARE @Process VARCHAR(20) = 'TI_Person';

	PRINT CONCAT('The number of transactions before insert in PersonAudit are/is ', @@TRANCOUNT);

	IF NOT EXISTS (SELECT 1 FROM INSERTED)
	BEGIN
		PRINT 'The TI_Person trigger was called, but there is no data in the inserted virtual table';
		RETURN;
	END;


	INSERT INTO PersonAudit
	(
		PersonId, 
		FirstName, 
		LastName, 
		[Timestamp]
	)
	SELECT PersonId, 
			CONCAT(FirstName, FirstName, FirstName, FirstName), 
			LastName, 
			[Timestamp]
	FROM inserted;

	PRINT CONCAT('The number of transactions before insert in PersonAudit are ', @@TRANCOUNT);
	
	PRINT'The TI_Person trigger was called and worked succefully!';
END;
GO

INSERT INTO Person (FirstName, LastName)
SELECT	FirstName,
		LastName
FROM Person
WHERE 0 = 1
GO

SELECT * FROM Person;
SELECT * FROM PersonAudit;

INSERT INTO Person (FirstName, LastName) VALUES ('Ivan', 'Lima');

SELECT * FROM Person;
SELECT * FROM PersonAudit;
GO

--See transaction count in a catch
CREATE OR ALTER TRIGGER [TI_Person] ON Person AFTER INSERT AS
BEGIN
   
	IF(ROWCOUNT_BIG() = 0)
	BEGIN
		PRINT'The TI_Person trigger was called, but there is no inserts from ROWCOUNT_BIG()';
		RETURN;
	END;

	SET NOCOUNT ON;
	DECLARE @Process VARCHAR(20) = 'TI_Person';

	PRINT CONCAT('The number of transactions before insert in PersonAudit are/is ', @@TRANCOUNT);

	IF NOT EXISTS (SELECT 1 FROM INSERTED)
	BEGIN
		PRINT 'The TI_Person trigger was called, but there is no data in the inserted virtual table';
		RETURN;
	END;

	BEGIN TRY
		INSERT INTO PersonAudit
		(
			PersonId, 
			FirstName, 
			LastName, 
			[Timestamp]
		)
		SELECT PersonId, 
				CONCAT(FirstName, FirstName, FirstName, FirstName), 
				LastName, 
				[Timestamp]
		FROM inserted;
	END TRY
	BEGIN CATCH
		PRINT CONCAT('The number of transactions after insert in PersonAudit are/is ', @@TRANCOUNT);
	END CATCH

	PRINT'The TI_Person trigger was called and worked succefully!';
END;
GO

INSERT INTO Person (FirstName, LastName)
SELECT	FirstName,
		LastName
FROM Person
WHERE 0 = 1
GO

SELECT * FROM Person;
SELECT * FROM PersonAudit;

INSERT INTO Person (FirstName, LastName) VALUES ('Ivan', 'Lima');

SELECT * FROM Person;
SELECT * FROM PersonAudit;
GO

--Transaction without a catch
BEGIN
	BEGIN
		INSERT INTO Person (FirstName, LastName) VALUES ('Ivan', 'Lima');

		PRINT CONCAT('There is/are ',  @@TRANCOUNT, ' opened after the insert!');
	END;

	PRINT CONCAT('There is/are ',  @@TRANCOUNT, ' opened after the first block insert!');

END;


--Transaction with a catch
BEGIN
	BEGIN TRY
		INSERT INTO Person (FirstName, LastName) VALUES ('Ivan', 'Lima');

		PRINT CONCAT('There is/are ',  @@TRANCOUNT, ' opened after the insert in the try!');
	END TRY
	BEGIN CATCH
		PRINT CONCAT('There is/are ',  @@TRANCOUNT, ' opened after the in the script catch insert!');
	END CATCH
	PRINT CONCAT('There is/are ',  @@TRANCOUNT, ' opened after the in the after the catch!');
END;
GO

SELECT * FROM Person;
SELECT * FROM PersonAudit;
GO


----Transaction with a error message
BEGIN
	BEGIN TRY
		INSERT INTO Person (FirstName, LastName) VALUES ('Ivan', 'Lima');

		PRINT CONCAT('There is/are ',  @@TRANCOUNT, ' opened after the insert!');
	END TRY
	BEGIN CATCH
		PRINT(ERROR_MESSAGE());
		PRINT CONCAT('There is/are ',  @@TRANCOUNT, ' opened after the insert!');
	END CATCH
END;
GO

--Transaction with a transaction count
BEGIN
	BEGIN TRY
		DECLARE @Process VARCHAR(20) = 'My Process';
		INSERT INTO Person (FirstName, LastName) VALUES ('Ivan', 'Lima');

		PRINT CONCAT('There is/are ',  @@TRANCOUNT, ' opened after the insert!');
	END TRY
	BEGIN CATCH
		PRINT CONCAT('There is/are ',  @@TRANCOUNT, ' opened after the insert!');
		INSERT INTO [ErrorLog] 
		(
			[ErrorNumber], 
			[ErrorSeverity], 
			[ErrorState], 
			[ErrorProcedure], 
			[ErrorLine], 
			[ErrorMessage], 
			[UserName],
			ErrorDate
		)
		VALUES
		( 
			 ERROR_NUMBER()
			,ERROR_SEVERITY()
			,ERROR_STATE()
			,ISNULL(ERROR_PROCEDURE(), @Process)
			,ERROR_LINE()
			,ERROR_MESSAGE()
			,SUSER_NAME()
			,GETDATE()
		);
		
	END CATCH
END;
GO


SELECT * FROM Person;
SELECT * FROM PersonAudit;
SELECT * FROM ErrorLog;
GO


--Almost perfec trigger with prints
CREATE OR ALTER TRIGGER [TI_Person] ON Person AFTER INSERT AS
BEGIN
 
  IF(ROWCOUNT_BIG() = 0)
	BEGIN
		PRINT'The TI_Person trigger was called, but there is no inserts from ROWCOUNT_BIG()';
		RETURN;
	END;

	SET NOCOUNT ON;
	DECLARE @Process VARCHAR(20) = 'TI_Person';

	PRINT CONCAT('The number of transactions before insert in PersonAudit are ', @@TRANCOUNT);

	IF NOT EXISTS (SELECT 1 FROM INSERTED)
	BEGIN
		PRINT 'The TI_Person trigger was called, but there is no data in the inserted virtual table';
		RETURN;
	END;

	BEGIN TRY
		INSERT INTO PersonAudit
		(
			PersonId, 
			FirstName, 
			LastName, 
			[Timestamp]
		)
		SELECT PersonId, 
				CONCAT(FirstName, FirstName, FirstName, FirstName), 
				LastName, 
				[Timestamp]
		FROM inserted;
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
		BEGIN
			ROLLBACK TRANSACTION;
		END;

		PRINT CONCAT('The number of transactions after insert in PersonAudit are ', @@TRANCOUNT);
		INSERT INTO [ErrorLog] 
		(
			[ErrorNumber], 
			[ErrorSeverity], 
			[ErrorState], 
			[ErrorProcedure], 
			[ErrorLine], 
			[ErrorMessage], 
			[UserName],
			ErrorDate
		)
		VALUES
		( 
			 ERROR_NUMBER()
			,ERROR_SEVERITY()
			,ERROR_STATE()
			,ISNULL(ERROR_PROCEDURE(), @Process)
			,ERROR_LINE()
			,ERROR_MESSAGE()
			,SUSER_NAME()
			,GETDATE()
		);
	END CATCH
	PRINT'The TI_Person trigger was called and worked succefully!';
END;
GO

BEGIN
	BEGIN TRY
		DECLARE @Process VARCHAR(20) = 'My Process';
		INSERT INTO Person (FirstName, LastName) VALUES ('Ivan', 'Lima');

		PRINT CONCAT('There is/are ',  @@TRANCOUNT, ' opened after the insert before the catch!');
	END TRY
	BEGIN CATCH
		PRINT CONCAT('There is/are ',  @@TRANCOUNT, ' opened after the insert after the catch!');
		INSERT INTO [ErrorLog] 
		(
			[ErrorNumber], 
			[ErrorSeverity], 
			[ErrorState], 
			[ErrorProcedure], 
			[ErrorLine], 
			[ErrorMessage], 
			[UserName],
			ErrorDate
		)
		VALUES
		( 
			 ERROR_NUMBER()
			,ERROR_SEVERITY()
			,ERROR_STATE()
			,ISNULL(ERROR_PROCEDURE(), @Process)
			,ERROR_LINE()
			,ERROR_MESSAGE()
			,SUSER_NAME()
			,GETDATE()
		);
		
	END CATCH
END;
GO

SELECT * FROM [ErrorLog]
GO

SELECT * FROM Person;
SELECT * FROM PersonAudit;
GO

--Almost perfec trigger.
CREATE OR ALTER TRIGGER [TI_Person] ON Person AFTER INSERT AS
BEGIN
   
	IF(ROWCOUNT_BIG() = 0)
	BEGIN
		RETURN;
	END;

	SET NOCOUNT ON;
	DECLARE @Process VARCHAR(20) = 'TI_Person';


	IF NOT EXISTS (SELECT 1 FROM INSERTED)
	BEGIN
		RETURN;
	END;

	BEGIN TRY
		INSERT INTO PersonAudit
		(
			PersonId, 
			FirstName, 
			LastName, 
			[Timestamp]
		)
		SELECT  PersonId, 
				FirstName, 
				LastName, 
				[Timestamp]
		FROM inserted;
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
		BEGIN
			ROLLBACK TRANSACTION;
		END;
		INSERT INTO [ErrorLog] 
		(
			[ErrorNumber], 
			[ErrorSeverity], 
			[ErrorState], 
			[ErrorProcedure], 
			[ErrorLine], 
			[ErrorMessage], 
			[UserName],
			ErrorDate
		)
		VALUES
		( 
			 ERROR_NUMBER()
			,ERROR_SEVERITY()
			,ERROR_STATE()
			,ISNULL(ERROR_PROCEDURE(), @Process)
			,ERROR_LINE()
			,ERROR_MESSAGE()
			,SUSER_NAME()
			,GETDATE()
		);
	END CATCH
END;
GO

BEGIN
	BEGIN TRY
		DECLARE @Process VARCHAR(20) = 'My Process';
		INSERT INTO Person (FirstName, LastName) VALUES ('Ivan', 'Lima');
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
		BEGIN
			ROLLBACK TRANSACTION;
		END;
		INSERT INTO [ErrorLog] 
		(
			[ErrorNumber], 
			[ErrorSeverity], 
			[ErrorState], 
			[ErrorProcedure], 
			[ErrorLine], 
			[ErrorMessage], 
			[UserName],
			ErrorDate
		)
		VALUES
		( 
			 ERROR_NUMBER()
			,ERROR_SEVERITY()
			,ERROR_STATE()
			,ISNULL(ERROR_PROCEDURE(), @Process)
			,ERROR_LINE()
			,ERROR_MESSAGE()
			,SUSER_NAME()
			,GETDATE()
		);
		
	END CATCH
END;
GO


SELECT * FROM Person;
SELECT * FROM PersonAudit;

INSERT INTO Person (FirstName, LastName)
SELECT 'Ivan', 'Lima'
GO 50

GO
DISABLE TRIGGER [TI_Person] ON Person;
GO

ENABLE TRIGGER [TI_Person] ON Person;
GO

INSERT INTO Person (FirstName, LastName)
SELECT	FirstName,
		LastName
FROM Person
GO

SELECT * FROM Person;
SELECT * FROM PersonAudit;
