using System;
using System.Collections.Generic;

namespace DarkCockpitDAL.DarkCockpit.Models
{
    public partial class RefFlowStrategyTopicRoleEmail
    {
        public int WorkFlowId { get; set; }
        public string SubscriptionTopic { get; set; }
        public int RoleId { get; set; }
        public DateTime CreatedOn { get; set; }
        public string CreatedBy { get; set; }

        public ApplicationRole Role { get; set; }
    }
}
