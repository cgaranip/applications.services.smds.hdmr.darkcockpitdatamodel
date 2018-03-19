--This is a test function. Can be deleted
DECLARE @function_name VARCHAR(1000) = 'fnTest'
DECLARE @query VARCHAR(2000) = 'DROP FUNCTION ' + @function_name

IF EXISTS (SELECT * FROM sys.objects WHERE name like @function_name AND type_desc = 'SQL_TABLE_VALUED_FUNCTION')
BEGIN
       EXEC (@query)
END
GO

-- Create Function
CREATE FUNCTION dbo.fnTest
(
       @Input VARCHAR(MAX)       
)
RETURNS @ReturnTable TABLE 
(
     Input VARCHAR(1000)
)
AS
/************************************************************************************
DESCRIPTION: This is a Test function to test build. To be Deleted.
*************************************************************************************/
BEGIN
       /*-- TEST HARNESS
       SELECT * FROM dbo.fnTest ('Test')
       -- TEST HARNESS */

	   

       INSERT INTO @ReturnTable
       SELECT @Input 

       RETURN
END
GO
