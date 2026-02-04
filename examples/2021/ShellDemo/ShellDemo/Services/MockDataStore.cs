using ShellDemo.Models;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace ShellDemo.Services
{
    public class MockDataStore : IDataStore<Item>
    {
        readonly List<Item> items;

        public MockDataStore()
        {
            items = new List<Item>()
            {
                new Item { Id = Guid.NewGuid().ToString(), Text = "First item", Description="This is an alpha 1 item description." },
                new Item { Id = Guid.NewGuid().ToString(), Text = "Second item", Description="This is an alphanum 2 item description." },
                new Item { Id = Guid.NewGuid().ToString(), Text = "Third item", Description="This is an alphanumeric 3 item description." },
                new Item { Id = Guid.NewGuid().ToString(), Text = "Fourth item", Description="This is a beta 1 item description." },
                new Item { Id = Guid.NewGuid().ToString(), Text = "Fifth item", Description="This is a beta 1 item description." },
                new Item { Id = Guid.NewGuid().ToString(), Text = "Sixth item", Description="This is a beta 1 item description." }
            };
        }

        public async Task<bool> AddItemAsync(Item item)
        {
            items.Add(item);

            return await Task.FromResult(true);
        }

        public async Task<bool> UpdateItemAsync(Item item)
        {
            var oldItem = items.Where((Item arg) => arg.Id == item.Id).FirstOrDefault();
            items.Remove(oldItem);
            items.Add(item);

            return await Task.FromResult(true);
        }

        public async Task<bool> DeleteItemAsync(string id)
        {
            var oldItem = items.Where((Item arg) => arg.Id == id).FirstOrDefault();
            items.Remove(oldItem);

            return await Task.FromResult(true);
        }

        public async Task<Item> GetItemAsync(string id)
        {
            return await Task.FromResult(items.FirstOrDefault(s => s.Id == id));
        }

        public async Task<IEnumerable<Item>> GetItemsAsync(bool forceRefresh = false)
        {
            return await Task.FromResult(items);
        }

        public async Task<IEnumerable<Item>> FindItemsAsync(string newValue)
        {
            return await Task.FromResult(
                from item in items 
                where item.Description.ToLower().Contains(newValue.ToLower())
                select item
            );
        }
    }
}