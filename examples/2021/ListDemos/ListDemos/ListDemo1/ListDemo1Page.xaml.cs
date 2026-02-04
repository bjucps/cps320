using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using Xamarin.Forms;
using Xamarin.Forms.Xaml;

namespace ListDemos.ListDemo1
{
    [XamlCompilation(XamlCompilationOptions.Compile)]
    public partial class ListDemo1Page : ContentPage
    {
        public ListDemo1Page()
        {
            InitializeComponent();

            ItemsListView.ItemsSource = ProductCollection.Instance.Items;
        }

        private void ItemsListView_ItemTapped(object sender, ItemTappedEventArgs e)
        {
            Product product = e.Item as Product;
            var page = new ProductDetailPage(product);
            Navigation.PushAsync(page);
        }
    }
}