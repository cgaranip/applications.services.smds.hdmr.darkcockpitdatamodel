using System;
using System.Collections.Generic;

namespace DarkCockpitDAL.DarkCockpit.Models
{
    public partial class WorkflowScheduleDefiniton
    {
        public int WorkflowId { get; set; }
        public string CronSchedule { get; set; }
        public string PublishTopic { get; set; }
        public bool? Active { get; set; }
        public string MessagePayload { get; set; }
    }
}
