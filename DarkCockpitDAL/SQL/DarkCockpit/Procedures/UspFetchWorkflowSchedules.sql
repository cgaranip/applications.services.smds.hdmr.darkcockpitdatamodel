	
DECLARE @stored_procedure_name VARCHAR(MAX), @query VARCHAR(MAX)
SET @stored_procedure_name = 'UspFetchWorkflowSchedules'

IF EXISTS (SELECT * FROM sys.procedures WHERE name like @stored_procedure_name)
BEGIN
SET @query = 'DROP PROC ' + @stored_procedure_name
EXEC (@query)
END

GO

CREATE PROCEDURE  [dbo].[UspFetchWorkflowSchedules]
	@RootTopic NVARCHAR(50)
AS
BEGIN
	SET NOCOUNT ON
	
	/* TEST HARNESS
	EXEC dbo.UspFetchWorkflowSchedules 'MPS'
	*/
	DECLARE @RootTopicLocal NVARCHAR(50) = @RootTopic
	
    SELECT R.WorkFlowId, R.WorkflowName, [CronSchedule]
      ,[PublishTopic]
	FROM [DarkCockpit].[dbo].[WorkflowScheduleDefiniton] W
	INNER JOIN [dbo].[RefWorkFlowDefinition] R
		ON W.WorkflowId = R.WorkflowId
	WHERE R.RootTopic = @RootTopicLocal
	

SET NOCOUNT OFF
END


GO