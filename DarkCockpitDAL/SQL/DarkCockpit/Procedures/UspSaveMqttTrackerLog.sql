	
DECLARE @stored_procedure_name VARCHAR(MAX), @query VARCHAR(MAX)
SET @stored_procedure_name = 'UspSaveMqttTrackerLog'

IF EXISTS (SELECT * FROM sys.procedures WHERE name like @stored_procedure_name)
BEGIN
SET @query = 'DROP PROC ' + @stored_procedure_name
EXEC (@query)
END

GO

CREATE PROCEDURE  [dbo].[UspSaveMqttTrackerLog]
	@ClientId NVARCHAR(255), 
	@RootTopic NVARCHAR(50),
	@WorkFlowId INT,
	@RunId INT,
	@ClientType NVARCHAR(100),	
	@Topic NVARCHAR(250),
	@Message NVARCHAR(1000),
	@CreatedOn DATETIME,
	@CreatedBy NVARCHAR(255)
AS
BEGIN
	SET NOCOUNT ON
	
	/* TEST HARNESS
	EXEC dbo.UspSaveMqttTrackerLog 'Test', 'MPS',-1,-1, 'Publish' , 'Test', 'Test', '3-14-2018', 'Test'
	*/

	DECLARE @ClientIdLocal NVARCHAR(255) = @ClientId
	DECLARE @RootTopicLocal NVARCHAR(50) = @RootTopic
	DECLARE @WorkFlowIdLocal INT = @WorkFlowId
	DECLARE @RunIdLocal INT = @Runid
	DECLARE @ClientTypeLocal NVARCHAR(100) = @ClientType
	DECLARE @TopicLocal VARCHAR(250) = @Topic
	DECLARE @MessageLocal VARCHAR(1000) = @Message
	DECLARE @CreatedOnLocal DATETIME = @CreatedOn
	DECLARE @CreatedByLocal NVARCHAR(255) = @CreatedBy

	INSERT INTO dbo.DataMqttTrackerLog
	SELECT @ClientIdLocal, @RootTopicLocal, @WorkFlowIdLocal, @RunIdLocal, @ClientTypeLocal, @TopicLocal, @MessageLocal, @CreatedOnLocal, @CreatedByLocal

SET NOCOUNT OFF
END

GO