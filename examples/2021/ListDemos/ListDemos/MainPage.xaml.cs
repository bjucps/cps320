using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Xamarin.Forms;

namespace ListDemos
{
    public partial class MainPage : ContentPage
    {
        public MainPage()
        {
            InitializeComponent();
        }

        private void ListDemo1_Clicked(object sender, EventArgs e)
        {
            Navigation.PushAsync(new ListDemo1.ListDemo1Page());
        }

        private void ListDemo2_Clicked(object sender, EventArgs e)
        {
            Navigation.PushAsync(new ListDemo2.ListDemo2Page());
        }

        private void ListDemo3_Clicked(object sender, EventArgs e)
        {
            Navigation.PushAsync(new ListDemo3.ListDemo3Page());
        }
    }
}
