 update [DarkCockpit].[dbo].[RefFlowStrategyDefinition]
 set ActionUrl= '/ResetAutoJobStatus?jobId=2',
 StrategyDefinitionClass = 'DarkCockpitWebAPIMain.FlowStrategy.MPS.IDP.IDPDataLoadStagingException'
 where SubscriptionTopic = 'IDPDataLoadStagingException'