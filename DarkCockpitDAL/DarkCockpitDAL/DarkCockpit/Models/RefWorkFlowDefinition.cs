using System;
using System.Collections.Generic;

namespace DarkCockpitDAL.DarkCockpit.Models
{
    public partial class RefWorkFlowDefinition
    {
        public int WorkflowId { get; set; }
        public string RootTopic { get; set; }
        public string WorkflowName { get; set; }
        public bool? IsActive { get; set; }
    }
}
