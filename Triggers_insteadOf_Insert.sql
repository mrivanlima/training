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
	[PersonId]	INT IDENTITY (1, 1),
	[FirstName] VARCHAR(10),
	[LastName]	VARCHAR(10),
	[Age]		TINYINT NOT NULL,
	[Timestamp] DATETIME DEFAULT GETDATE(),
	CONSTRAINT [PK_Person] PRIMARY KEY CLUSTERED ([PersonId])
);
GO

CREATE OR ALTER TRIGGER TI_Person 
	ON Person AFTER INSERT AS
BEGIN
	PRINT 'TI_Person TRIGGER WAS FIRED HERE!';
END;
GO

CREATE OR ALTER TRIGGER TI_Person_InsteadOf 
	ON Person INSTEAD OF INSERT AS
BEGIN
	PRINT 'TI_Person_InsteadOf TRIGGER WAS FIRED HERE!';
END;
GO

SELECT * FROM Person;

INSERT INTO Person (FirstName, LastName) VALUES ('Ivan', 'Lima')
GO

CREATE OR ALTER TRIGGER TI_Person_InsteadOf 
	ON Person INSTEAD OF INSERT AS
BEGIN
	PRINT 'TI_Person_InsteadOf TRIGGER WAS FIRED HERE!';
	SELECT * FROM inserted
END;
GO

SELECT * FROM Person;

INSERT INTO Person (FirstName, LastName) VALUES ('Ivan', 'Lima')
GO


CREATE OR ALTER TRIGGER TI_Person_InsteadOf 
	ON Person INSTEAD OF INSERT AS
BEGIN
	IF(ROWCOUNT_BIG() = 0)
	BEGIN
		RETURN;
	END;

	PRINT 'TI_Person_InsteadOf TRIGGER WAS FIRED HERE!';
	SELECT * FROM inserted
END;
GO

SELECT * FROM Person;

INSERT INTO Person (FirstName, LastName) VALUES ('Ivan', 'Lima')
GO


CREATE OR ALTER TRIGGER TI_Person_InsteadOf 
	ON Person INSTEAD OF INSERT AS
BEGIN
	IF(ROWCOUNT_BIG() = 0)
	BEGIN
		RETURN;
	END;

	PRINT 'TI_Person_InsteadOf TRIGGER WAS FIRED HERE!';
	SELECT * FROM inserted

	UPDATE i
	set i.Age = 0 
	from inserted i

	SELECT * FROM inserted

END;
GO

SELECT * FROM Person;

INSERT INTO Person (FirstName, LastName) VALUES ('Ivan', 'Lima')
GO


CREATE OR ALTER TRIGGER TI_Person_InsteadOf 
	ON Person INSTEAD OF INSERT AS
BEGIN
	IF(ROWCOUNT_BIG() = 0)
	BEGIN
		RETURN;
	END;

	PRINT 'TI_Person_InsteadOf TRIGGER WAS FIRED HERE!';
	SELECT * 
	INTO #INSERTED 
	FROM inserted

	UPDATE i
	set i.Age = 0 
	from #INSERTED i

	SELECT * FROM #INSERTED

END;
GO

SELECT * FROM Person;

INSERT INTO Person (FirstName, LastName) VALUES ('Ivan', 'Lima')
GO


CREATE OR ALTER TRIGGER TI_Person_InsteadOf 
	ON Person INSTEAD OF INSERT AS
BEGIN
	IF(ROWCOUNT_BIG() = 0)
	BEGIN
		RETURN;
	END;

	PRINT 'TI_Person_InsteadOf TRIGGER WAS FIRED HERE!';
	SELECT * 
	INTO #INSERTED 
	FROM inserted

	UPDATE i
	SET i.Age = 0 
	FROM #INSERTED i

	INSERT INTO Person 
	(
		FirstName, 
		LastName, 
		Age
	)
	SELECT 
		FirstName, 
		LastName, 
		Age 
	FROM #INSERTED

END;
GO

SELECT * FROM Person;

INSERT INTO Person (FirstName, LastName) VALUES ('Ivan', 'Lima')

GO


CREATE OR ALTER TRIGGER [TI_Person_InsteadOf] 
	ON Person INSTEAD OF INSERT AS
BEGIN
   
	IF(ROWCOUNT_BIG() = 0)
	BEGIN
		RETURN;
	END;

	PRINT 'TI_Person_InsteadOf TRIGGER WAS FIRED HERE!';

	SET NOCOUNT ON;
	DECLARE @Process VARCHAR(20) = 'TI_Person_InsteadOf';
	--DECLARE @Action VARCHAR(10) = 'ToInsert';

	SELECT * 
	INTO #INSERTED 
	FROM INSERTED;

	IF NOT EXISTS(SELECT 1 FROM #INSERTED)
	BEGIN
		RETURN;
	END;

	BEGIN TRY

		IF EXISTS(SELECT 1 FROM #INSERTED WHERE Age IS NULL)
		BEGIN
			UPDATE i
				SET i.Age = 0 
			FROM #INSERTED i
			WHERE Age IS NULL
		END;
		
		INSERT INTO Person 
		(
			FirstName, 
			LastName, 
			Age
		)
		SELECT 
			FirstName, 
			LastName, 
			Age 
		FROM #INSERTED;

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
			,@Process
			,ERROR_LINE()
			,ERROR_MESSAGE()
			,SUSER_NAME()
			,GETDATE()
		);
	END CATCH
END;
GO

SELECT * FROM Person;

INSERT INTO Person (FirstName, LastName) VALUES ('Ivan', 'Limaa')
INSERT INTO Person (FirstName, LastName, Age) VALUES ('Ivan', 'Lima', 20)
INSERT INTO Person (FirstName, LastName, Age) VALUES ('Ivan', 'Lima', NULL)




