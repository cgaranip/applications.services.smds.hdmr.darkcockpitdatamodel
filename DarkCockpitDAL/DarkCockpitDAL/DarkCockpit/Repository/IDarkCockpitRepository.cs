using DarkCockpitDAL.DarkCockpit.DTO;
using System.Collections.Generic;
using static DarkCockpitDAL.DarkCockpit.Repository.DarkCockpitRepository;

namespace DarkCockpitDAL.DarkCockpit.Repository
{
    public interface IDarkCockpitRepository
    {
        IEnumerable<ApplicationUserDTO> GetApplicationUser();
       
        bool CheckAuthorizeUserByRole(string userName, string roleName, string rootTopicName);
       
        bool CheckAuthorizeUser(string userName, string rootTopicName);

        IEnumerable<string> GetAllTopicList(int workFlowId, string rootTopicName, string topicType);

        IEnumerable<FlowStrategyDefinitionDTO> GetFlowStrategyDefinition(string rootTopicName);

        IEnumerable<WorkFlowDefinitionDTO> GetWorkFlowDefinition(string rootTopic);

        void SaveMqttTrackerLog(string ClientId, string rootTopicName, string clientType, string topic, string message, string createdBy);

        string FetchEmailList(string topic, string rootTopicName);
    }
}

