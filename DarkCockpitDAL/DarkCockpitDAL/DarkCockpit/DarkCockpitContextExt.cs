using DarkCockpitDAL.DarkCockpit.Models;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Infrastructure;
using System;


namespace DarkCockpitDAL.Security.Models
{
    public class DarkCockpitContextExt : DarkCockpitContext
    {
        private readonly string connString = String.Empty;
        private const string SqlServerOptionsExtensionName = "SqlServerOptionsExtension";

        public DarkCockpitContextExt(DbContextOptions<DarkCockpitContextExt> options)
        {
            foreach (IDbContextOptionsExtension dbContextOptions in options.Extensions)
            {
                if (dbContextOptions.GetType().Name == SqlServerOptionsExtensionName)
                {
                    var sqlServerOptionsExtension = dbContextOptions as Microsoft.EntityFrameworkCore.Infrastructure.Internal.SqlServerOptionsExtension;

                    if (sqlServerOptionsExtension == null)
                        return;

                    connString = sqlServerOptionsExtension.ConnectionString;
                }
            }
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
