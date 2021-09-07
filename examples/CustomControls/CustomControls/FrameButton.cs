using System;
using System.Collections.Generic;
using System.Text;
using Xamarin.Forms;

namespace CustomControls
{
    class FrameButton : Frame
    {

        public string Text
        {
            get => _label.Text;
            set => _label.Text = value;
        }
        
        public string IconText
        {
            get => _iconlabel.Text;
            set => _iconlabel.Text = value;
        }

        public event EventHandler Clicked;

        private Label _label;

        private Label _iconlabel;

        public FrameButton()
        {
            var panel = new StackLayout()
            {
                Orientation = StackOrientation.Horizontal,
                HorizontalOptions = LayoutOptions.CenterAndExpand,
                VerticalOptions = LayoutOptions.CenterAndExpand
            };

            _label = new Label()
            {
                VerticalOptions = LayoutOptions.CenterAndExpand,
                FontSize = 30,                
                TextColor = Color.White
            };

            _iconlabel = new Label()
            {
                VerticalOptions = LayoutOptions.CenterAndExpand,
                FontSize = 30,
                TextColor = Color.White
            };
            
            panel.Children.Add(_iconlabel);
            panel.Children.Add(_label);

            // Now, Properties of frame

            Content = panel;

            HorizontalOptions = LayoutOptions.FillAndExpand;
            HasShadow = false;
            CornerRadius = 30;
            BackgroundColor = Color.LightBlue;

            var tapRecognizer = new TapGestureRecognizer();
            tapRecognizer.Tapped += (source, evt) => {
                if (this.Clicked != null)
                    this.Clicked(this, null);
            };

            GestureRecognizers.Add(tapRecognizer);
        }
    }
}
