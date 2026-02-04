using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using Xamarin.Forms;

namespace AsyncDemos
{
    public partial class MainPage : ContentPage
    {

        CancellationTokenSource cancelSource;
        SearchHandler searchHandler = new SearchHandler();

        public MainPage()
        {
            InitializeComponent();
        }

        private async void LiveSearchEntry_TextChanged(object sender, TextChangedEventArgs e)
        {
            if (cancelSource != null)
            {
                cancelSource.Cancel();
            }

            cancelSource = new CancellationTokenSource();
            
            try
            {
                MyListView.ItemsSource = await searchHandler.SearchWithCancelAndFeedbackAsync(LiveSearchEntry.Text, 
                    msg => {
                            SearchProgressLabel.Text = msg;
                            Console.WriteLine($"{DateTime.Now} - {msg}");
                    },
                    cancelSource.Token);
            } catch (OperationCanceledException ex)
            {
                Console.WriteLine($"{DateTime.Now} - Operation cancelled");
            }
            

        }

        protected override void OnDisappearing()
        {
            base.OnDisappearing();
            if (cancelSource != null)
            {
                cancelSource.Cancel();
            }
        }

        private async void Search_Clicked(object sender, EventArgs e)
        {
           
            MyListView.ItemsSource = await searchHandler.SearchWithFeedbackAsync(SearchEntry.Text,
                (string msg) =>
                {
                    SearchProgressLabel.Text = msg;
                });
        }
    }
}
