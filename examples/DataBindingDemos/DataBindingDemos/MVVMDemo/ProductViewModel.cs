using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Drawing;
using System.Text;

namespace DataBindingDemos.MVVMDemo
{
    class ProductViewModel : BaseViewModel
    {

        private Product product;

        private string _description;
        public string Description
        {
            get => _description;
            set => SetProperty(ref _description, value);
        }

        private string _price;
        public string Price
        {
            get => _price;
            set => SetProperty(ref _price, value);
        }

        private string _message;
        public string Message
        {
            get => _message;
            set => SetProperty(ref _message, value);
        }

        private Color _messageColor;
        public Color MessageColor
        {
            get => _messageColor;
            set => SetProperty(ref _messageColor, value);
        }

        public ProductViewModel(Product product)
        {
            this.product = product;
            Description = product.Description;
            Price = product.Price.ToString();
        }

        public bool Validate()
        {
            Message = "";
            try
            {
                Convert.ToDouble(Price);
            }
            catch (Exception e)
            {
                Message = "Invalid price!";
                MessageColor = Color.Red;
                return false;
            }

            Message = "Looks good!";
            MessageColor = Color.Green;

            product.Description = Description;
            product.Price = Convert.ToDouble(Price);
            return true;
        }


    }
}
