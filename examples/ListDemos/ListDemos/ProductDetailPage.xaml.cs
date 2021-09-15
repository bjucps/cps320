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
    public partial class ProductDetailPage : ContentPage
    {
        public ProductDetailPage()
        {
            InitializeComponent();
        }

        public ProductDetailPage(Product product)
        {
            InitializeComponent();
            BindingContext = new ProductViewModel(product);
        }

        private void DeleteProduct_Tapped(object sender, EventArgs e)
        {
            var productVM = BindingContext as ProductViewModel;
            ProductCollection.Instance.RemoveItem(productVM.Product);
            Navigation.PopAsync();
        }

        //private void IncreasePrice_Clicked(object sender, EventArgs e)
        //{
        //    var product = BindingContext as Product;
        //    product.Price += 1;
        //}
    }
}