using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using Xamarin.Forms;
using Xamarin.Forms.Xaml;

namespace ListDemos.ListDemo3
{
    [XamlCompilation(XamlCompilationOptions.Compile)]
    public partial class ListDemo3Page : ContentPage
    {
        ProductViewModel selectedProductVM;

        public ListDemo3Page()
        {
            InitializeComponent();
            BindingContext = new ProductListViewModel();
        }

        private void ItemsListView_ItemTapped(object sender, ItemTappedEventArgs e)
        {
            selectedProductVM = e.Item as ProductViewModel;
            var page = new ProductDetailPage(selectedProductVM.Product);
            Navigation.PushAsync(page);
        }

        protected override void OnAppearing()
        {
            base.OnAppearing();
            if (selectedProductVM != null)
            {
                selectedProductVM.NotifyAll();
            }
        }
    }
}