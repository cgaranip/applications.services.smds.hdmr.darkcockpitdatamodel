using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using DarkCockpitDAL.Core.Extensions;
using System.Data.Common;

namespace DarkCockpitDAL
{
    public class BaseRepository<TDbContext> : IRepository<TDbContext> where TDbContext : DbContext
    {
        private readonly TDbContext dbContext;
        protected readonly ILogger logger;

        protected BaseRepository(TDbContext dbContext)
        {
            this.dbContext = dbContext;
        }

        protected BaseRepository(TDbContext dbContext, ILoggerFactory loggerFactory)
        {
            this.dbContext = dbContext;
            logger = loggerFactory.CreateLogger(this.GetType().ToString().ToExtendStringName("Logger"));
        }

        public TDbContext GetDbContext()
        {
            return this.dbContext;
        }

        protected DbCommand DBStoreProcedureCommand(string storeProcedureName)
        {
            this.dbContext.Database.OpenConnection();
            DbCommand cmd = this.dbContext.Database.GetDbConnection().CreateCommand();
            cmd.CommandText = storeProcedureName;
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            cmd.CommandTimeout = 300;
            return cmd;
        }

        protected void CreateDbParameter(object parameterId, string ParameterName, DbCommand cmd)
        {
            var parameter = cmd.CreateParameter();
            parameter.ParameterName = ParameterName;
            parameter.Value = parameterId;
            cmd.Parameters.Add(parameter);
        }
    }
}
