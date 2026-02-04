using Parse;
using Parse.Infrastructure;
using System;
using System.Reflection;
using Xamarin.Forms;
using Xamarin.Forms.Xaml;

namespace ParseDemo
{
    public partial class App : Application
    {
        public App()
        {
            InitializeComponent();

            ConfigureParse();

            MainPage = new MainPage();
        }

        protected void ConfigureParse()
        {
            // Configure Parse Client
            ParseClient client = new ParseClient(new ServerConnectionData
            {
                ApplicationID = "AySQNEjH0JdPRCuspmZ3Pu849KNadghpwvFhjJCq",
                Key = "kmR7fTryeMwXVHqZgJQdErVoI0oMVxQyBeLgOOfz",
                ServerURI = "https://parseapi.back4app.com/"
            },
            new LateInitializedMutableServiceHub(),
            new MetadataMutator
            {
                EnvironmentData = new EnvironmentData { OSVersion = Environment.OSVersion.ToString(), Platform = Device.RuntimePlatform, TimeZone = TimeZoneInfo.Local.StandardName },
                HostManifestData = new HostManifestData
                {
                    Version = "1.0",
                    Name = this.GetType().Assembly.GetName().Name,
                    ShortVersion = "1.0",
                    Identifier = AppDomain.CurrentDomain.FriendlyName
                }
            }
            );
            client.AddValidClass<Student>();
            client.Publicize();
        }

        protected override void OnStart()
        {
            

        }

        protected override void OnSleep()
        {
        }

        protected override void OnResume()
        {
        }
    }
}
