using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Xamarin.Forms;

namespace DynamicControls
{
    public partial class MainPage : ContentPage
    {
        public MainPage()
        {
            InitializeComponent();
        }

        private void MakeMore_Clicked(object sender, EventArgs e)
        {
            // Create button
            var btn = new Button
            {
                Text = "Hi",
                FontSize = 10
            };

            // Attach event handler
            btn.Clicked += (source, evt) =>
            {
                btn.Text = "Giggle!";
            };

            // Add to layout
            MyLayout.Children.Add(btn);
        }

    }
}
