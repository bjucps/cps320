using System;
using System.Collections.Generic;
using System.Text;
using System.Windows.Input;
using Xamarin.Forms;

namespace ListDemos
{
    class ProductViewModel: BaseViewModel
    {
        public Product Product { get; }

        public int Id => Product.Id;

        public string Description => Product.Description;

        public string FormattedPrice => Product.Price.ToString("C");

        public string Color => Product.Price < 3 ? "Green" : "Red";

        public ProductViewModel(Product product)
        {
            Product = product;
        }

        public ICommand IncreasePriceCommand => new Command<string>( amount =>
        {
            Product.Price += Convert.ToDouble(amount);
            OnPropertyChanged(nameof(FormattedPrice));
        });

        public void NotifyAll()
        {
            OnPropertyChanged("");
        }
    }
}
