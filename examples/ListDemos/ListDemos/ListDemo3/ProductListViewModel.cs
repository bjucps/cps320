using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Diagnostics;
using System.Linq;
using System.Text;
using Xamarin.Forms;

namespace ListDemos.ListDemo3
{
    class ProductListViewModel
    {
        public MappedObservableCollection<Product, ProductViewModel> Products { get; }

        public ProductListViewModel()
        {

            Products = new MappedObservableCollection<Product, ProductViewModel>(
                product => new ProductViewModel(product),
                ProductCollection.Instance.Items);

        }

        public Command AddItemCommand => new Command(() =>
        {
            ProductCollection.Instance.AddProduct(new Product
            {
                Id = ProductCollection.Instance.Items.Count + 100,
                Description = "Another product",
                Price = new Random().NextDouble() * 100
            });
        });

    }
}
