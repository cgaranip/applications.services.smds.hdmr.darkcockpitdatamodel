using System;
using System.Collections.Generic;
using System.Text;

namespace DarkCockpitDAL.Core.Utility
{
    public struct StoreProcedureName
    {
       
        #region DarkCockpit Stored Procedures
        public static readonly string UspFetchEmailList = "UspFetchEmailList";
        public static readonly string UspFetchAuthorizeUserList = "UspFetchAuthorizeUserList";
        public static readonly string UspSaveMqttTrackerLog = "UspSaveMqttTrackerLog";
        public static readonly string UspUpdateWorkFlowStatus = "UspUpdateWorkFlowStatus";
        public static readonly string UspFetchWorkFlowDetails = "UspFetchWorkFlowDetails";
        public static readonly string UspUpdateWorkFlowDetails = "UspUpdateWorkFlowDetails";
        public static readonly string UspFetchMqttTrackerLog = "UspFetchMqttTrackerLog";
        #endregion
    }
}
