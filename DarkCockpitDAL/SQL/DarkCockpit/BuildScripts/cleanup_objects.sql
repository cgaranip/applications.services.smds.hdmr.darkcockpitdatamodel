--------------------------------
---------- DROP VIEWS ----------
--------------------------------

DECLARE @name varchar(255)
DECLARE @s varchar(max)
SET @s = ' '

DECLARE c CURSOR FOR
SELECT name FROM sys.views WHERE name like 'v_%'

OPEN c
FETCH NEXT FROM c
INTO @name

WHILE @@FETCH_STATUS = 0

BEGIN	

	SET @s = 'DROP VIEW [' + @name + ']'

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
SELECT name FROM sys.procedures WHERE name like 'usp_%'

OPEN c
FETCH NEXT FROM c
INTO @name

WHILE @@FETCH_STATUS = 0

BEGIN	

	SET @s = 'DROP PROCEDURE [' + @name + ']'

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
SELECT name FROM sys.objects WHERE name like 'ufn_%'

OPEN c
FETCH NEXT FROM c
INTO @name

WHILE @@FETCH_STATUS = 0

BEGIN	

	SET @s = 'DROP FUNCTION [' + @name + ']'

	EXEC(@s)

	FETCH NEXT FROM c
	INTO @name

END

CLOSE c
DEALLOCATE c
GO
