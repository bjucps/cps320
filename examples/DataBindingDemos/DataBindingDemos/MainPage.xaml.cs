using DataBindingDemos.ModelViewDemo1;
using DataBindingDemos.ModelViewDemo2;
using DataBindingDemos.MVVMDemo;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Xamarin.Forms;

namespace DataBindingDemos
{
    public partial class MainPage : ContentPage
    {
        public MainPage()
        {
            InitializeComponent();
        }

        private void ModelViewDemo_Clicked(object sender, EventArgs e)
        {
            var page = new ModelViewDemo1Page();
            Navigation.PushAsync(page);
        }

        private void ModelViewDemo2_Clicked(object sender, EventArgs e)
        {
            var page = new ModelViewDemo2Page();
            Navigation.PushAsync(page);
        }

        private void ModelViewViewModelDemo_Clicked(object sender, EventArgs e)
        {
            var page = new MVVMDemoPage();
            Navigation.PushAsync(page);
        }
    }
}
