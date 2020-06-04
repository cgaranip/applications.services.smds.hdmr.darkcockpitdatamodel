INSERT INTO [DarkCockpit].[dbo].[RefFlowStrategyDefinition](WorkFlowId, SubscriptionTopic, PublishTopic, ActionURL, ActionURLArgsJSON, SendEmail)
SELECT 8, 'RunHDMR', 'None', NULL, NULL, 0
UNION ALL
SELECT 8, 'CompletedRunHDMR', 'None', NULL, NULL, 0
UNION ALL
SELECT 8, 'ExceptionRunHDMR', 'None', NULL, NULL, 0
