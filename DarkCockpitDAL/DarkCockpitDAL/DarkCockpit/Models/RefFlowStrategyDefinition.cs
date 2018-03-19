using System;
using System.Collections.Generic;

namespace DarkCockpitDAL.DarkCockpit.Models
{
    public partial class RefFlowStrategyDefinition
    {
        public int FlowStrategyId { get; set; }
        public string RootTopic { get; set; }
        public string SubscriptionTopic { get; set; }
        public string PublishTopic { get; set; }
        public string ActionUrl { get; set; }
        public string ActionUrlargsJson { get; set; }
        public bool SendEmail { get; set; }
        public string StrategyDefinitionClass { get; set; }
        public DateTime CreatedOn { get; set; }
        public string CreatedBy { get; set; }
    }
}
