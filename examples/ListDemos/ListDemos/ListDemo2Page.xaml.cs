using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using Xamarin.Forms;
using Xamarin.Forms.Xaml;

namespace ListDemos
{
    [XamlCompilation(XamlCompilationOptions.Compile)]
    public partial class ListDemo2Page : ContentPage
    {
        public ListDemo2Page()
        {
            InitializeComponent();
            BindingContext = new ProductListViewModel();
        }

        private void ItemsListView_ItemTapped(object sender, ItemTappedEventArgs e)
        {
            var product = e.Item as ProductViewModel;
            var page = new ProductDetailPage(product.Product);
            Navigation.PushAsync(page);
        }
    }
}