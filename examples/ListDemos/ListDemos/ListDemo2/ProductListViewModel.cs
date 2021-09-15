using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Diagnostics;
using System.Linq;
using System.Text;
using Xamarin.Forms;

namespace ListDemos.ListDemo2
{
    class ProductListViewModel
    {
        public List<ProductViewModel> Products { get; }

        public ProductListViewModel()
        {
            Products = new List<ProductViewModel>();
            foreach (Product p in ProductCollection.Instance.Items)
            {
                Products.Add(new ProductViewModel(p));
            }

        }

    }
}
