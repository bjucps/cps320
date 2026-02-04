using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Text;

namespace ListDemos
{
    class ProductCollection
    {
        public ObservableCollection<Product> Items;

        private ProductCollection()
        {
            Items = new ObservableCollection<Product>
            {
                new Product { Id = 100, Description = "Apples", Price = 2.50 },
                new Product { Id = 101, Description = "Oranges", Price = 3.50 },
                new Product { Id = 101, Description = "Bananas", Price = 5.50 },
                new Product { Id = 101, Description = "Plums", Price = 1.50 },
                new Product { Id = 101, Description = "Pears", Price = 2.50 },
                new Product { Id = 101, Description = "Lemons", Price = .50 },
            };
        }

        public static ProductCollection Instance { get; } = new ProductCollection();

        public void RemoveItem(Product product)
        {
            Items.Remove(product);
        }

        public void AddProduct(Product product)
        {
            Items.Add(product);
        }
    }
}
