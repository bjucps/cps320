import 'package:arts_and_culture/api/get_pamphlet.dart';
import 'package:arts_and_culture/api/get_events.dart';
import 'package:arts_and_culture/constants.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

Future<pw.Font> _loadFont(String path) async {
  final data = await rootBundle.load(path);
  return pw.Font.ttf(data);
}

Future<pw.MemoryImage> _loadImage(String path) async {
  final data = await rootBundle.load(path);
  return pw.MemoryImage(data.buffer.asUint8List());
}

List<String> _buildDateLines(Pamphlet pamphlet, Event? event) {
  final dateText = event?.eventDate ?? pamphlet.date;
  final timeText = event?.eventTime ?? '';

  try {
    final date = DateTime.parse(dateText);
    final lines = [DateFormat('EEEE, MMMM d, yyyy').format(date)];

    if (timeText.isNotEmpty) {
      final time = DateFormat('HH:mm:ss').parse(timeText);
      lines.add(DateFormat('h:mm a').format(time));
    }

    return lines;
  } catch (_) {
    return [pamphlet.date];
  }
}

Future<Uint8List> buildPamphletPdf(Pamphlet pamphlet, {Event? event}) async {
  final regular = await _loadFont('assets/fonts/NotoSerif-Regular.ttf');
  final bold = await _loadFont('assets/fonts/NotoSerif-Bold.ttf');
  final italic = await _loadFont('assets/fonts/NotoSerif-Italic.ttf');
  final crest = await _loadImage(pamphletCrestLogo);
  final dateLines = _buildDateLines(pamphlet, event);

  final pdf = pw.Document(
    theme: pw.ThemeData.withFont(
      base: regular,
      bold: bold,
      italic: italic,
      boldItalic: bold,
    ),
  );

  pw.Widget c(pw.Widget child) => pw.Center(child: child);

  List<pw.Widget> buildProgramFlow() {
    final widgets = <pw.Widget>[];

    for (final item in pamphlet.programContent) {
      final type = item['type'];

      if (type == "piece") {
        final title = item['title'] ?? '';
        final author = item['author'] ?? '';
        final composerDates = item['composer_dates'] ?? '';

        widgets.addAll([
          pw.SizedBox(height: 14),
          c(
            pw.Container(
              width: 360,
              child: pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.ConstrainedBox(
                    constraints: const pw.BoxConstraints(maxWidth: 180),
                    child: pw.Text(
                      title,
                      style: pw.TextStyle(
                        fontSize: 12,
                        fontStyle: pw.FontStyle.italic,
                      ),
                    ),
                  ),
                  pw.SizedBox(width: 4),
                  pw.Expanded(
                    child: pw.Padding(
                      padding: const pw.EdgeInsets.only(top: 8),
                      child: pw.Text(
                        "." * 96,
                        maxLines: 1,
                        overflow: pw.TextOverflow.clip,
                        style: const pw.TextStyle(fontSize: 6),
                      ),
                    ),
                  ),
                  pw.SizedBox(width: 4),
                  pw.ConstrainedBox(
                    constraints: const pw.BoxConstraints(maxWidth: 130),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text(
                          author,
                          textAlign: pw.TextAlign.right,
                          style: const pw.TextStyle(fontSize: 12),
                        ),
                        if (composerDates.isNotEmpty)
                          pw.Text(
                            composerDates,
                            textAlign: pw.TextAlign.right,
                            style: const pw.TextStyle(fontSize: 10),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ]);
      }

      if (type == "performers") {
        final performers = (item['performers'] as List?)?.cast<String>() ?? [];

        widgets.addAll([
          pw.SizedBox(height: 6),
          ...performers.map(
            (p) => c(
              pw.Text(
                p,
                textAlign: pw.TextAlign.center,
                style: const pw.TextStyle(fontSize: 10),
              ),
            ),
          ),
          pw.SizedBox(height: 6),
        ]);
      }

      if (type == "instruction") {
        widgets.add(
          c(
            pw.Text(
              item['text'] ?? '',
              textAlign: pw.TextAlign.center,
              style: pw.TextStyle(fontStyle: pw.FontStyle.italic, fontSize: 10),
            ),
          ),
        );
      }
    }

    return widgets;
  }

  List<pw.Widget> buildFooter() {
    return [
      pw.SizedBox(height: 20),

      c(
        pw.Column(
          children: [
            pw.Text(
              "Please silence all cell phones and other electronic devices before the performance. Cameras, flash photography and recording devices create distractions and may infringe on copyright law. The use of all such devices is prohibited.",
              textAlign: pw.TextAlign.center,
              style: const pw.TextStyle(fontSize: 9),
            ),

            pw.SizedBox(height: 12),

            pw.Text(
              "UPCOMING MUSIC EVENTS",
              textAlign: pw.TextAlign.center,
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11),
            ),

            pw.Text(
              "Micah Hyink Violin Recital, April 14, 4:00 p.m., Stratton Hall\n"
              "University Singers, April 16, 5:30 p.m., Stratton Hall\n"
              "Percussion Ensemble, April 18, 5:30 p.m., Stratton Hall",
              textAlign: pw.TextAlign.center,
              style: const pw.TextStyle(fontSize: 9),
            ),

            pw.SizedBox(height: 12),

            pw.Text(
              "FRIENDS OF MUSIC AT BJU 2025-2026",
              textAlign: pw.TextAlign.center,
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11),
            ),

            pw.Text(
              "Dr. Jonathan Simmons - Faculty Coach\n"
              "Katie Bracewell - Faculty Coach\n"
              "Brandon Ironside - Faculty Coach",
              textAlign: pw.TextAlign.center,
              style: const pw.TextStyle(fontSize: 9),
            ),

            pw.SizedBox(height: 10),

            pw.Text(
              "QR Code",
              textAlign: pw.TextAlign.center,
              style: const pw.TextStyle(fontSize: 10),
            ),

            pw.SizedBox(height: 6),

            pw.Text(
              "BECOME A FRIEND OF MUSIC AT BJU",
              textAlign: pw.TextAlign.center,
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11),
            ),

            pw.Text(
              "We depend on Friends like you to deliver transformative learning experiences for our Music students.",
              textAlign: pw.TextAlign.center,
              style: const pw.TextStyle(fontSize: 9),
            ),

            pw.SizedBox(height: 6),

            pw.Text(
              "music.bju.edu/friends",
              textAlign: pw.TextAlign.center,
              style: pw.TextStyle(fontSize: 9, fontStyle: pw.FontStyle.italic),
            ),

            pw.SizedBox(height: 10),

            pw.Text(
              "The Division of Music at BJU is a community of students, faculty, and staff committed to empowering musicians to pursue and share the beauty of God through redemptive artistry.",
              textAlign: pw.TextAlign.center,
              style: const pw.TextStyle(fontSize: 9),
            ),

            pw.SizedBox(height: 10),

            pw.Text(
              "Bob Jones University is an accredited institutional member of the National Association of Schools of Music.",
              textAlign: pw.TextAlign.center,
              style: const pw.TextStyle(fontSize: 8),
            ),
          ],
        ),
      ),
    ];
  }

  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.letter,
      margin: const pw.EdgeInsets.symmetric(horizontal: 78, vertical: 72),
      build: (context) => [
        c(
          pw.Column(
            children: [
              pw.Image(crest, width: 50, fit: pw.BoxFit.contain),
              pw.SizedBox(height: 24),
              pw.Text(
                pamphlet.institution.isNotEmpty
                    ? pamphlet.institution.toUpperCase()
                    : "BOB JONES UNIVERSITY",
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(
                  fontSize: 15,
                  fontWeight: pw.FontWeight.bold,
                  letterSpacing: 2.2,
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Text(
                pamphlet.division.isNotEmpty
                    ? pamphlet.division
                    : "Division of Music",
                textAlign: pw.TextAlign.center,
                style: const pw.TextStyle(fontSize: 11.5),
              ),
              pw.SizedBox(height: 38),
              pw.Text(
                "presents",
                textAlign: pw.TextAlign.center,
                style: const pw.TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),

        pw.SizedBox(height: 28),

        c(
          pw.Text(
            pamphlet.title.toUpperCase(),
            textAlign: pw.TextAlign.center,
            style: pw.TextStyle(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ),

        pw.SizedBox(height: 18),

        c(
          pw.Text(
            pamphlet.location,
            textAlign: pw.TextAlign.center,
            style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold),
          ),
        ),

        pw.SizedBox(height: 6),

        c(
          pw.Column(
            children: dateLines
                .map(
                  (line) => pw.Text(
                    line,
                    textAlign: pw.TextAlign.center,
                    style: const pw.TextStyle(fontSize: 12),
                  ),
                )
                .toList(),
          ),
        ),

        pw.SizedBox(height: 36),

        ...buildProgramFlow(),

        pw.NewPage(),

        ...buildFooter(),
      ],
    ),
  );

  return pdf.save();
}
