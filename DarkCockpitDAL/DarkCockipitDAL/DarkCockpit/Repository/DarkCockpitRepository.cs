using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using DarkCockpitDAL.Core.Utility;
using DarkCockpitDAL.Security.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
using System.Linq;
using DarkCockpitDAL.DarkCockpit.DTO;
using DarkCockpitDAL.DarkCockpit.Models;

namespace DarkCockpitDAL.DarkCockpit.Repository
{
    public class DarkCockpitRepository : BaseRepository<DarkCockpitContextExt>, IDarkCockpitRepository
    {
        private Object lockObject= null;

        public DarkCockpitRepository(DarkCockpitContextExt dbContext) : base(dbContext)
        {
            lockObject = new object();
        }

        public DarkCockpitRepository(DarkCockpitContextExt dbContext, ILoggerFactory loggerFactory) : base(dbContext)
        {
            
            lockObject = new object();
        }

        public DataTable GetExecuteReaderResults(DbCommand cmd)
        {
            var listDt = new DataTable();
            using (var reader = cmd.ExecuteReader())
            {
                listDt.Load(reader);
            }

            return listDt;
        }


        public bool CheckAuthorizeUserByRole(string userName, string roleName, string rootTopicName)
        {
            lock (lockObject)
            {
                try
                {
                    var cmd = DBStoreProcedureCommand(StoreProcedureName.UspFetchAuthorizeUserList);
                    CreateDbParameter(userName, "@UserName", cmd);
                    CreateDbParameter(rootTopicName, "@RootTopic", cmd);
                    CreateDbParameter(roleName, "@Role", cmd);

                    var authorizeUser = GetExecuteReaderResults(cmd);

                    if (authorizeUser.Rows.Count > 0)
                        return true;

                }
                catch (Exception ex)
                {
                    logger.LogError("Exception on CheckAuthorizeUserByRole: " + ex.Message + "." + ex.InnerException);
                }
                finally
                {
                    base.GetDbContext().Database.CloseConnection();
                }

                return false;
            }
        }



        public bool CheckAuthorizeUser(string userName, string rootTopicName)
        {
            lock (lockObject)
            {
                try
                {
                    var cmd = DBStoreProcedureCommand(StoreProcedureName.UspFetchAuthorizeUserList);
                    CreateDbParameter(userName, "@UserName", cmd);
                    CreateDbParameter(rootTopicName, "@RootTopic", cmd);

                    var authorizeUser = GetExecuteReaderResults(cmd);

                    if (authorizeUser.Rows.Count > 0)
                        return true;

                }
                catch (Exception ex)
                {
                    logger.LogError("Exception on CheckAuthorizeUser: " + ex.Message + "." + ex.InnerException);
                }
                finally
                {
                    base.GetDbContext().Database.CloseConnection();
                }

                return false;
            }
        }





        public string FetchEmailList(string topic, string rootTopicName)
        {

            string sendToEmailList = String.Empty;

            try
            {
                var cmd = DBStoreProcedureCommand(StoreProcedureName.UspFetchEmailList);
                CreateDbParameter(topic, "@Topic", cmd);
                CreateDbParameter(rootTopicName, "@RootTopic", cmd);

                var resultDataTable = GetExecuteReaderResults(cmd);

                foreach (DataRow row in resultDataTable.Rows)
                {
                    sendToEmailList = sendToEmailList + row.ItemArray[0] + ",";
                }
            }
            catch (Exception ex)
            {
                logger.LogError("Exception on UspFetchEmailList: " + ex.Message + "." + ex.InnerException);
            }
            finally
            {
                base.GetDbContext().Database.CloseConnection();
            }

            return sendToEmailList;
        }

        public class FlowStrategyDefinitionDTO
        {
            public string SubscriptionTopic { get; set; }
            public string PublishTopic { get; set; }
            public string ServiceURL { get; set; }
            public string ServiceUrlargsJson { get; set; }
            public bool SendEmail { get; set; }
            public string StrategyDefinitionClass { get; set; }
        }



