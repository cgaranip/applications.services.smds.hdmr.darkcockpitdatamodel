
DECLARE @WorkFlowId INT = (SELECT WorkflowId FROM dbo.RefWorkFlowDefinition WHERE RootTopic ='MPS' AND WorkflowName = 'PRF Version Setup')


INSERT INTO [dbo].[RefFlowStrategyDefinition](WorkFlowId, SubscriptionTopic, PublishTopic, ActionURL, ActionURLArgsJSON, SendEmail, StrategyDefinitionClass, AllowInitiateWhileWFInProgress)
SELECT T.WorkFlowId, T.SubscriptionTopic, T.PublishTopic, T.ActionURL, T.ActionURLArgsJSON, T.SendEmail, T.StrategyDefinitionClass, T.AllowInitiateWhileWFInProgress
FROM
(
	SELECT @WorkFlowId AS WorkFlowId, 'FullAutoPOR' AS SubscriptonTopic, 'ResetAutoFlowStatus' AS PublishTopic, '/AutoPORPostPRFSolve' AS ActionURL, NULL AS ActionURLArgsJSON, 0 AS SendEmail, 'DarkCockpitWebAPIMain.FlowStrategy.MPS.Solve.AutoPRFSolvePOR' AS StrategyDefinitionClass, 0 AS AllowInitiateWhileWFInProgress
	UNION
	SELECT @WorkFlowId AS WorkFlowId, 'PartialAutoPOR' AS SubscriptionTopic, 'AutoUnConstraintException' AS PublishTopic, '/AutoPORPostPRFSolve' AS ActionURL, NULL AS ActionURLArgsJSON, 0 AS SendEmail, 'DarkCockpitWebAPIMain.FlowStrategy.MPS.Solve.AutoPRFSolvePOR' AS StrategyDefinitionClass, 0 AS AllowInitiateWhileWFInProgress
) T
LEFT JOIN dbo.RefFlowStrategyDefinition R
	ON R.WorkFlowId = T.WorkFlowId
	AND R.SubscriptionTopic = T.SubscriptionTopic
	WHERE R.SubscriptionTopic IS NULL



UPDATE dbo.RefFlowStrategyDefinition SET PublishTopic = 'FullAutoPOR' WHERE WorkFlowId = @WorkFlowId AND SubscriptionTopic ='CompletedAutoSolveRuleProcessing'
UPDATE dbo.RefFlowStrategyDefinition SET PublishTopic = 'PartialAutoPOR' WHERE WorkFlowId = @WorkFlowId AND SubscriptionTopic ='PartialAutoSolveRuleProcessing'