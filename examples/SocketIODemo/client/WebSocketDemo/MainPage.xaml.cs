using SocketIOClient;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Net.WebSockets;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using Xamarin.Forms;

namespace WebSocketDemo
{
    public partial class MainPage : ContentPage
    {

        public MainPage()
        {
            InitializeComponent();
            
        }


        async Task ConnectToSocketIOServer()
        {
            
            var client = new SocketIO("http://10.0.2.2:5000/");

            // Register handler for "hi" message from server
            client.On("hi", response =>
            {
                Console.WriteLine("Got response:" + response);
            });

            // Register event handler that runs when client connects successfully
            client.OnConnected += async (sender, e) =>
            {
                // Send a greeting message to the server
                await client.EmitAsync("greeting", "Hello there");

            };
            await client.ConnectAsync();
            Console.WriteLine("Connected.");
        }

        private void Button_Clicked(object sender, EventArgs e)
        {
            ConnectToSocketIOServer();
        }
    }
}
