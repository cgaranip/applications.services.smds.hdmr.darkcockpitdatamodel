INSERT INTO [dbo].[RefWorkFlowDefinition](RootTopic, WorkflowName, IsActive)
SELECT T.RootTopic, T.WorkflowName, T.IsActive
FROM
(
	SELECT 'MPS' AS RootTopic, 'SDA PRF Version Backup' AS WorkflowName, 1 AS IsActive
) T
LEFT JOIN [dbo].[RefWorkFlowDefinition] R
	ON R.RootTopic = T.RootTopic
	AND R.WorkflowName = T.WorkflowName
WHERE R.WorkflowName IS NULL

GO

DECLARE @WorkFlowId INT = (SELECT WorkflowId FROM dbo.RefWorkFlowDefinition WHERE RootTopic ='MPS' AND WorkflowName = 'SDA PRF Version Backup')

INSERT INTO [dbo].[RefFlowStrategyDefinition](WorkFlowId, SubscriptionTopic, PublishTopic, ActionURL, ActionURLArgsJSON, SendEmail, StrategyDefinitionClass, AllowInitiateWhileWFInProgress)
SELECT T.WorkFlowId, T.SubscriptionTopic, T.PublishTopic, T.ActionURL, T.ActionURLArgsJSON, T.SendEmail, T.StrategyDefinitionClass, T.AllowInitiateWhileWFInProgress
FROM
(
SELECT @WorkFlowId AS WorkFlowId, 'InitiateSDAPRFVersionBackup' AS SubscriptionTopic, 'SDAPRFVersionBackup' AS PublishTopic, NULL AS ActionURL, NULL AS ActionURLArgsJSON, 0 AS SendEmail, 'DarkCockpitWebAPIMain.FlowStrategy.BaseFlowStrategy' AS StrategyDefinitionClass, 0 AS AllowInitiateWhileWFInProgress
UNION 
SELECT @WorkFlowId, 'CompletedSDAPRFVersionBackup', 'CompletedEndMPSWorkFlow', NULL, NULL, 0, 'DarkCockpitWebAPIMain.FlowStrategy.BaseFlowStrategy' AS StrategyDefinitionClass, 0 AS AllowInitiateWhileWFInProgress
UNION 
SELECT @WorkFlowId, 'ExceptionSDAPRFVersionBackup', 'ExceptionEndMPSWorkFlow', NULL, NULL, 0, 'DarkCockpitWebAPIMain.FlowStrategy.BaseFlowStrategy' AS StrategyDefinitionClass, 0 AS AllowInitiateWhileWFInProgress
UNION 
SELECT @WorkFlowId, 'CompletedEndMPSWorkFlow', 'None', '/UpdateWorkFlowStatus', NULL, 1, 'DarkCockpitWebAPIMain.FlowStrategy.BaseFlowStrategyCompleteEnd' AS StrategyDefinitionClass, 1 AS AllowInitiateWhileWFInProgress
UNION 
SELECT @WorkFlowId, 'ExceptionEndMPSWorkFlow', 'None', '/UpdateWorkFlowStatus', NULL, 1, 'DarkCockpitWebAPIMain.FlowStrategy.BaseFlowStrategyExceptionEnd' AS StrategyDefinitionClass, 1 AS AllowInitiateWhileWFInProgress
) T
LEFT JOIN dbo.RefFlowStrategyDefinition R
	ON R.WorkFlowId = T.WorkFlowId
	AND R.SubscriptionTopic = T.SubscriptionTopic
	WHERE R.SubscriptionTopic IS NULL

INSERT INTO [dbo].[RefFlowStrategyTopicRoleEmail](WorkFlowId, SubscriptionTopic, RoleID)
SELECT T.WorkFlowId, T.SubscriptionTopic, T.RoleID
FROM
(
	SELECT @WorkFlowId AS WorkFlowId, 'CompletedEndMPSWorkFlow' AS SubscriptionTopic, 1 AS RoleID
	UNION 
	SELECT @WorkFlowId, 'ExceptionEndMPSWorkFlow', 1 AS RoleID
) T
LEFT JOIN [dbo].[RefFlowStrategyTopicRoleEmail] R
	ON R.WorkFlowId = T.WorkFlowId
	AND R.SubscriptionTopic = T.SubscriptionTopic
	WHERE R.SubscriptionTopic IS NULL

INSERT INTO WorkflowScheduleDefiniton(WorkFlowId, CronSchedule, PublishTopic, Active, MessagePayload, TimeZoneInfo)
SELECT T.WorkFlowId, T.CrosSchedule, t.PublishTopic, t.Active, t.MessagePayLoad, t.TimeZoneInfo
FROM
(
	SELECT @WorkFlowId AS WorkFlowId, '0 00 9 ? * WED-THU' AS CrosSchedule
		, 'InitiateSDAPRFVersionBackup' AS PublishTopic, 1 AS Active, '' MessagePayLoad
		, 'Singapore Standard Time' AS TimeZoneInfo
) T
LEFT JOIN [dbo].[WorkflowScheduleDefiniton] R
	ON R.WorkFlowId = T.WorkFlowId
	AND R.PublishTopic = T.PublishTopic
	WHERE R.PublishTopic IS NULL