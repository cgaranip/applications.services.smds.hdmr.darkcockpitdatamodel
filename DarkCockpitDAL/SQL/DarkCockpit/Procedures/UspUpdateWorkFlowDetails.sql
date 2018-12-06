	
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
	@ModifiedBy NVARCHAR(255) = 'system'
AS
BEGIN
	SET NOCOUNT ON
	
	/* TEST HARNESS
	EXEC dbo.UspUpdateWorkFlowDetails 11, 1, 2, 1, 'jnarayan'
	*/
	DECLARE @WorkFlowIdLocal INT = @WorkFlowId
	DECLARE @VersionIdLocal INT = @VersionId
	DECLARE @SnapshotIdLocal INT = @SnapshotId
	DECLARE @RunIdLocal INT = @RunId
	DECLARE @ModifiedByLocal NVARCHAR(50) = @ModifiedBy

	DECLARE @CreatedDate DATETIME = GETUTCDATE()
	
		UPDATE [dbo].[WorkFlowStatus]
		SET VersionId = @VersionIdLocal,
			SnapshotId = @SnapshotIdLocal,
			ModifiedOn = @CreatedDate,
			ModifiedBy = @ModifiedByLocal
		WHERE WorkFlowId = @WorkFlowIdLocal
		AND RunId= @RunIdLocal
	
	SET NOCOUNT OFF
END


GO