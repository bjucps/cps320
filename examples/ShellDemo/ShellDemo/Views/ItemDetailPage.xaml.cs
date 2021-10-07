using ShellDemo.ViewModels;
using System.ComponentModel;
using Xamarin.Forms;

namespace ShellDemo.Views
{
    public partial class ItemDetailPage : ContentPage
    {
        public ItemDetailPage(ItemDetailViewModel itemDetailViewModel)
        {
            InitializeComponent();
            BindingContext = itemDetailViewModel;
        }
    }
}