using DarkCockpitDAL.DarkCockpit.DTO;
using System.Collections.Generic;
using static DarkCockpitDAL.DarkCockpit.Repository.DarkCockpitRepository;

namespace DarkCockpitDAL.DarkCockpit.Repository
{
    public interface IDarkCockpitRepository
    {
        IEnumerable<ApplicationUserDTO> GetApplicationUser();
       
        bool CheckAuthorizeUserByRole(string userName, string roleDisplayName, string rootTopicName);
       
        bool CheckAuthorizeUser(string userName, string rootTopicName);

        IEnumerable<string> GetAllTopicList(int workFlowId, string rootTopicName, string topicType);

        IEnumerable<FlowStrategyDefinitionDTO> GetFlowStrategyDefinition(string rootTopicName);

        IEnumerable<WorkFlowDefinitionDTO> GetWorkFlowDefinition(string rootTopic);

        void SaveMqttTrackerLog(string ClientId, string rootTopic, int workFlowId, int runId, string clientType, string topic, string message, string createdBy);

         string FetchEmailList(string topic, string rootTopicName);

        int UspUpdateWorkFlowStatus(int workFlowId, string rootTopic, string topic, int runId, int statusId, string createdBy);

        string UspFetchMqttTrackerLog(string rootTopic, int workFlowId);

        void UspUpdateWorkFlowDetails(int workFlowId, int runId, int versionId, int snapshotId, string modifiedBy);
    }
}

