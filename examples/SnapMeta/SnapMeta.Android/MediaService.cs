using Android.App;
using Android.Content;
using Android.OS;
using Android.Runtime;
using Android.Views;
using Android.Widget;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

[assembly: Xamarin.Forms.Dependency(typeof(SnapMeta.Droid.MediaService))]
namespace SnapMeta.Droid
{
    // From https://stackoverflow.com/questions/60618209/xamarin-forms-save-image-from-an-url-into-devices-gallery and 
    // https://xamarincodingtutorial.blogspot.com/2019/05/dependency-service-for-save-image.html
    class MediaService : IMediaService
    {        

        public void SaveImageFromByte(byte[] imageByte, string fileName)
        {
            try
            {
                // Save file to device pictures folder
                // On Android API 10 this requires https://developer.android.com/training/data-storage/use-cases#opt-out-scoped-storage
                Java.IO.File storagePath = Android.OS.Environment.GetExternalStoragePublicDirectory(Android.OS.Environment.DirectoryPictures);
                string path = System.IO.Path.Combine(storagePath.ToString(), fileName);
                System.IO.File.WriteAllBytes(path, imageByte);
                
                // Now, notify media system about the new file
                var mediaScanIntent = new Intent(Intent.ActionMediaScannerScanFile);
                mediaScanIntent.SetData(Android.Net.Uri.FromFile(new Java.IO.File(path)));
                Android.App.Application.Context.SendBroadcast(mediaScanIntent);
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex);
            }
        }
    }
}