using ShellDemo.Models;
using ShellDemo.Services;
using ShellDemo.ViewModels;
using ShellDemo.Views;
using System;
using System.Collections.Generic;
using System.Text;
using System.Linq;
using Xamarin.Forms;
using System.Threading.Tasks;

namespace ShellDemo.SearchHandlers
{
    class ItemSearchHandler : SearchHandler
    {
        protected override void OnQueryChanged(string oldValue, string newValue)
        {
            base.OnQueryChanged(oldValue, newValue);

            if (string.IsNullOrWhiteSpace(newValue))
            {
                ItemsSource = null;                
            }
            else if (newValue.Length > 2)
            {
                _ = SearchItems(newValue);
            }
        }

        private async Task SearchItems(string keyword)
        {
            var dataStore = DependencyService.Get<IDataStore<Item>>();
            var result = await dataStore.FindItemsAsync(keyword);
            var list = result.ToList();
            ItemsSource = list;
        }

        protected override void OnItemSelected(object item)
        {
            base.OnItemSelected(item);

            var page = new ItemDetailPage(new ItemDetailViewModel(item as Item));
            _ = Shell.Current.Navigation.PushAsync(page);            
        }
    }
}
