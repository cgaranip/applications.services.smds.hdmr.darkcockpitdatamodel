	
DECLARE @stored_procedure_name VARCHAR(MAX), @query VARCHAR(MAX)
SET @stored_procedure_name = 'UspFetchAuthorizeUserList'

IF EXISTS (SELECT * FROM sys.procedures WHERE name like @stored_procedure_name)
BEGIN
SET @query = 'DROP PROC ' + @stored_procedure_name
EXEC (@query)
END

GO

CREATE PROCEDURE  [dbo].[UspFetchAuthorizeUserList]
@UserName VARCHAR(50), 
	@RootTopic VARCHAR(10),
	@Role  VARCHAR(50) = NULL
AS
BEGIN
	SET NOCOUNT ON
	
	/* TEST HARNESS
	EXEC dbo.UspFetchAuthorizeUserList 'gar\alock1', 'MPS'
	*/

	DECLARE @UserNameLocal VARCHAR(30) = @UserName
	DECLARE @RootTopicLocal VARCHAR(10) = @RootTopic
	DECLARE @RoleLocal VARCHAR(50) = @Role
	
	IF(@RoleLocal IS NULL)
	BEGIN
		SELECT DISTINCT t1.LoginID
		FROM dbo.ApplicationUser t1 (NOLOCK)
		INNER JOIN dbo.ApplicationUserRole t2 (NOLOCK)
			ON t1.UserId = t2.UserId
		INNER JOIN dbo.ApplicationRole t3 (NOLOCK)
			ON t2.RoleId = t3.RoleId
		WHERE t1.LoginID = @UserNameLocal
			AND t3.RootTopic = @RootTopicLocal
	END
	ELSE
	BEGIN
		SELECT DISTINCT t1.LoginID
		FROM dbo.ApplicationUser t1 (NOLOCK)
		INNER JOIN dbo.ApplicationUserRole t2 (NOLOCK)
			ON t1.UserId = t2.UserId
		INNER JOIN dbo.ApplicationRole t3 (NOLOCK)
			ON t2.RoleId = t3.RoleId
		WHERE t1.LoginID = @UserNameLocal
			AND t3.RootTopic = @RootTopicLocal
			AND t3.RoleName = @Role
	END

SET NOCOUNT OFF
END

GO