        public IEnumerable<FlowStrategyDefinitionDTO> GetFlowStrategyDefinition(string rootTopicName)
        {
            var flowStrategyList = new List<FlowStrategyDefinitionDTO>();

            IQueryable<RefFlowStrategyDefinition> refFlowStrategyDefinition = base.GetDbContext().RefFlowStrategyDefinition.Where(p => p.RootTopic == rootTopicName);

            var flowStrategyStages = from t0 in refFlowStrategyDefinition
                                     select new FlowStrategyDefinitionDTO()
                                     {
                                         SubscriptionTopic = t0.SubscriptionTopic,
                                         PublishTopic = t0.PublishTopic,
                                         ServiceURL = t0.ActionUrl,
                                         SendEmail = t0.SendEmail,
                                         ServiceUrlargsJson = t0.ActionUrlargsJson,
                                         StrategyDefinitionClass = t0.StrategyDefinitionClass
                                     };

            foreach (var flowStrategy in flowStrategyStages)
            {
                flowStrategyList.Add(flowStrategy);
            }

            return flowStrategyList;
        }


        public IEnumerable<string> GetAllTopicList(string rootTopicName, string topicType)
        {
            var topicList = new List<string>();

            try
            {
                IQueryable<RefFlowStrategyDefinition> refFlowStrategyDefinition = base.GetDbContext().RefFlowStrategyDefinition.Where(p => p.RootTopic == rootTopicName);
                var Topics = new List<string>();
                if (topicType == "Both")
                {
                    Topics = (from t1 in refFlowStrategyDefinition
                              select t1.SubscriptionTopic).Union
                                (from t1 in refFlowStrategyDefinition
                                 select t1.PublishTopic).ToList();
                }
                else if (topicType == "Publish")
                {
                    Topics = (from t1 in refFlowStrategyDefinition
                              select t1.PublishTopic).ToList();
                }
                else
                {
                    Topics = (from t1 in refFlowStrategyDefinition
                              select t1.SubscriptionTopic).ToList();
                }
                foreach (var topicName in Topics.Distinct())
                {
                    topicList.Add(topicName);
                }
            }
            catch (Exception ex)
            {
                logger.LogError("Exception on GetAllTopicList: " + ex.Message + "." + ex.InnerException);
            }
            finally
            {
                base.GetDbContext().Database.CloseConnection();
            }
            return topicList;
        }


        public void SaveMqttTrackerLog(string ClientId, string rootTopicName, string clientType, string topic, string message, string createdBy)
        {
            try
            {

                var cmd = DBStoreProcedureCommand(StoreProcedureName.UspSaveMqttTrackerLog);
                CreateDbParameter(ClientId, "@ClientId", cmd);
                CreateDbParameter(rootTopicName, "@RootTopic", cmd);
                CreateDbParameter(clientType, "@ClientType", cmd);
                CreateDbParameter(topic, "@Topic", cmd);
                CreateDbParameter(message, "@Message", cmd);
                CreateDbParameter(DateTime.UtcNow, "@CreatedOn", cmd);
                CreateDbParameter(createdBy, "@CreatedBy", cmd);

                cmd.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                logger.LogError("Exception on SaveMqttTrackerLog: " + ex.Message + "." + ex.InnerException);
            }
            finally
            {
                base.GetDbContext().Database.CloseConnection();
            }
        }

        public IEnumerable<ApplicationUserDTO> GetApplicationUser()
        {
            try
            {
                var list = new List<ApplicationUserDTO>();
                foreach (var user in GetDbContext().ApplicationUser)
                {
                    var applicationUserDTOs = new ApplicationUserDTO
                    {
                        UserId = user.UserId,
                        LoginId = user.LoginId,
                        FirstName = user.FirstName,
                        LastName = user.LastName,
                        FullName = user.FullName,
                        Wwid = user.Wwid,
                        Email = user.Email,
                        StatusId = user.StatusId,
                        LastLoginDate = user.LastLoginDate,
                        CreationDate = user.CreationDate
                    };

                    list.Add(applicationUserDTOs);
                }

                return list;
            }
            catch (Exception ex)
            {
                logger.LogError("Exception on GetApplicationUser: " + ex.Message + "." + ex.InnerException);
                return Enumerable.Empty<ApplicationUserDTO>();
            }
            finally
            {
                base.GetDbContext().Database.CloseConnection();
            }
        }
    }
}
