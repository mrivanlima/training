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
	[PersonId] INT IDENTITY (1, 1) PRIMARY KEY,
	[FirstName] VARCHAR(10),
	LastName VARCHAR(10),
	[Timestamp] DATETIME DEFAULT GETDATE()
);

DROP TABLE IF EXISTS PersonAudit;
CREATE TABLE PersonAudit
(
	[PersonId] INT,
	[FirstName] VARCHAR(10),
	[LastName] VARCHAR(10),
	[Action] VARCHAR(10),
	[Timestamp] DATETIME,
	[ModifiedBy] VARCHAR(20)
);
CREATE CLUSTERED INDEX IX_PersonAudit_PersonId ON PersonAudit (PersonId);
GO

--Insert trigger from previous video
CREATE OR ALTER TRIGGER [TI_Person] ON Person AFTER INSERT AS
BEGIN
   
	IF(ROWCOUNT_BIG() = 0)
	BEGIN
		RETURN;
	END;

	SET NOCOUNT ON;
	DECLARE @Process VARCHAR(20) = 'TI_Person';
	DECLARE @Action VARCHAR(10) = 'Inserted';


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
			[Action],
			[Timestamp],
			[ModifiedBy]
		)
		SELECT  PersonId, 
				FirstName, 
				LastName,
				@Action,
				[Timestamp],
				SUSER_NAME()
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

CREATE OR ALTER TRIGGER [TD_Person] ON Person AFTER DELETE AS
BEGIN
 
  IF(ROWCOUNT_BIG() = 0)
	BEGIN
		RETURN;
	END;

	SET NOCOUNT ON;
	DECLARE @Process VARCHAR(20) = 'TD_Person';
	DECLARE @Action VARCHAR(10) = 'Deleted';

	IF NOT EXISTS (SELECT 1 FROM DELETED)
	BEGIN
		RETURN;
	END;

	BEGIN TRY
		INSERT INTO PersonAudit
		(
			PersonId, 
			FirstName, 
			LastName, 
			[Action],
			[Timestamp],
			ModifiedBy
		)
		SELECT PersonId, 
				FirstName, 
				LastName, 
				@Action,
				GETDATE(),
				SYSTEM_USER
		FROM deleted;
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


select * from Person;
select * from PersonAudit;
GO

INSERT INTO Person (FirstName, LastName) VALUES ('Ivan', 'Lima');
INSERT INTO Person (FirstName, LastName) VALUES ('IvaamM', 'Lima');

GO

DELETE FROM Person WHERE FirstName = 'Ivan';
GO

SELECT * FROM [ErrorLog];
GO


CREATE OR ALTER TRIGGER [TU_Person] ON Person AFTER UPDATE AS
BEGIN

	IF(ROWCOUNT_BIG() = 0)
	BEGIN
		PRINT'The TU_Person trigger was called!';
		
		RETURN;
	END;
 
	SELECT * FROM INSERTED;
	SELECT * FROM DELETED;


	SELECT * 
	FROM INSERTED

	EXCEPT

	SELECT * 
	FROM DELETED;

END;
GO

select * from Person;
select * from PersonAudit;
GO

UPDATE p
	SET p.LastName = 'Lim'
FROM Person p
WHERE p.FirstName = 'IvaamM'
GO


CREATE OR ALTER TRIGGER [TU_Person] ON Person AFTER UPDATE AS
BEGIN

	SELECT * 
	INTO #UPDATED
	FROM INSERTED

	EXCEPT

	SELECT * 
	FROM DELETED;

	IF(ROWCOUNT_BIG() = 0)
	BEGIN
		PRINT'The TU_Person trigger was called and worked succefully!';
		RETURN;
	END;
 
	SELECT * FROM INSERTED;
	SELECT * FROM DELETED;


	

END;
GO


select * from Person;
select * from PersonAudit;
GO

UPDATE p
	SET p.LastName = 'Lima'
FROM Person p
WHERE p.FirstName = 'IvaamM'
GO



CREATE OR ALTER TRIGGER [TU_Person] ON Person AFTER UPDATE AS
BEGIN

	SELECT * 
	INTO #UPDATED
	FROM INSERTED

	EXCEPT

	SELECT * 
	FROM DELETED;

 
	IF(ROWCOUNT_BIG() = 0)
	BEGIN
		RETURN;
	END;

	SET NOCOUNT ON;
	DECLARE @Process VARCHAR(20) = 'TU_Person';
	DECLARE @Action VARCHAR(10) = 'Updated';


	IF NOT EXISTS (SELECT 1 FROM #UPDATED)
	BEGIN
		RETURN;
	END;

	BEGIN TRY
		INSERT INTO PersonAudit
		(
			PersonId, 
			FirstName, 
			LastName, 
			[Action],
			[Timestamp],
			ModifiedBy
		)
		SELECT PersonId, 
				FirstName, 
				LastName, 
				@Action,
				GETDATE(),
				SYSTEM_USER
		FROM #UPDATED;
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
			,ERROR_PROCEDURE()
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
		DECLARE @Process VARCHAR(20) = 'My UPDATE Process';
		UPDATE p
			SET p.LastName = 'Lim'
		FROM Person p WHERE FirstName = 'IvaamM';
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


select * from Person;
select * from PersonAudit;