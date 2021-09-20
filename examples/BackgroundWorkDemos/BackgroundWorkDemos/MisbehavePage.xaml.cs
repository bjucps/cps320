using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using Xamarin.Forms;
using Xamarin.Forms.Xaml;

namespace BackgroundWorkDemos
{
    [XamlCompilation(XamlCompilationOptions.Compile)]
    public partial class MisbehavePage : ContentPage
    {
        public MisbehavePage()
        {
            InitializeComponent();
        }

        private void AbuseUI_Clicked(object sender, EventArgs e)
        {
            while (true) 
                /* do nothing */;
        }

        private void BusyBackground_Clicked(object sender, EventArgs e)
        {
            Task.Run(() =>
           {
               int count = 0;
               while (true)
               {
                   ++count;
                   Console.WriteLine($"Still alive... count = {count}");
                   for (int j = 0; j < 1000; ++j)
                       for (int i = 0; i < 1000000; ++i)
                           /* do nothing */
                           ;
               }
           });
        }
    }
}