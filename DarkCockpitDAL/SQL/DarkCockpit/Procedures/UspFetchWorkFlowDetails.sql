	
DECLARE @stored_procedure_name VARCHAR(MAX), @query VARCHAR(MAX)
SET @stored_procedure_name = 'UspFetchWorkFlowDetails'

IF EXISTS (SELECT * FROM sys.procedures WHERE name like @stored_procedure_name)
BEGIN
SET @query = 'DROP PROC ' + @stored_procedure_name
EXEC (@query)
END

GO

CREATE PROCEDURE  [dbo].[UspFetchWorkFlowDetails]
	@RunId INT,
	@WorkFlowId INT	
AS
BEGIN
	SET NOCOUNT ON
	
	/* TEST HARNESS
	EXEC dbo.UspFetchWorkFlowDetails 40744,1017
	*/
	DECLARE @RunIdLocal INT = @RunId
	DECLARE @WorkFlowIdLocal INT = @WorkFlowId
	
	SELECT VersionId,SnapshotId, PayLoadJSON
	FROM dbo.WorkFlowStatus
	WHERE Runid = @RunIdLocal
	AND WorkFlowId = @WorkFlowIdLocal


SET NOCOUNT OFF
END


GO