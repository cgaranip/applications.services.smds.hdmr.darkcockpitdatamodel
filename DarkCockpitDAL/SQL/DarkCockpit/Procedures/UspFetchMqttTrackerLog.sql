	
DECLARE @stored_procedure_name VARCHAR(MAX), @query VARCHAR(MAX)
SET @stored_procedure_name = 'UspFetchMqttTrackerLog'

IF EXISTS (SELECT * FROM sys.procedures WHERE name like @stored_procedure_name)
BEGIN
SET @query = 'DROP PROC ' + @stored_procedure_name
EXEC (@query)
END

GO

CREATE PROCEDURE  [dbo].[UspFetchMqttTrackerLog]
	@RootTopic NVARCHAR(50),
	@WorkFlowId INT	
AS
BEGIN
	SET NOCOUNT ON
	
	/* TEST HARNESS
	EXEC dbo.UspFetchMqttTrackerLog 'MPS',11
	*/
	DECLARE @RootTopicLocal VARCHAR(10) = @RootTopic
	DECLARE @WorkFlowIdLocal INT = @WorkFlowId
	
	DECLARE @MaxRunId INT

	SELECT @MaxRunId= MAX(RunId)
	FROM dbo.DataMqttTrackerLog
	WHERE WorkFlowId = @WorkFlowIdLocal
    AND RootTopic= @RootTopic		
	
	SELECT Topic, CreatedOn
	FROM dbo.DataMqttTrackerLog
	WHERE WorkFlowId = @WorkFlowIdLocal
    AND RootTopic= @RootTopic
	and Runid = @MaxRunId
	ORDER BY Createdon DESC
	


SET NOCOUNT OFF
END


GO