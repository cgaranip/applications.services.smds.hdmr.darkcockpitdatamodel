--------------------------------
---------- DROP VIEWS ----------
--------------------------------

DECLARE @name varchar(255)
DECLARE @s varchar(max)
SET @s = ' '

DECLARE c CURSOR FOR
SELECT name FROM sys.views WHERE schema_id = SCHEMA_ID('dbo') AND name like 'v_%'

OPEN c
FETCH NEXT FROM c
INTO @name

WHILE @@FETCH_STATUS = 0

BEGIN	

	SET @s = 'DROP VIEW [' + @name + ']'

	print 'Trying to ' + @s
	EXEC(@s)

	FETCH NEXT FROM c
	INTO @name

END

CLOSE c
DEALLOCATE c
go

-------------------------------------
---------- DROP PROCEDURES ----------
-------------------------------------

DECLARE @name varchar(255)
DECLARE @s varchar(max)
SET @s = ' '

DECLARE c CURSOR FOR
SELECT name FROM sys.procedures WHERE schema_id = SCHEMA_ID('dbo') AND name like 'usp_%'

OPEN c
FETCH NEXT FROM c
INTO @name

WHILE @@FETCH_STATUS = 0

BEGIN	

	SET @s = 'DROP PROCEDURE [' + @name + ']'

	print 'Trying to ' + @s
	EXEC(@s)

	FETCH NEXT FROM c
	INTO @name

END

CLOSE c
DEALLOCATE c
GO

------------------------------------
---------- DROP FUNCTIONS ----------
------------------------------------

DECLARE @name varchar(255)
DECLARE @s varchar(max)
SET @s = ' '

DECLARE c CURSOR FOR
SELECT name FROM sys.objects WHERE schema_id = SCHEMA_ID('dbo') AND name like 'fn_%'

OPEN c
FETCH NEXT FROM c
INTO @name

WHILE @@FETCH_STATUS = 0

BEGIN	

	SET @s = 'DROP FUNCTION [' + @name + ']'

	print 'Trying to ' + @s
	EXEC(@s)

	FETCH NEXT FROM c
	INTO @name

END

CLOSE c
DEALLOCATE c
GO

------------------------------------
---------- DROP CONSTANTS----------
------------------------------------

DECLARE @name varchar(255)
DECLARE @s varchar(max)
SET @s = ' '

DECLARE c CURSOR FOR
SELECT name FROM sys.objects WHERE schema_id = SCHEMA_ID('dbo') AND name like 'CONST_%'

OPEN c
FETCH NEXT FROM c
INTO @name

WHILE @@FETCH_STATUS = 0

BEGIN	

	SET @s = 'DROP FUNCTION [' + @name + ']'

	print 'Trying to ' + @s
	EXEC(@s)

	
	FETCH NEXT FROM c
	INTO @name

END

CLOSE c
DEALLOCATE c
GO

