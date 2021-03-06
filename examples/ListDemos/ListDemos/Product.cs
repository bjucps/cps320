using System;
using System.Collections.Generic;
using System.Text;

namespace ListDemos
{
    public class Product
    {
        public int Id { get; set; }
        public string Description { get; set; }
        public double Price { get; set; }

        public override string ToString()
        {
            return $"{Description} - {Price}";
        }
    }
}
