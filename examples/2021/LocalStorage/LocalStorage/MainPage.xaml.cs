using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Xamarin.Forms;

namespace LocalStorage
{
    public partial class MainPage : ContentPage
    {
        public MainPage()
        {
            InitializeComponent();
        }

        private void Load_Clicked(object sender, EventArgs e)
        {
            string filename = FilenameEntry.Text;
            string fullFilename = Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData), filename);
            Debug.WriteLine($"The full filename is: {fullFilename}");
            TextEditor.Text = File.ReadAllText(fullFilename);
        }

        private void Save_Clicked(object sender, EventArgs e)
        {
            string text = TextEditor.Text;
            string filename = FilenameEntry.Text;
            string fullFilename = Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData), filename);
            File.WriteAllText(fullFilename, text);
        }
    }
}
