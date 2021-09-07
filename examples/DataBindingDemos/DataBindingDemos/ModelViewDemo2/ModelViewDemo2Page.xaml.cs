using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using Xamarin.Forms;
using Xamarin.Forms.Xaml;

namespace DataBindingDemos.ModelViewDemo2
{
    [XamlCompilation(XamlCompilationOptions.Compile)]
    public partial class ModelViewDemo2Page : ContentPage
    {
        NotifyingProduct product;

        public ModelViewDemo2Page()
        {
            InitializeComponent();

            product = new NotifyingProduct() {
                Description = "Steinway 9-foot Concert Grand",
                Price = 180000
            };
            BindingContext = product;
        }

        private void Validate_Clicked(object sender, EventArgs e)
        {

            if (product.Description == "")
            {
                ResultLabel.Text = "Must provide description";
                return;
            }

            if (product.Price < 0)
            {
                ResultLabel.Text = "Price must be non-negative";
                return;
            }

            ResultLabel.Text = "Looks good!";

        }
    }
}