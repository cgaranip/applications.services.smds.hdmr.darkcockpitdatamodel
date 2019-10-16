	
DECLARE @stored_procedure_name VARCHAR(MAX), @query VARCHAR(MAX)
SET @stored_procedure_name = 'UspUpdateWorkFlowDetails'

IF EXISTS (SELECT * FROM sys.procedures WHERE name like @stored_procedure_name)
BEGIN
SET @query = 'DROP PROC ' + @stored_procedure_name
EXEC (@query)
END

GO
--Updates the version and snapshotid 
CREATE PROCEDURE  [dbo].[UspUpdateWorkFlowDetails]
	@WorkFlowId INT,
	@RunId INT = -1,
	@VersionId INT = -1,
	@SnapshotId INT = -1,
	@PayLoadJSON NVARCHAR(MAX) ='',
	@ModifiedBy NVARCHAR(255) = 'system'
AS
BEGIN
	SET NOCOUNT ON
	
	/* TEST HARNESS
	EXEC dbo.UspUpdateWorkFlowDetails 1, 40747, 2, 1, '{AutoJobWorkFlow:"ExternalHybridRTFReadyMonthly", VersionId:"0", SCLPValue:1, PRFVersionid:57, BatchId:"2019.09.27.02.45.16.jnarayan", Forceload:false}', 'jnarayan'
	*/
	DECLARE @WorkFlowIdLocal INT = @WorkFlowId
	DECLARE @VersionIdLocal INT = @VersionId
	DECLARE @SnapshotIdLocal INT = @SnapshotId
	DECLARE @RunIdLocal INT = @RunId
	DECLARE @PayLoadJSONLocal NVARCHAR(MAX) = @PayLoadJSON
	DECLARE @ModifiedByLocal NVARCHAR(50) = @ModifiedBy

	DECLARE @CreatedDate DATETIME = GETUTCDATE()
	
		UPDATE [dbo].[WorkFlowStatus]
		SET VersionId = @VersionIdLocal,
			SnapshotId = CASE WHEN @SnapshotId = -9999 THEN SnapshotId ELSE @SnapshotIdLocal END,
			PayLoadJSON = @PayLoadJSONLocal,
			ModifiedOn = @CreatedDate,
			ModifiedBy = @ModifiedByLocal
		WHERE WorkFlowId = @WorkFlowIdLocal
		AND RunId= @RunIdLocal
	
	SET NOCOUNT OFF
END


GO