	
DECLARE @stored_procedure_name VARCHAR(MAX), @query VARCHAR(MAX)
SET @stored_procedure_name = 'UspUpdateWorkFlowStatus'

IF EXISTS (SELECT * FROM sys.procedures WHERE name like @stored_procedure_name)
BEGIN
SET @query = 'DROP PROC ' + @stored_procedure_name
EXEC (@query)
END

GO
--Inserts a new status record for a workflow ( if not already running) or updates status of the workflow( if already running) 
-- This is invoked from DCDAL for DC Web and also from MPSAutonomousDAL for the autonmous services.
CREATE PROCEDURE  [dbo].[UspUpdateWorkFlowStatus]
	@WorkFlowId INT,
	@RootTopic NVARCHAR(50),
	@Topic NVARCHAR(250)= '',
	@RunId INT = -1,
	@StatusId INT = -1,
	@CreatedBy NVARCHAR(255) = 'system'
AS
BEGIN
	SET NOCOUNT ON
	
	/* TEST HARNESS
	EXEC dbo.UspUpdateWorkFlowStatus 11, 'MPS', 'LoadSnapshot'
	EXEC dbo.UspUpdateWorkFlowStatus 11, 'MPS', 'EndMPSWorkFlow'
	EXEC dbo.UspUpdateWorkFlowStatus 11, 'MPS','', 1, 2, 'jnarayan'
	*/
	DECLARE @WorkFlowIdLocal INT = @WorkFlowId
	DECLARE @StatusIdLocal INT = @StatusId
	DECLARE @RootTopicLocal VARCHAR(50) = @RootTopic
	DECLARE @TopicLocal VARCHAR(250) = @Topic
	DECLARE @RunIdLocal INT = @RunId
	DECLARE @CreatedByLocal NVARCHAR(50) = @CreatedBy

	DECLARE @CreatedDate DATETIME = GETUTCDATE()

	DECLARE @Status_RunningId INT = (SELECT [dbo].[CONST_StatusId_Running]())
	DECLARE @Status_CompletedId INT = (SELECT [dbo].[CONST_StatusId_Completed]())
	DECLARE @Status_FailureId INT = (SELECT [dbo].[CONST_StatusId_Failure]())

	DECLARE @AllowInitiateWhileWFInProgress  BIT =0;
	
	--Fetch the value of AllowInitiateWhileWFInProgress from [dbo].[RefFlowStrategyDefinition]
	--this decides if we are able to intiate these topics for current runId even if WF is running
	SELECT @AllowInitiateWhileWFInProgress = AllowInitiateWhileWFInProgress FROM [dbo].[RefFlowStrategyDefinition]
	WHERE SubscriptionTopic = @TopicLocal
	AND WorkFlowId = @WorkFlowIdLocal	

	IF (@StatusId = -1) -- workflow topic is being kicked off
	BEGIN		
		-- Get the status of the latest run for the workflowid
		DECLARE @LatestStatusId INT
		DECLARE @LatestRunId INT
		SELECT TOP(1)  @LatestStatusId = StatusId, @LatestRunId = RunId
		FROM [dbo].[WorkFlowStatus]
		WHERE [WorkFlowId] = @WorkFlowIdLocal
		ORDER BY ModifiedOn DESC

		--If the workflow is currently running return -1
		IF(@LatestStatusId = @Status_RunningId)
		BEGIN

			IF (@AllowInitiateWhileWFInProgress = 1) -- if for current workflow we can publish topic eventhough it is running
			BEGIN
				SELECT @LatestRunId AS RunId
			END
			ELSE
			BEGIN
				SELECT -1 AS RunId -- indicates that new run cannot be triggered
			END

		END
		ELSE
		BEGIN
			-- The Workflow is not running currently so insert new running record
			INSERT INTO [dbo].[WorkFlowStatus]( [WorkFlowId], [StatusId], [VersionId], [SnapshotId], [CreatedOn], [ModifiedOn], [CreatedBy], [ModifiedBy])
			SELECT @WorkFlowIdLocal,  @Status_RunningId, -1, -1, @CreatedDate, @CreatedDate, @CreatedByLocal, @CreatedByLocal

			SELECT @@IDENTITY AS RunId
		END
	END
	ELSE -- updating status of currently running workflow
	BEGIN
		UPDATE [dbo].[WorkFlowStatus]
		SET StatusId = @StatusIdLocal,
			ModifiedOn = @CreatedDate,
			ModifiedBy = @CreatedByLocal
		WHERE WorkFlowId = @WorkFlowIdLocal
		AND RunId= @RunIdLocal

		SELECT @RunIdLocal AS RunId
	END
	
	
SET NOCOUNT OFF
END


GO