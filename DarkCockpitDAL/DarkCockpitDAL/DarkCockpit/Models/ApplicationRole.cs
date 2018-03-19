using System;
using System.Collections.Generic;

namespace DarkCockpitDAL.DarkCockpit.Models
{
    public partial class ApplicationRole
    {
        public ApplicationRole()
        {
            ApplicationUserRole = new HashSet<ApplicationUserRole>();
            RefFlowStrategyTopicRoleEmail = new HashSet<RefFlowStrategyTopicRoleEmail>();
        }

        public int RoleId { get; set; }
        public string RoleName { get; set; }
        public string RoleDescription { get; set; }
        public string RootTopic { get; set; }

        public ICollection<ApplicationUserRole> ApplicationUserRole { get; set; }
        public ICollection<RefFlowStrategyTopicRoleEmail> RefFlowStrategyTopicRoleEmail { get; set; }
    }
}
