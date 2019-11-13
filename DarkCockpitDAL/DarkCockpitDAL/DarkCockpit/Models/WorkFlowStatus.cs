using System;
using System.Collections.Generic;

namespace DarkCockpitDAL.DarkCockpit.Models
{
    public partial class WorkFlowStatus
    {
        public long RunId { get; set; }
        public int WorkFlowId { get; set; }
        public int StatusId { get; set; }
        public int? VersionId { get; set; }
        public int? SnapshotId { get; set; }
        public DateTime CreatedOn { get; set; }
        public DateTime ModifiedOn { get; set; }
        public string CreatedBy { get; set; }
        public string ModifiedBy { get; set; }
        public string PayLoadJson { get; set; }
    }
}
