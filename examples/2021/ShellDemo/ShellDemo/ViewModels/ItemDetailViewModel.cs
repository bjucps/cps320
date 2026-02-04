using ShellDemo.Models;
using System;
using System.Diagnostics;
using System.Threading.Tasks;
using Xamarin.Forms;

namespace ShellDemo.ViewModels
{
    public class ItemDetailViewModel : BaseViewModel
    {

        public string Text => item.Text;
        public string Description => item.Description;


        private Item item;

        public ItemDetailViewModel(Item item)
        {
            Title = "Item Detail";
            this.item = item;
        }
    }
}
