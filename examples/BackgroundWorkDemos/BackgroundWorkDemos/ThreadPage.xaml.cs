using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

using Xamarin.Forms;
using Xamarin.Forms.Xaml;

namespace BackgroundWorkDemos
{
    [XamlCompilation(XamlCompilationOptions.Compile)]
    public partial class ThreadPage : ContentPage
    {
        public ThreadPage()
        {
            InitializeComponent();
        }

        private void StartThread_Clicked(object sender, EventArgs e)
        {
            int upto = Convert.ToInt32(entUpto.Text);
            Task.Run(() =>
            {
                for (int i = 0; i < upto; ++i)
                {
                    Device.BeginInvokeOnMainThread(() =>
                    {
                       lblCount.Text = i.ToString();
                    });

                    Thread.Sleep(1000);
                }
            });
        }

        private void StartNoThread_Clicked(object sender, EventArgs e)
        {
            Task.Run(() =>
               {

                   int upto = Convert.ToInt32(entUpto.Text);
                   for (int i = 0; i < upto; ++i)
                   {
                       Dispatcher.BeginInvokeOnMainThread(() =>
                       {
                          lblCount.Text = i.ToString();
                       });
                       
                       Thread.Sleep(1000);
                   }
               });

        }
    }
}