using System;
using System.Collections.Generic;
using System.Text;

namespace DarkCockpitDAL.Core.Utility
{
    public struct ColumnName
    {
        public static readonly string ItemName = "ItemName";
        public static readonly string ItemId = "ItemId";
        public static readonly string ItemGroupId = "ItemGroupId";

        public static readonly string LocationName = "LocationName";
        public static readonly string LocationId = "LocationId";

        public static readonly string ParameterType = "ParameterType";
        public static readonly string ParameterTypeId = "ParameterTypeId";
        public static readonly string ParameterValue = "ParameterValue";

        public static readonly string Quantity = "Quantity";
        public static readonly string BucketId = "BucketId";

        public static readonly string DataType = "DataType";
        public static readonly string QuantityType = "QuantityType";
        public static readonly string DisplayType = "DisplayType";

        public static readonly string WwId = "WwId";
        public static readonly string WwDisplayName = "WwDisplayName";
        public static readonly string YearWwNameMonthName = "YearWwNameMonthName";

        public static readonly string PlaceHolderName = "PlaceHolderName";
        public static readonly string PlaceHolderId = "PlaceHolderId";

        public static readonly string VersionId = "VersionId";
        public static readonly string UpdateAction = "UpdateAction";

        public static readonly string SortOrder = "SortOrder";
    }

    public struct SupplyDemandColumnName
    {
        public static readonly string TotalBoh = "TotalBoh";
        public static readonly string UserSelectedBoh = "UserSelectedBoh";
        public static readonly string CWBoh = "CWBoh";
        public static readonly string FGSupplyRequest = "FGSupplyRequest";
        public static readonly string TargetBuild = "TargetBuild";
        public static readonly string MinBuild = "MinBuild";
        public static readonly string CWRequirements = "CWRequirements";
        public static readonly string JudgedDemand = "JudgedDemand";
        public static readonly string TacticalForecast = "TacticalForecast";
        public static readonly string ConsolidatedDemand = "ConsolidatedDemand";
        public static readonly string FinalSolverDemand = "FinalSolverDemand";
        public static readonly string EOHToTacticalForecast = "EOHToTacticalForecast";
        public static readonly string EOHToCWRequirements = "EOHToCWRequirements";
        public static readonly string EOHToConsolidatedDemand = "EOHToConsolidatedDemand";
        public static readonly string EOHToJudgedDemand = "EOHToJudgedDemand";
        public static readonly string EOHToFinalSolverDemand = "EOHToFinalSolverDemand";
        public static readonly string WOITacticalForecast = "WOITacticalForecast";
        public static readonly string WOICWRequirements = "WOICWRequirements";
        public static readonly string WOIConsolidatedDemand = "WOIConsolidatedDemand";
        public static readonly string WOIJudgedDemand = "WOIJudgedDemand";
        public static readonly string WOIFinalSolverDemand = "WOIFinalSolverDemand";
        public static readonly string TargetWOI = "TargetWOI";
        public static readonly string MinWOI = "MinWOI";
        public static readonly string MaxWOI = "MaxWOI";
        public static readonly string CWRequirementsOneWOI = "CWRequirementsOneWOI";
        public static readonly string JudgedDemandOneWOI = "JudgedDemandOneWOI";
        public static readonly string TacticalForecastOneWOI = "TacticalForecastOneWOI";
        public static readonly string ConsolidatedDemandOneWOI = "ConsolidatedDemandOneWOI";
        public static readonly string FinalSolverDemandOneWOI = "FinalSolverDemandOneWOI";
        public static readonly string Mrb = "MRB Bonus Back";

    }

}
