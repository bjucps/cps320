using System;
using System.ComponentModel;
using Xamarin.Forms;
using Xamarin.Forms.Xaml;

namespace ShellDemo.Views
{
    public partial class AboutPage : ContentPage
    {
        public AboutPage()
        {
            InitializeComponent();
        }

        private void BrowseItems_Clicked(object sender, EventArgs e)
        {
            Shell.Current.GoToAsync($"//{nameof(ItemsPage)}");
        }
    }
}