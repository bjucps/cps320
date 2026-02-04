using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Drawing;
using System.Text;

namespace DataBindingDemos.MVVMDemoFinal
{
    class ProductViewModel : BaseViewModel
    {

        private Product product;

        private string _description;
        public string Description
        {
            get => _description;
            set
            {
                SetProperty(ref _description, value);
                OnPropertyChanged(nameof(CanValidate));
            }
        }

        private string _price;
        public string Price
        {
            get => _price;
            set
            {
                SetProperty(ref _price, value);
                OnPropertyChanged(nameof(CanValidate));
            }
        }

        public string ProductDescription => product.Description;

        public string FormattedPrice => product.Price.ToString("C");

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

        public bool CanValidate => Description.Length > 0 && Price.Length > 0;
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
                double price = Convert.ToDouble(Price);
                if (price < 0)
                {
                    throw new ArgumentException("Illegal price");
                }
            }
            catch (Exception e)
            {
                Message = "Invalid price!";
                MessageColor = Color.Red;
                return false;
            }

            if (Description.Length < 3)
            {
                Message = "Description too short!";
                MessageColor = Color.Red;
                return false;
            }

            Message = "Looks good!";
            MessageColor = Color.Green;

            product.Description = Description;
            product.Price = Convert.ToDouble(Price);
            OnPropertyChanged(nameof(ProductDescription));
            OnPropertyChanged(nameof(FormattedPrice));
            return true;
        }


    }
}
