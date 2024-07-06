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


select * from Person;
select * from PersonAudit;
GO

INSERT INTO Person (FirstName, LastName) VALUES ('Ivan', 'Lima');
INSERT INTO Person (FirstName, LastName) VALUES ('IvaamM', 'Lima');

GO



SELECT * FROM [ErrorLog];
GO



--Almost perfec trigger with prints
CREATE OR ALTER TRIGGER [TD_Person] ON Person AFTER DELETE AS
BEGIN
 
  IF(ROWCOUNT_BIG() = 0)
	BEGIN
		PRINT'The TD_Person trigger was called, but there is no deletes from ROWCOUNT_BIG()';
		RETURN;
	END;

	SET NOCOUNT ON;
	DECLARE @Process VARCHAR(20) = 'TD_Person';
	DECLARE @Action VARCHAR(10) = 'Deleted';

	PRINT CONCAT('The number of transactions before delete in PersonAudit are ', @@TRANCOUNT);

	SELECT 'deleted' FROM DELETED;

	SELECT 'inserted' FROM INSERTED;


	IF NOT EXISTS (SELECT 1 FROM DELETED)
	BEGIN
		PRINT 'The TD_Person trigger was called, but there is no data in the deleted virtual table';
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

		PRINT CONCAT('The number of transactions after delete in PersonAudit are ', @@TRANCOUNT);
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
	PRINT'The TD_Person trigger was called and worked succefully!';
END;
GO

DELETE FROM Person WHERE FirstName = 'Ivan1';
GO

DELETE FROM Person WHERE FirstName = 'Ivan';
GO

select * from Person;
select * from PersonAudit;
GO

select * from ErrorLog
go

INSERT INTO Person (FirstName, LastName) VALUES ('Ivan', 'Lima');
INSERT INTO Person (FirstName, LastName) VALUES ('IvaamMm', 'LimaAA');
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



BEGIN
	BEGIN TRY
		DECLARE @Process VARCHAR(20) = 'My delete Process';
		DELETE FROM Person WHERE FirstName = 'IvaamM';
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