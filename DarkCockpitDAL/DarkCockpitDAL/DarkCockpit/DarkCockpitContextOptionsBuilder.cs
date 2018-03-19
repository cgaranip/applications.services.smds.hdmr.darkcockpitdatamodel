using DarkCockpitDAL.DarkCockpit.Models;
using Microsoft.EntityFrameworkCore;

namespace DarkCockpitDAL.Security.Models
{
    public class DarkCockpitContextOptionsBuilder : DarkCockpitContext
    {
        private readonly string connString = string.Empty;
        public DarkCockpitContextOptionsBuilder(string connString)
        {
            this.connString = connString;
        }

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            if (!optionsBuilder.IsConfigured)
            {
                optionsBuilder.UseSqlServer(this.connString);
            }
        }
    }
}
