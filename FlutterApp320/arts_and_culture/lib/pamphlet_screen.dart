import 'dart:typed_data';
import 'package:arts_and_culture/api/get_events.dart';
import 'package:arts_and_culture/api/get_pamphlet.dart';
import 'package:arts_and_culture/components/build_pamphlet_pdf.dart';
import 'package:arts_and_culture/constants.dart';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

class PamphletScreen extends StatefulWidget {
  final String eventId;
  final int pamphletId;

  const PamphletScreen({
    super.key,
    required this.eventId,
    required this.pamphletId,
  });

  @override
  State<PamphletScreen> createState() => _PamphletScreenState();
}

class _PamphletScreenState extends State<PamphletScreen> {
  late Future<Uint8List> _futurePdf;

  @override
  void initState() {
    super.initState();

    _futurePdf = () async {
      final results = await Future.wait([
        getPamphlet(widget.pamphletId),
        getEventDetails(widget.eventId),
      ]);

      return buildPamphletPdf(
        results[0] as Pamphlet,
        event: results[1] as Event,
      );
    }();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(pamphletTitle)),
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
            return const Center(child: Text("No PDF generated."));
          }

          return PdfPreview(build: (format) async => snapshot.data!);
        },
      ),
    );
  }
}
