using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using Xamarin.Forms;
using Xamarin.Forms.Xaml;

namespace DataBindingDemos.ModelViewDemo1
{
    [XamlCompilation(XamlCompilationOptions.Compile)]
    public partial class ModelViewDemo1Page : ContentPage
    {
        Product product;

        public ModelViewDemo1Page()
        {
            InitializeComponent();

            product = new Product() {
                Description = "Steinway 9-foot Concert Grand",
                Price = 180000
            };
            DescriptionEntry.Text = product.Description;
            PriceEntry.Text = product.Price.ToString();
        }

        private void Validate_Clicked(object sender, EventArgs e)
        {
            product.Description = DescriptionEntry.Text;
            product.Price = Convert.ToDouble(PriceEntry.Text);

            DescriptionLabel.Text = product.Description;
            PriceLabel.Text = product.Price.ToString();

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