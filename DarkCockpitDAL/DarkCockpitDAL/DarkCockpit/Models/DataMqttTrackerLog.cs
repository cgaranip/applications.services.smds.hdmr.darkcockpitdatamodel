using System;
using System.Collections.Generic;

namespace DarkCockpitDAL.DarkCockpit.Models
{
    public partial class DataMqttTrackerLog
    {
        public int MqttTrackerId { get; set; }
        public string ClientId { get; set; }
        public string RootTopic { get; set; }
        public string ClientType { get; set; }
        public string Topic { get; set; }
        public string Message { get; set; }
        public DateTime? CreatedOn { get; set; }
        public string CreatedBy { get; set; }
    }
}
