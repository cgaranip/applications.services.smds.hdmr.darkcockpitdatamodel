UPDATE DarkCockpit.dbo.RefFlowStrategyDefinition SET SendEmail = 1 WHERE workflowid=8 and SubscriptionTopic = 'AutoUnConstraintException'
GO
INSERT INTO DarkCockpit.dbo.RefFlowStrategyTopicRoleEmail(WorkFlowId, SubscriptionTopic, RoleID, CreatedOn, CreatedBy)
SELECT EC.WorkFlowId, EC.SubscriptionTopic, 1 roleid, GETUTCDATE(), Ec.CreatedBy 
FROM DarkCockpit.dbo.RefFlowStrategyDefinition EC
LEFT JOIN DarkCockpit.dbo.RefFlowStrategyTopicRoleEmail RC
	ON EC.WorkFlowId = RC.WorkFlowId
	AND EC.SubscriptionTopic = RC.SubscriptionTopic
	AND RC.RoleID = 1
WHERE EC.SubscriptionTopic = 'AutoUnConstraintException'
AND RC.WorkFlowId IS NULL
and ec.workflowid=8 
GO
