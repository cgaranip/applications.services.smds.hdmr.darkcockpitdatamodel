using System;
using System.Collections.Generic;

namespace DarkCockpitDAL.DarkCockpit.Models
{
    public partial class ApplicationUser
    {
        public ApplicationUser()
        {
            ApplicationUserRole = new HashSet<ApplicationUserRole>();
        }

        public int UserId { get; set; }
        public string LoginId { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string FullName { get; set; }
        public int Wwid { get; set; }
        public string Email { get; set; }
        public int StatusId { get; set; }
        public DateTime LastLoginDate { get; set; }
        public DateTime CreationDate { get; set; }

        public ApplicationStatusType Status { get; set; }
        public ICollection<ApplicationUserRole> ApplicationUserRole { get; set; }
    }
}
