UPDATE DarkCockpit.dbo.RefFlowStrategyDefinition SET SendEmail = 1 WHERE  SubscriptionTopic = 'AutoConstraintException'
GO
INSERT INTO DarkCockpit.dbo.RefFlowStrategyTopicRoleEmail(WorkFlowId, SubscriptionTopic, RoleID, CreatedOn, CreatedBy)
SELECT EC.WorkFlowId, EC.SubscriptionTopic, 1 roleid, GETUTCDATE(), Ec.CreatedBy 
FROM DarkCockpit.dbo.RefFlowStrategyDefinition EC
LEFT JOIN DarkCockpit.dbo.RefFlowStrategyTopicRoleEmail RC
	ON EC.WorkFlowId = RC.WorkFlowId
	AND EC.SubscriptionTopic = RC.SubscriptionTopic
	AND RC.RoleID = 1
WHERE EC.SubscriptionTopic = 'AutoConstraintException'
AND RC.WorkFlowId IS NULL
GO
