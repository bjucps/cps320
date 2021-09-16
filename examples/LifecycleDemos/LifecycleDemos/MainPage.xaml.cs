using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Xamarin.Forms;

namespace LifecycleDemos
{
    public partial class MainPage : ContentPage, IAppStateAware
    {
        public MainPage()
        {
            InitializeComponent();
            NameEntry.Text = Application.Current.Properties["Username"] as string;
        }

        public void OnSleep()
        {
            Debug.WriteLine("Main Page knows it's sleeping...");
            Application.Current.Properties["Username"] = NameEntry.Text;
        }

        protected override void OnAppearing()
        {
            base.OnAppearing();
            Debug.WriteLine("Main Page is appearing...");
        }

        protected override void OnDisappearing()
        {
            base.OnDisappearing();
            Debug.WriteLine("Main Page is disappearing...");
        }

        int count = 0;
        bool stopRequested = false;

        private void StartCounting_Clicked(object sender, EventArgs e)
        {
            stopRequested = false;
            Device.StartTimer(TimeSpan.FromSeconds(1), () =>
            {
                Debug.WriteLine($"count = {count}...");
                CountLabel.Text = (++count).ToString();
                return !stopRequested;
            });
        }

        private void StopCounting_Clicked(object sender, EventArgs e)
        {
            stopRequested = true;
        }

        private void NextPage_Clicked(object sender, EventArgs e)
        {
            Navigation.PushAsync(new Page2());
        }
    }
}
