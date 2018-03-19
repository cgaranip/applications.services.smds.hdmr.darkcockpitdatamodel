using System;
using System.Collections.Generic;
using System.Text;

namespace DarkCockpitDAL.Core.Utility
{
    public struct StoreProcedureName
    {
        public static readonly string UspUiFetchFgStrategy = "UspUiFetchFgStrategySC2027";
        public static readonly string UspUiSaveFgStrategy = "UspUiSaveFgStrategy2";
        public static readonly string UspFetchBuckets = "UspFetchBuckets";

        public static readonly string UspUiFetchSupplyVsDemand = "UspUiFetchSupplyVsDemand";

        public static readonly string UspUiFetchGenericGroupingAssignedUnAssigned = "UspUiFetchGenericGroupingAssignedUnAssigned";
        public static readonly string UspUiSaveGenericGrouping = "UspUiSaveGenericGrouping";


        #region Solver Stored Procedures
        public static readonly string UspSolverCheckAndFetchPendingSolveRequest = "UspSolverCheckAndFetchPendingSolveRequest";
        public static readonly string UspInsertSolveRequest = "UspInsertSolveRequest";
        public static readonly string UspSaveActivityLog = "UspSaveActivityLog";
        #endregion

        #region Security Stored Procedures
        public static readonly string UspFetchEmailList = "UspFetchEmailList";
        public static readonly string UspFetchAuthorizeUserList = "UspFetchAuthorizeUserList";
        public static readonly string UspSaveMqttTrackerLog = "UspSaveMqttTrackerLog";
        #endregion
    }
}
