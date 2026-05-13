import 'dart:typed_data';
import 'package:arts_and_culture/api/api_service.dart';
import 'package:arts_and_culture/constants.dart';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

class UploadedPamphletScreen extends StatefulWidget {
  final int pamphletId;

  const UploadedPamphletScreen({super.key, required this.pamphletId});

  @override
  State<UploadedPamphletScreen> createState() => _UploadedPamphletScreenState();
}

class _UploadedPamphletScreenState extends State<UploadedPamphletScreen> {
  late Future<Uint8List> _futurePdf;

  @override
  void initState() {
    super.initState();

    _futurePdf = ApiService().getPamphletPdf(widget.pamphletId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(pamphletTitle)),
      body: FutureBuilder<Uint8List>(
        future: _futurePdf,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error loading PDF: ${snapshot.error}"));
          }

          if (!snapshot.hasData) {
            return const Center(child: Text("No PDF available."));
          }

          return PdfPreview(build: (format) async => snapshot.data!);
        },
      ),
    );
  }
}
