using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using DarkCockpitDAL.Core.Utility;
using DarkCockpitDAL.DarkCockpit.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
using System.Linq;
using DarkCockpitDAL.DarkCockpit.DTO;


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


        public bool CheckAuthorizeUserByRole(string userName, string roleDisplayName, string rootTopic)
        {
            lock (lockObject)
            {
                try
                {
                    var cmd = DBStoreProcedureCommand(StoreProcedureName.UspFetchAuthorizeUserList);
                    CreateDbParameter(userName, "@UserName", cmd);
                    CreateDbParameter(rootTopic, "@RootTopic", cmd);
                    CreateDbParameter(roleDisplayName, "@RoleDisplayName", cmd);

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



        public bool CheckAuthorizeUser(string userName, string rootTopic)
        {
            lock (lockObject)
            {
                try
                {
                    var cmd = DBStoreProcedureCommand(StoreProcedureName.UspFetchAuthorizeUserList);
                    CreateDbParameter(userName, "@UserName", cmd);
                    CreateDbParameter(rootTopic, "@RootTopic", cmd);

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

        public int UspUpdateWorkFlowStatus(int workFlowId, string rootTopic, string topic, int runId, int statusId, string createdBy)
        {
            int returnRunId = 0;
            try
            {              
                var cmd = DBStoreProcedureCommand(StoreProcedureName.UspUpdateWorkFlowStatus);
                CreateDbParameter(workFlowId, "@WorkFlowId", cmd);
                CreateDbParameter(rootTopic, "@RootTopic", cmd);
                CreateDbParameter(topic, "@Topic", cmd);
                CreateDbParameter(runId, "@RunId", cmd);
                CreateDbParameter(statusId, "@StatusId", cmd);
                CreateDbParameter(createdBy, "@CreatedBy", cmd);

                var resultDataTable = GetExecuteReaderResults(cmd);

                returnRunId = int.Parse(resultDataTable.Rows[0].ItemArray[0].ToString());

            }
            catch (Exception ex)
            {
                logger.LogError("Exception on UspUpdateWorkFlowStatus: " + ex.Message + "." + ex.InnerException);
            }
            finally
            {
                base.GetDbContext().Database.CloseConnection();
            }

            return returnRunId;
        }

        public DataTable UspFetchWorkFlowDetails (int workFlowId, int runId)
        {
            var resultDataTable = new DataTable();
            try
            {
                var cmd = DBStoreProcedureCommand(StoreProcedureName.UspFetchWorkFlowDetails);
                CreateDbParameter(workFlowId, "@WorkFlowId", cmd);
                CreateDbParameter(runId, "@RunId", cmd);             

                resultDataTable = GetExecuteReaderResults(cmd);             

            }
            catch (Exception ex)
            {
                logger.LogError("Exception on UspFetchWorkFlowDetails: " + ex.Message + "." + ex.InnerException);
            }
            finally
            {
                base.GetDbContext().Database.CloseConnection();
            }

            return resultDataTable;
        }


        public DataTable UspFetchLatestIDPFlowRunId ()
        {
            var resultDataTable = new DataTable();
            try
            {
                var cmd = DBStoreProcedureCommand(StoreProcedureName.UspFetchLatestIDPFlowRunId);
                resultDataTable = GetExecuteReaderResults(cmd);

            }
            catch (Exception ex)
            {
                logger.LogError("Exception on UspFetchLatestIDPFlowRunId: " + ex.Message + "." + ex.InnerException);
            }
            finally
            {
                base.GetDbContext().Database.CloseConnection();
            }

            return resultDataTable;
        }


        public void UspUpdateWorkFlowDetails (int workFlowId, int runId, int versionId, int snapshotId, string payLoadJSON, string modifiedBy)
        {
            try
            {
                var cmd = DBStoreProcedureCommand(StoreProcedureName.UspUpdateWorkFlowDetails);
                CreateDbParameter(workFlowId, "@WorkFlowId", cmd);         
                CreateDbParameter(runId, "@RunId", cmd);
                CreateDbParameter(versionId, "@VersionId", cmd);
                CreateDbParameter(snapshotId, "@SnapshotId", cmd);
                CreateDbParameter(payLoadJSON, "@PayLoadJSON", cmd);
                CreateDbParameter(modifiedBy, "@ModifiedBy", cmd);

                cmd.ExecuteNonQuery();

            }
            catch (Exception ex)
            {
                logger.LogError("Exception on UspUpdateWorkFlowDetails: " + ex.Message + "." + ex.InnerException);
            }
            finally
            {
                base.GetDbContext().Database.CloseConnection();
            }
          
        }


        public string FetchEmailList(string topic, string rootTopic)
        {

            string sendToEmailList = String.Empty;

            try
            {
                var splitTopic = topic.Split('/');
                var workFlowId = splitTopic[0];  // extract the workflowid from topic which has workflowid-runid-topicname
                var runId = splitTopic[1];  // extract the runId from topic
                var topicName = splitTopic[2];  // extract the topic name from topic which has workflowid-runid-topicname

                var cmd = DBStoreProcedureCommand(StoreProcedureName.UspFetchEmailList);
                CreateDbParameter(workFlowId, "@WorkFlowId", cmd);
                CreateDbParameter(topicName, "@Topic", cmd);
                CreateDbParameter(rootTopic, "@RootTopic", cmd);

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

        public string UspFetchMqttTrackerLog(string rootTopic, int workFlowId)
        {
            string consolidatedMessage = String.Empty;
            try
            {
                var cmd = DBStoreProcedureCommand(StoreProcedureName.UspFetchMqttTrackerLog);
                CreateDbParameter(workFlowId, "@WorkFlowId", cmd);
                CreateDbParameter(rootTopic, "@RootTopic", cmd);

                var resultDataTable = GetExecuteReaderResults(cmd);

                foreach (DataRow row in resultDataTable.Rows)
                {
                    if (string.IsNullOrEmpty(consolidatedMessage))
                    {
                        consolidatedMessage = row["CreatedOn"] + "-Topic:" + row["Topic"];
                    }
                    else
                    {
                        consolidatedMessage = consolidatedMessage + "#" + row["CreatedOn"] + "-Topic:" + row["Topic"];
                    }

                }
            }
            catch (Exception ex)
            {
                logger.LogError("Exception on UspFetchMqttTrackerLog: " + ex.Message + "." + ex.InnerException);
            }
            finally
            {
                base.GetDbContext().Database.CloseConnection();
            }

            return consolidatedMessage;
        }

        public class WorkFlowDefinitionDTO
        {
            public int WorkFlowId { get; set; }
            public string WorkFlowName { get; set; }
        }

        public IEnumerable<WorkFlowDefinitionDTO> GetWorkFlowDefinition(string rootTopic)
        {
            var workFlowDefinitionList = new List<WorkFlowDefinitionDTO>();

            IQueryable<RefWorkFlowDefinition> refWorkFlowDefinition = base.GetDbContext().RefWorkFlowDefinition.Where(p => p.RootTopic == rootTopic && p.IsActive == true);


            var workFlowDefinitions = from t0 in refWorkFlowDefinition                               
                                     select new WorkFlowDefinitionDTO()
                                     {
                                         WorkFlowId = t0.WorkflowId,
                                         WorkFlowName = t0.WorkflowName                                     
                                     };

            foreach (var workFlowDefinition in workFlowDefinitions)
            {
                workFlowDefinitionList.Add(workFlowDefinition);
            }

            return workFlowDefinitionList;
        }


        public class FlowStrategyDefinitionDTO
        {
            public int WorkFlowId { get; set; }
            public string WorkFlowName { get; set; }
            public string SubscriptionTopic { get; set; }
            public string PublishTopic { get; set; }
            public string ServiceURL { get; set; }
            public string ServiceUrlargsJson { get; set; }
            public bool SendEmail { get; set; }
            public string StrategyDefinitionClass { get; set; }
        }



        public IEnumerable<FlowStrategyDefinitionDTO> GetFlowStrategyDefinition(string rootTopic)
        {
            var flowStrategyList = new List<FlowStrategyDefinitionDTO>();

            IQueryable<RefFlowStrategyDefinition> refFlowStrategyDefinition = base.GetDbContext().RefFlowStrategyDefinition;
            IQueryable<RefWorkFlowDefinition> refWorkFlowDefinition = base.GetDbContext().RefWorkFlowDefinition.Where(p => p.RootTopic == rootTopic && p.IsActive == true);


            var flowStrategyStages = from t0 in refFlowStrategyDefinition
                                     join t1 in refWorkFlowDefinition on t0.WorkFlowId equals t1.WorkflowId
                                     select new FlowStrategyDefinitionDTO()
                                     {
                                         WorkFlowId = t1.WorkflowId,
                                         WorkFlowName = t1.WorkflowName,
                                         SubscriptionTopic = t1.WorkflowId + "/+/" + t0.SubscriptionTopic,
                                         PublishTopic = t1.WorkflowId + "/+/" + t0.PublishTopic,
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


        public IEnumerable<string> GetAllTopicList(int workFlowId, string rootTopic, string topicType)
        {
            var topicList = new List<string>();
            IQueryable<RefFlowStrategyDefinition> refFlowStrategyDefinition = base.GetDbContext().RefFlowStrategyDefinition;
            IQueryable<RefWorkFlowDefinition> refWorkFlowDefinition = base.GetDbContext().RefWorkFlowDefinition.Where(p => p.RootTopic == rootTopic && p.IsActive == true);


            try
            {
                if (workFlowId == -1)
                {

                    refFlowStrategyDefinition = from t0 in refFlowStrategyDefinition
                    join t1 in refWorkFlowDefinition on t0.WorkFlowId equals t1.WorkflowId
                    select t0;

                }
                else
                {

                    refFlowStrategyDefinition = from t0 in refFlowStrategyDefinition
                                                where t0.WorkFlowId.Equals(workFlowId)
                                                select t0;
                }
                var Topics = new List<string>();
                if (topicType == "Both")
                {
                    Topics = (from t1 in refFlowStrategyDefinition
                              select t1.SubscriptionTopic).Union
                                (from t1 in refFlowStrategyDefinition
                                 select t1.WorkFlowId + "/+/" + t1.PublishTopic).ToList();
                }
                else if (topicType == "Publish")
                {
                    Topics = (from t1 in refFlowStrategyDefinition
                              select t1.WorkFlowId + "/+/" + t1.PublishTopic).ToList();
                }
                else
                {
                    Topics = (from t1 in refFlowStrategyDefinition
                              select t1.WorkFlowId + "/+/" + t1.SubscriptionTopic).ToList();
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


        public void SaveMqttTrackerLog(string ClientId, string rootTopic, int workFlowId, int runId, string clientType, string topic, string message, string createdBy)
        {
            try
            {
                var cmd = DBStoreProcedureCommand(StoreProcedureName.UspSaveMqttTrackerLog);
                CreateDbParameter(ClientId, "@ClientId", cmd);
                CreateDbParameter(rootTopic, "@RootTopic", cmd);
                CreateDbParameter(workFlowId, "WorkFlowId", cmd);
                CreateDbParameter(runId, "@RunId", cmd);
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
