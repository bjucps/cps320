using System;
using System.Diagnostics;
using System.Linq;
using Xamarin.Forms;
using Xamarin.Forms.Xaml;

namespace LifecycleDemos
{
    public partial class App : Application
    {
        public App()
        {
            InitializeComponent();

            MainPage = new NavigationPage(new MainPage());
        }

        protected override void OnStart()
        {
            Debug.WriteLine("LifecycleDemos is starting...");
        }

        protected override void OnSleep()
        {
            Debug.WriteLine("LifecycleDemos is sleeping...");

            if (MainPage.Navigation.NavigationStack.Last() is IAppStateAware aware) {
                aware.OnSleep();
            }
        }

        protected override void OnResume()
        {
            Debug.WriteLine("LifecycleDemos is resuming...");
        }
    }
}
