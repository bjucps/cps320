using ExifLibrary;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Xamarin.Essentials;
using Xamarin.Forms;

namespace SnapMeta
{
    public partial class MainPage : ContentPage
    {
        public MainPage()
        {
            InitializeComponent();
        }



        private async void TakePictureBtn_Clicked(object sender, EventArgs e)
        {

            try
            {
                var photo = await MediaPicker.CapturePhotoAsync();

                var imageFilename = Path.Combine(FileSystem.CacheDirectory, photo.FileName);
                using (var stream = await photo.OpenReadAsync())
                using (var newStream = File.OpenWrite(imageFilename))
                    await stream.CopyToAsync(newStream);

                img.Source = ImageSource.FromFile(imageFilename);

                // Update image metadata
                var image = ImageFile.FromFile(imageFilename);

                var datetime = image.Properties.Get<ExifDateTime>(ExifTag.DateTimeOriginal);
                string make = image.Properties.Get(ExifTag.Make).ToString();

                Debug.WriteLine("Original image date/time:" + datetime);
                Debug.WriteLine("Original image camera make:" + make);

                image.Properties.Set(ExifTag.DateTimeOriginal, new DateTime(2001, 9, 11));
                image.Properties.Set(ExifTag.Make, "Schaub");
                image.Properties.Set(ExifTag.Model, "The Fancy Camera");

                image.Properties.Set(ExifTag.GPSLatitude, 38f, 54f, 36f);
                image.Properties.Set(ExifTag.GPSLatitudeRef, GPSLatitudeRef.North);
                image.Properties.Set(ExifTag.GPSLongitude, 77f, 0f, 53f);
                image.Properties.Set(ExifTag.GPSLongitudeRef, GPSLongitudeRef.West);
                image.Properties.Set(ExifTag.GPSAltitude, 2f);
                image.Properties.Set(ExifTag.GPSAltitudeRef, GPSAltitudeRef.AboveSeaLevel);

                // Dump image metadata
                foreach (var prop in image.Properties)
                {
                    Debug.WriteLine($"Name = {prop.Name}, Tag = {prop.Tag}, Value = {prop.Value}");
                }

                image.Save(imageFilename);

                // Now, transfer image to media library
                byte[] imageBytes = File.ReadAllBytes(imageFilename);
                DependencyService.Get<IMediaService>().SaveImageFromByte(imageBytes, photo.FileName);
            } catch (PermissionException ex)
            {
                Debug.WriteLine(ex);
            }


        }
    }
}
