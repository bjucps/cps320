using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using Xamarin.Forms;

namespace ListDemos
{
    class ProductListViewModel
    {
        public List<ProductViewModel> Products { get; }

        public ProductListViewModel()
        {
            try
            {
                Products = ProductCollection.Instance.Items
                    .Select(product => new ProductViewModel(product))
                    .ToList();

            } catch (Exception e)
            {
                Debug.WriteLine(e);
            }
        }

    }
}
