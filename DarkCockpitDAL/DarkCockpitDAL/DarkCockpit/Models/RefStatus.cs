using System;
using System.Collections.Generic;

namespace DarkCockpitDAL.DarkCockpit.Models
{
    public partial class RefStatus
    {
        public int StatusId { get; set; }
        public string Status { get; set; }
        public string StatusCategory { get; set; }
        public DateTime CreatedOn { get; set; }
        public string CreatedBy { get; set; }
    }
}
