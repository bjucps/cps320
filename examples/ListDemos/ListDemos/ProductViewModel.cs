using System;
using System.Collections.Generic;
using System.Text;

namespace ListDemos
{
    class ProductViewModel
    {
        public Product Product { get; }

        public string Description => Product.Description;

        public string FormattedPrice => Product.Price.ToString("C");

        public string Color => Product.Price < 3 ? "Green" : "Red";

        public ProductViewModel(Product product)
        {
            Product = product;
        }



    }
}
