	
DECLARE @stored_procedure_name VARCHAR(MAX), @query VARCHAR(MAX)
SET @stored_procedure_name = 'UspFetchEmailList'

IF EXISTS (SELECT * FROM sys.procedures WHERE name like @stored_procedure_name)
BEGIN
SET @query = 'DROP PROC ' + @stored_procedure_name
EXEC (@query)
END

GO

CREATE PROCEDURE  [dbo].[UspFetchEmailList]
	@Topic NVARCHAR(250),
	@RootTopic NVARCHAR(50)
AS
BEGIN
	SET NOCOUNT ON
	
	/* TEST HARNESS
	EXEC dbo.UspFetchEmailList 'LoadSnapshot', 'MPS'
	*/

	DECLARE @TopicLocal VARCHAR(30) = @Topic
	DECLARE @RootTopicLocal VARCHAR(10) = @RootTopic
	
	SELECT DISTINCT t3.Email 
	FROM [dbo].RefFlowStrategyTopicRoleEmail t1 (NOLOCK)
	INNER JOIN dbo.ApplicationUserRole t2 (NOLOCK)
		ON t1.RoleID = t2.RoleID
	INNER JOIN dbo.ApplicationUser t3 (NOLOCK)
		ON t2.UserID = t3.UserID
	WHERE t1.SubscriptionTopic = @TopicLocal
		AND t1.RootTopic = @RootTopicLocal
	ORDER BY t3.Email 

SET NOCOUNT OFF
END


GO