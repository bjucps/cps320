using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Xamarin.Forms;

namespace CustomControls
{
    public partial class MainPage : ContentPage
    {
        public MainPage()
        {
            InitializeComponent();
        }

        private void Ok_Tapped(object sender, EventArgs e)
        {
            Debug.WriteLine("Ok tapped!");
        }

        private void Cancel_Tapped(object sender, EventArgs e)
        {
            Debug.WriteLine("Cancel tapped!");
        }

        private void Hello_Clicked(object sender, EventArgs e)
        {
            Debug.WriteLine("Hello clicked!");
        }
    }
}
