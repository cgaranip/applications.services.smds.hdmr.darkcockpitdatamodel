using System;
using System.Collections.Generic;

namespace DarkCockpitDAL.DarkCockpit.Models
{
    public partial class ApplicationUserRole
    {
        public int ApplicationUserRoleId { get; set; }
        public int UserId { get; set; }
        public int RoleId { get; set; }

        public ApplicationRole Role { get; set; }
        public ApplicationUser User { get; set; }
    }
}
