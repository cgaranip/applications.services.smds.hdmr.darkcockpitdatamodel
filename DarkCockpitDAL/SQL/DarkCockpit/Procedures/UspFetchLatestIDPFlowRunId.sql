	
DECLARE @stored_procedure_name VARCHAR(MAX), @query VARCHAR(MAX)
SET @stored_procedure_name = 'UspFetchLatestIDPFlowRunId'

IF EXISTS (SELECT * FROM sys.procedures WHERE name like @stored_procedure_name)
BEGIN
SET @query = 'DROP PROC ' + @stored_procedure_name
EXEC (@query)
END

GO
/*
  This is called from MPSExternal Service(Invoked by IDP DataStaging to indicate DataStaging load is complete)
  The procedure checks which is the latest WF in running state where datastaging steps are being done. 
  Example the DataStaging WF, External Hybrid RTF Ready Monthly WF.. 
  The returned WorkFlowId is used by MPSExternalService to publish the IDPdataStagingLoadComplete Topic

*/

CREATE PROCEDURE  [dbo].[UspFetchLatestIDPFlowRunId]	
AS
BEGIN
	SET NOCOUNT ON
	
	/* TEST HARNESS
		EXEC dbo.UspFetchLatestIDPFlowRunId 
	*/	
	BEGIN TRY
		DECLARE @DataStagingLoadWorkFlowId INT
		DECLARE @ExternalHybridRTFReadyMonthlyWorkFlowId INT
		DECLARE @ExternalHybridRTFReadyWeeklyWorkFlowId INT
		DECLARE @StatusRunningId INT

		SELECT @DataStagingLoadWorkFlowId = WorkFlowId FROM RefWorkFlowDefinition WHERE WorkFLowName = 'DataStaging Load'
		SELECT @ExternalHybridRTFReadyMonthlyWorkFlowId = WorkFlowId FROM RefWorkFlowDefinition WHERE WorkFLowName = 'External Hybrid RTF Ready Monthly'
	    SELECT @ExternalHybridRTFReadyWeeklyWorkFlowId = WorkFlowId FROM RefWorkFlowDefinition WHERE WorkFLowName = 'External Hybrid RTF Ready Weekly'
		SELECT @StatusRunningId = [dbo].[CONST_StatusId_Running]()
		DECLARE @WorkFlowId INT = -1

		SELECT TOP(1) @WorkFlowId = WorkFlowId
		FROM dbo.WorkFlowStatus
		WHERE  WorkFlowId IN(@DataStagingLoadWorkFlowId, @ExternalHybridRTFReadyMonthlyWorkFlowId, @ExternalHybridRTFReadyWeeklyWorkFlowId)
		AND StatusId IN (@StatusRunningId)
		ORDER BY CreatedOn DESC
		
	END TRY
	BEGIN CATCH
		SET @WorkFlowId  = -1
	END CATCH

	SELECT @WorkFlowId AS WorkFlowId
SET NOCOUNT OFF
END


GO