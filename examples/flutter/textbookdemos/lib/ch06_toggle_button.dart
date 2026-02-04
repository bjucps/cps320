import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Model {
  static final String server = defaultTargetPlatform == TargetPlatform.android
      ? "127.0.0.1"
      : "localhost";
  static final String serverPath = "http://$server:8000/courseImage.png";
  static const String localPath = "assets/flutter_icon.png";

  bool _isLocal;
  Model([this._isLocal = true]);
  static const String title = "Image Widget";
  static const String local = "Local", remote = "Internet";
  String get imagePath => _isLocal ? localPath : serverPath;
  String get imageSource => _isLocal ? local : remote;
  bool get isLocal => _isLocal;
  void toggleLocal() => _isLocal = !_isLocal;
}

/// Flutter `Image` Widget.
/// Displaying image from local assets folder and URL.
void main() => runApp(const ImageWidgetDemo());

class ImageWidgetDemo extends StatelessWidget {
  const ImageWidgetDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyImageWidget(),
    );
  }
}

class MyImageWidget extends StatefulWidget {
  const MyImageWidget({super.key});

  @override
  MyImageWidgetState createState() => MyImageWidgetState();
}

class MyImageWidgetState extends State<MyImageWidget> {
  final Model _model = Model();

  Widget loadImage() {
    return _model.isLocal
        ? Image.asset(_model.imagePath)
        : Image.network(_model.imagePath);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Model.title),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              width: 300,
              height: 300,
              padding: const EdgeInsets.all(20.0),
              child: loadImage(),
            ),
            const SizedBox(
              height: 40,
            ),
            Text(
              _model.imageSource,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            ToggleButtons(
              isSelected: [!_model.isLocal, _model.isLocal, true],
              onPressed: (int index) {
                setState(() {
                  if (index < 2) {
                     _model.toggleLocal();
                  }
                });
              },
              children: const [
                Icon(Icons.airplanemode_off),
                Icon(Icons.airplanemode_on),
                Icon(Icons.access_alarm),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
