	
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
	@RoleDisplayName  VARCHAR(50) = NULL
AS
BEGIN
	SET NOCOUNT ON
	
	/* TEST HARNESS
	EXEC dbo.UspFetchAuthorizeUserList 'sys_scdssctmps', 'MPS'
	*/

    -- Strip out the domain name if there is one.
    DECLARE @DomainIndex INT
	SET @DomainIndex = CHARINDEX('\',@UserName)
	--SELECT @DomainIndex;
	DECLARE @UserNameLength INT
	SET @UserNameLength = LEN(@UserName)
	--SELECT @UserNameLength;
	IF (@DomainIndex > 0)
	BEGIN
  		SELECT @UserName = RTRIM(SUBSTRING(@UserName,@DomainIndex + 1, @UserNameLength))
	END
	
	DECLARE @UserNameLocal VARCHAR(30) = @UserName
	DECLARE @RootTopicLocal VARCHAR(10) = @RootTopic
	DECLARE @RoleDisplayNameLocal VARCHAR(50) = @RoleDisplayName
	
	IF(@RoleDisplayNameLocal IS NULL)
	BEGIN
		SELECT DISTINCT t1.LoginID, t3.RoleName, t3.RoleDisplayName
		FROM dbo.ApplicationUser t1 (NOLOCK)
		INNER JOIN dbo.ApplicationUserRole t2 (NOLOCK)
			ON t1.UserId = t2.UserId
		INNER JOIN dbo.ApplicationRole t3 (NOLOCK)
			ON t2.RoleId = t3.RoleId
		WHERE t1.LoginID = @UserNameLocal
			AND t3.RootTopic = @RootTopicLocal
			AND t1.StatusID = 1
	END
	ELSE
	BEGIN
		SELECT DISTINCT t1.LoginID, t3.RoleName, t3.RoleDisplayName
		FROM dbo.ApplicationUser t1 (NOLOCK)
		INNER JOIN dbo.ApplicationUserRole t2 (NOLOCK)
			ON t1.UserId = t2.UserId
		INNER JOIN dbo.ApplicationRole t3 (NOLOCK)
			ON t2.RoleId = t3.RoleId
		WHERE t1.LoginID = @UserNameLocal
			AND t3.RootTopic = @RootTopicLocal
			AND t3.RoleDisplayName = @RoleDisplayName
			AND t1.StatusID = 1
	END

SET NOCOUNT OFF
END

GO