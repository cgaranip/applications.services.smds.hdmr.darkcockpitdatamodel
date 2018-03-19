using System;
using System.Collections.Generic;

namespace DarkCockpitDAL.DarkCockpit.Models
{
    public partial class ApplicationStatusType
    {
        public ApplicationStatusType()
        {
            ApplicationUser = new HashSet<ApplicationUser>();
        }

        public int StatusId { get; set; }
        public string StatusName { get; set; }

        public ICollection<ApplicationUser> ApplicationUser { get; set; }
    }
}
