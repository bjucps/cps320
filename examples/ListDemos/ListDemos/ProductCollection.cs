using System;
using System.Collections.Generic;
using System.Text;

namespace ListDemos
{
    class ProductCollection
    {
        public List<Product> Items;

        private ProductCollection()
        {
            Items = new List<Product>
            {
                new Product { Id = 100, Description = "Toothpaste", Price = 2.50 },
                new Product { Id = 100, Description = "Oranges", Price = 3.50 }
            };
        }

        public static ProductCollection Instance { get; } = new ProductCollection();
    }
}
