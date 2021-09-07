using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Text;

namespace DataBindingDemos.ModelViewDemo2
{
class NotifyingProduct : INotifyPropertyChanged
{
    public event PropertyChangedEventHandler PropertyChanged;

    private string _description;
    public string Description
    {
        get => _description; 
        set
        {
            _description = value;
            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs("Description"));                
        }
    }

    private double _price;
    public double Price
    {
        get => _price; 
        set { 
            _price = value;
            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs("Price"));
        }
    }

}
}
