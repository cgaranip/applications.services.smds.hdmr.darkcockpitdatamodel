-- This is a Test Constant file to test build. Can be deleted.
IF EXISTS (SELECT * FROM sys.objects  WHERE type in (N'FN', N'IF', N'TF', N'FS', N'FT') AND OBJECT_ID = OBJECT_ID(N'CONST_Test') )
								BEGIN
									DROP FUNCTION dbo.CONST_Test
								END
GO								
CREATE FUNCTION dbo.CONST_Test()
									RETURNS VARCHAR(250)
								AS
								BEGIN
									RETURN 
										(SELECT 'Test')
								END
								
GO							