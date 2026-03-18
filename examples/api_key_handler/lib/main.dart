import 'package:api_key_handler/constants.dart';
import 'package:api_key_handler/encrypt.dart';
import 'package:flutter/material.dart';

// Basic encryption/secure storage demo
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: const MyHomePage(title: title),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? _clearText = emptyString;
  String _displayString = prompt;
  String? encrLocation = emptyString;

  void encryptDecrypt() async {
    if (_displayString == prompt || _displayString == _clearText) {
      encrLocation = await EncryptionUtilities.encryptAsset(envFile);
      setState(() => _displayString = "$encryptedAt $encrLocation");
    } else if (encrLocation != null) {
      _clearText = await EncryptionUtilities.decryptEnv(encrLocation!);
      setState(() => _displayString = _clearText ?? _displayString);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Text(
          _displayString,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: encryptDecrypt,
        tooltip: 'Toggle',
        child: const Icon(Icons.enhanced_encryption),
      ),
    );
  }
}
