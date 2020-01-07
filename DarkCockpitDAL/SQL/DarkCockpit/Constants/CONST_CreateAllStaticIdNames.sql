IF EXISTS (SELECT * FROM sys.objects  WHERE type in (N'FN', N'IF', N'TF', N'FS', N'FT') AND OBJECT_ID = OBJECT_ID(N'CONST_StatusId_Running') )
								BEGIN
									DROP FUNCTION dbo.CONST_StatusId_Running
								END 
								GO 
CREATE FUNCTION dbo.CONST_StatusId_Running()
									RETURNS INT
								AS
								BEGIN
									RETURN 
										(SELECT TOP 1 StatusId FROM dbo.RefStatus (NOLOCK) WHERE Status = 'Running')
								END 
								GO 
IF EXISTS (SELECT * FROM sys.objects  WHERE type in (N'FN', N'IF', N'TF', N'FS', N'FT') AND OBJECT_ID = OBJECT_ID(N'CONST_Status_Running') )
								BEGIN
									DROP FUNCTION dbo.CONST_Status_Running
								END 
								GO 
CREATE FUNCTION dbo.CONST_Status_Running()
									RETURNS VARCHAR(250)
								AS
								BEGIN
									RETURN 
										(SELECT TOP 1 Status FROM dbo.RefStatus (NOLOCK) WHERE Status = 'Running')
								END 
								GO 
IF EXISTS (SELECT * FROM sys.objects  WHERE type in (N'FN', N'IF', N'TF', N'FS', N'FT') AND OBJECT_ID = OBJECT_ID(N'CONST_StatusId_Completed') )
								BEGIN
									DROP FUNCTION dbo.CONST_StatusId_Completed
								END 
								GO 
CREATE FUNCTION dbo.CONST_StatusId_Completed()
									RETURNS INT
								AS
								BEGIN
									RETURN 
										(SELECT TOP 1 StatusId FROM dbo.RefStatus (NOLOCK) WHERE Status = 'Completed')
								END 
								GO 
IF EXISTS (SELECT * FROM sys.objects  WHERE type in (N'FN', N'IF', N'TF', N'FS', N'FT') AND OBJECT_ID = OBJECT_ID(N'CONST_Status_Completed') )
								BEGIN
									DROP FUNCTION dbo.CONST_Status_Completed
								END 
								GO 
CREATE FUNCTION dbo.CONST_Status_Completed()
									RETURNS VARCHAR(250)
								AS
								BEGIN
									RETURN 
										(SELECT TOP 1 Status FROM dbo.RefStatus (NOLOCK) WHERE Status = 'Completed')
								END 
								GO 
IF EXISTS (SELECT * FROM sys.objects  WHERE type in (N'FN', N'IF', N'TF', N'FS', N'FT') AND OBJECT_ID = OBJECT_ID(N'CONST_StatusId_Failure') )
								BEGIN
									DROP FUNCTION dbo.CONST_StatusId_Failure
								END 
								GO 
CREATE FUNCTION dbo.CONST_StatusId_Failure()
									RETURNS INT
								AS
								BEGIN
									RETURN 
										(SELECT TOP 1 StatusId FROM dbo.RefStatus (NOLOCK) WHERE Status = 'Failure')
								END 
								GO 
IF EXISTS (SELECT * FROM sys.objects  WHERE type in (N'FN', N'IF', N'TF', N'FS', N'FT') AND OBJECT_ID = OBJECT_ID(N'CONST_Status_Failure') )
								BEGIN
									DROP FUNCTION dbo.CONST_Status_Failure
								END 
								GO 
CREATE FUNCTION dbo.CONST_Status_Failure()
									RETURNS VARCHAR(250)
								AS
								BEGIN
									RETURN 
										(SELECT TOP 1 Status FROM dbo.RefStatus (NOLOCK) WHERE Status = 'Failure')
								END 
								GO 
