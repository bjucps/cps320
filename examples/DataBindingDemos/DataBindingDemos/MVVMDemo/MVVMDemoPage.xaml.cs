using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using Xamarin.Forms;
using Xamarin.Forms.Xaml;

namespace DataBindingDemos.MVVMDemo
{
    [XamlCompilation(XamlCompilationOptions.Compile)]
    public partial class MVVMDemoPage : ContentPage
    {
        ProductViewModel viewModel;

        public MVVMDemoPage()
        {
            InitializeComponent();
            Product product = new Product()
            {
                Description = "Steinway 9-foot Concert Grand",
                Price = 180000
            };
            viewModel = new ProductViewModel(product);
            BindingContext = viewModel;
        }

        private void Validate_Clicked(object sender, EventArgs e)
        {
            viewModel.Validate();
        }
    }
}