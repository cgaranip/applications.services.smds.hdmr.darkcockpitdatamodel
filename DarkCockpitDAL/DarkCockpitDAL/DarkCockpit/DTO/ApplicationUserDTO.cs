using System;
using System.Collections.Generic;
using System.Text;

namespace DarkCockpitDAL.DarkCockpit.DTO
{
    public class ApplicationUserDTO
    {
        public int UserId { get; set; }
        public string LoginId { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string FullName { get; set; }
        public int Wwid { get; set; }
        public string Email { get; set; }
        public int? StatusId { get; set; }
        public DateTime LastLoginDate { get; set; }
        public DateTime CreationDate { get; set; }
    }
}
