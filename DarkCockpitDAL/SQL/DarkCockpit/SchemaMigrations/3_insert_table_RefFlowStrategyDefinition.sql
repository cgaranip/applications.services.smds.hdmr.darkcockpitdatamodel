INSERT INTO [DarkCockpit].[dbo].[RefFlowStrategyDefinition](WorkFlowId, SubscriptionTopic, PublishTopic, ActionURL, ActionURLArgsJSON, SendEmail)
SELECT T.WorkFlowId, T.SubscriptionTopic, T.PublishTopic, T.ActionURL, T.ActionURLArgsJSON, T.SendEmail
FROM
(
SELECT 8 AS WorkFlowId, 'RunHDMR' AS SubscriptionTopic, 'None' AS PublishTopic, NULL AS ActionURL, NULL AS ActionURLArgsJSON, 0 AS SendEmail
UNION 
SELECT 8, 'CompletedRunHDMR', 'None', NULL, NULL, 0
UNION 
SELECT 8, 'ExceptionRunHDMR', 'None', NULL, NULL, 0
) T
LEFT JOIN [DarkCockpit].[dbo].[RefFlowStrategyDefinition] R
	ON R.WorkFlowId = T.WorkFlowId
	AND R.SubscriptionTopic = T.SubscriptionTopic
	WHERE R.SubscriptionTopic IS NULL