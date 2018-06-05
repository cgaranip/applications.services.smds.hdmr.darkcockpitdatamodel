using DarkCockpitDAL.DarkCockpit.Repository;
using DarkCockpitDAL.DarkCockpit.Models;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using static DarkCockpitDAL.DarkCockpit.Repository.DarkCockpitRepository;

namespace DarkCockpitDAL.NetFramework.ConsoleApp
{
    class Program
    {
        private static string connString_DarkCockpitContext = @"Data Source=azsctsbuildserv.amr.corp.intel.com;Database=DarkCockpit;Trusted_Connection=True;";
        public static IServiceProvider Container { get; private set; }

        static void Main(string[] args)
        {
            Console.WriteLine("---------------------------------------------");
            Console.WriteLine("-----------Console DotNet Core!!!------------");
            Console.WriteLine("---------------------------------------------\n");

            Console.WriteLine("Register member contract into container.");
            IServiceCollection services = new ServiceCollection();
            services.AddSingleton<ILoggerFactory, LoggerFactory>();
            services.AddDbContext<DarkCockpitContextExt>(options => options.UseSqlServer(connString_DarkCockpitContext), ServiceLifetime.Scoped);
            services.AddScoped<IDarkCockpitRepository, DarkCockpitRepository>();
            Container = services.BuildServiceProvider();

            Console.WriteLine("Getting data from IDarkCockpitRepository...");
            var darkCockpitRepo = Container.GetService<IDarkCockpitRepository>();
            var applicationUserDTOs = darkCockpitRepo.GetApplicationUser();
            Console.WriteLine($"Total count : {applicationUserDTOs.Count()}");
            Console.WriteLine("---------------------------------------------\n");

            foreach (var user in applicationUserDTOs)
            {
                Console.WriteLine(user.FullName);
            }

            Console.WriteLine("---------------------------------------------\n");


            var result = darkCockpitRepo.CheckAuthorizeUser("amr\\jnarayan", "MPS");
            Console.WriteLine($"IsAuthorized : {result}");
            Console.WriteLine("---------------------------------------------\n");

            result = darkCockpitRepo.CheckAuthorizeUserByRole("amr\\jnarayan", "SCTS_DEVELOPER", "MPS");
            Console.WriteLine($"IsAuthorized : {result}");
            Console.WriteLine("---------------------------------------------\n");


            string list = darkCockpitRepo.FetchEmailList("1-PublishFabPOR", "MPS");
            Console.WriteLine($"{list}");
            Console.WriteLine("---------------------------------------------\n");

            List<string> topicList = darkCockpitRepo.GetAllTopicList(-1, "MPS", "Publish").ToList();
            foreach (var topic in topicList)
            {
                Console.WriteLine(topic);
            }

            Console.WriteLine("---------------------------------------------\n");

            topicList = darkCockpitRepo.GetAllTopicList(1, "MPS", "Publish").ToList();
            foreach (var topic in topicList)
            {
                Console.WriteLine(topic);
            }

            Console.WriteLine("---------------------------------------------\n");


            List<FlowStrategyDefinitionDTO> flowList = darkCockpitRepo.GetFlowStrategyDefinition("MPS").ToList();
            foreach (var flow in flowList)
            {
                Console.WriteLine(flow.PublishTopic);
                Console.WriteLine(flow.ServiceURL);
            }

            Console.WriteLine("---------------------------------------------\n");

            List<WorkFlowDefinitionDTO> workflowList = darkCockpitRepo.GetWorkFlowDefinition("MPS").ToList();
            foreach (var flow in workflowList)
            {
                Console.WriteLine(flow.WorkFlowId);
                Console.WriteLine(flow.WorkFlowName);
            }

            Console.WriteLine("---------------------------------------------\n");


            darkCockpitRepo.SaveMqttTrackerLog("Test", "MPS", "Publish", "Test", "Test", "3-14-2018");


            Console.WriteLine("---------------------------------------------\n");

        }
    }
}
