﻿using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Xamarin.Forms;

namespace BackgroundWorkDemos
{
    public partial class MainPage : ContentPage
    {
        public MainPage()
        {
            InitializeComponent();
        }

        private void Misbehave_Clicked(object sender, EventArgs e)
        {
            Navigation.PushAsync(new MisbehavePage());
        }
    }
}
