using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Xamarin.Forms;

namespace ImageDemo
{
    public partial class MainPage : ContentPage
    {
        public MainPage()
        {
            InitializeComponent();

            MyImg.Source = ImageSource.FromResource("ImageDemo.images.baby.png", typeof(MainPage).Assembly);
        }
    }
}
