
DECLARE @stored_procedure_name VARCHAR(MAX) = 'UspCreateAllStaticIdNameCONSTFunctions'
DECLARE @query VARCHAR(MAX) = 'DROP PROC ' + @stored_procedure_name

IF EXISTS (SELECT * FROM sys.procedures WHERE name like @stored_procedure_name)
BEGIN
	EXEC (@query)
END
GO

-- Create Procedure
CREATE PROC dbo.UspCreateAllStaticIdNameCONSTFunctions
AS
/************************************************************************************
DESCRIPTION: This proc is used to create CONST function for both Id and Name for the STATIC data
*************************************************************************************/
BEGIN
	SET NOCOUNT ON

	/*-- TEST HARNESS
	EXEC dbo.UspCreateAllStaticIdNameCONSTFunctions
	-- TEST HARNESS*/

	-- StaticTables
	BEGIN
		DECLARE @StaticTables TABLE
		(
			Id INT IDENTITY(1, 1)
			, TblName VARCHAR(100)
			, IdColumn VARCHAR(100)
			, NameColumn VARCHAR(100)
			, CreateIdConstant BIT
			, CreateNameConstant BIT
		)
		
		-- Insert any Ref Tables for which constants need to be generated	
		INSERT INTO @StaticTables
		SELECT 'RefStatus' AS TblName, 'StatusId' AS IdColumn, 'Status' AS NameColumn, 1 AS CreateIdConstant, 1 AS CreateNameConstant 
		
	
	END

	-- Cursor for Looping StaticTables and get TableName, Id & Name Column
	BEGIN
		DECLARE @Debug BIT = 1
		DECLARE @TblName VARCHAR(100)
		DECLARE @IdColumn VARCHAR(100)
		DECLARE @NameColumn VARCHAR(100)
		DECLARE @CreateIdConstant BIT
		DECLARE @CreateNameConstant BIT
		DECLARE @SQLStaticTables VARCHAR(MAX)

		DECLARE MyCurStaticTables CURSOR FOR
		SELECT TblName, IdColumn, NameColumn, CreateIdConstant, CreateNameConstant FROM @StaticTables

		OPEN MyCurStaticTables
		FETCH NEXT FROM MyCurStaticTables INTO @TblName, @IdColumn, @NameColumn, @CreateIdConstant, @CreateNameConstant

		WHILE @@FETCH_STATUS = 0
		BEGIN
			--SELECT @TblName AS TblName, @IdColumn AS IdColumn, @NameColumn AS NameColumn, @CreateIdConstant AS CreateIdConstant, @CreateNameConstant AS CreateNameConstant

			SET @SQLStaticTables = 'SELECT DISTINCT ' + @IdColumn + ' AS IdColumn, ' + @NameColumn + ' AS NameColumn INTO ##temp FROM ' + @TblName
			--PRINT @SQLStaticTables
			EXEC (@SQLStaticTables)
			--SELECT * FROM ##temp

			-- Cursor for Looping current StaticTable Data and get Id & Name data
			BEGIN
				DECLARE @IdColumnData VARCHAR(100)
				DECLARE @NameColumnData VARCHAR(100)
				DECLARE @SQLIdNameColumnData_DROP VARCHAR(MAX)
				DECLARE @SQLIdNameColumnData_CREATE VARCHAR(MAX)

				DECLARE MyCurIdNameColumnData CURSOR FOR
				SELECT IdColumn, NameColumn FROM ##temp

				OPEN MyCurIdNameColumnData
				FETCH NEXT FROM MyCurIdNameColumnData INTO @IdColumnData, @NameColumnData

				WHILE @@FETCH_STATUS = 0
				BEGIN
					--SELECT @IdColumnData AS IdColumnData, @NameColumnData AS NameColumnData
					-- Generate Id Constants
					IF (@CreateIdConstant = 1)
					BEGIN
						-- Drop Constant
						BEGIN
							SET @SQLIdNameColumnData_DROP = N'IF EXISTS (SELECT * FROM sys.objects  WHERE type in (N''FN'', N''IF'', N''TF'', N''FS'', N''FT'') AND OBJECT_ID = OBJECT_ID(N''CONST_' + @IdColumn + '_' + REPLACE(@NameColumnData, '-', '_') + ''') )
								BEGIN
									DROP FUNCTION dbo.CONST_' + @IdColumn + '_' + REPLACE(@NameColumnData, '-', '_') + '
								END'
							IF (@Debug = 1)
								PRINT @SQLIdNameColumnData_DROP + ' 
								GO '
							ELSE
								EXEC (@SQLIdNameColumnData_DROP)
						END

						-- Create Constant
						BEGIN
							SET @SQLIdNameColumnData_CREATE = N'CREATE FUNCTION dbo.CONST_' + @IdColumn + '_' + REPLACE(@NameColumnData, '-', '_') + '()
									RETURNS INT
								AS
								BEGIN
									RETURN 
										(SELECT TOP 1 ' + @IdColumn + ' FROM dbo.' + @TblName + ' (NOLOCK) WHERE ' + @NameColumn + ' = ''' + @NameColumnData + ''')
								END'
							IF (@Debug = 1)
								PRINT @SQLIdNameColumnData_CREATE + ' 
								GO '
							ELSE
								EXEC (@SQLIdNameColumnData_CREATE)
						END
					END

					-- Generate Name Constants
					IF (@CreateNameConstant = 1)
					BEGIN
						-- Drop Constant
						BEGIN
							SET @SQLIdNameColumnData_DROP = N'IF EXISTS (SELECT * FROM sys.objects  WHERE type in (N''FN'', N''IF'', N''TF'', N''FS'', N''FT'') AND OBJECT_ID = OBJECT_ID(N''CONST_' + @NameColumn + '_' + REPLACE(@NameColumnData, '-', '_') + ''') )
								BEGIN
									DROP FUNCTION dbo.CONST_' + @NameColumn + '_' + REPLACE(@NameColumnData, '-', '_') + '
								END'
							IF (@Debug = 1)
								PRINT @SQLIdNameColumnData_DROP + ' 
								GO '
							ELSE
								EXEC (@SQLIdNameColumnData_DROP)
						END

						-- Create Constant
						BEGIN
							SET @SQLIdNameColumnData_CREATE = N'CREATE FUNCTION dbo.CONST_' + @NameColumn + '_' + REPLACE(@NameColumnData, '-', '_') + '()
									RETURNS VARCHAR(250)
								AS
								BEGIN
									RETURN 
										(SELECT TOP 1 ' + @NameColumn + ' FROM dbo.' + @TblName + ' (NOLOCK) WHERE ' + @NameColumn + ' = ''' + @NameColumnData + ''')
								END'
							IF (@Debug = 1)
								PRINT @SQLIdNameColumnData_CREATE + ' 
								GO '
							ELSE
								EXEC (@SQLIdNameColumnData_CREATE)
						END
					END

					FETCH NEXT FROM MyCurIdNameColumnData INTO @IdColumnData, @NameColumnData
				END   

				CLOSE MyCurIdNameColumnData   
				DEALLOCATE MyCurIdNameColumnData
			END

			DROP TABLE ##temp
			FETCH NEXT FROM MyCurStaticTables INTO @TblName, @IdColumn, @NameColumn, @CreateIdConstant, @CreateNameConstant
		END   

		CLOSE MyCurStaticTables   
		DEALLOCATE MyCurStaticTables
	END

	SET NOCOUNT OFF
END
GO