	
DECLARE @stored_procedure_name VARCHAR(MAX), @query VARCHAR(MAX)
SET @stored_procedure_name = 'UspFetchEmailList'

IF EXISTS (SELECT * FROM sys.procedures WHERE name like @stored_procedure_name)
BEGIN
SET @query = 'DROP PROC ' + @stored_procedure_name
EXEC (@query)
END

GO

CREATE PROCEDURE  [dbo].[UspFetchEmailList]
	@WorkFlowId INT,
	@Topic NVARCHAR(250),	
	@RootTopic NVARCHAR(50)
AS
BEGIN
	SET NOCOUNT ON
	
	/* TEST HARNESS
	EXEC dbo.UspFetchEmailList 15, 'ExceptionFailedSolveRequestCreation', 'MPS'
	*/
	DECLARE @WorkFlowIdLocal INT = @WorkFlowId
	DECLARE @TopicLocal VARCHAR(250) = @Topic
	DECLARE @RootTopicLocal VARCHAR(10) = @RootTopic
	
	SELECT DISTINCT t3.Email 
	FROM [dbo].RefFlowStrategyTopicRoleEmail t1 (NOLOCK)
	INNER JOIN [dbo].RefWorkFlowDefinition t4 (NOLOCK)
		ON t4.WorkFlowId = t1.WorkFlowId
	INNER JOIN dbo.ApplicationUserRole t2 (NOLOCK)
		ON t1.RoleID = t2.RoleID
	INNER JOIN dbo.ApplicationUser t3 (NOLOCK)
		ON t2.UserID = t3.UserID
	WHERE t1.SubscriptionTopic = @TopicLocal
		AND t4.RootTopic = @RootTopicLocal
		AND t4.WorkFlowId = @WorkFlowIdLocal
	ORDER BY t3.Email 


SET NOCOUNT OFF
END


GO