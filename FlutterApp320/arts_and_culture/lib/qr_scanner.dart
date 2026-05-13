import 'package:arts_and_culture/api/api_service.dart';
import 'package:arts_and_culture/constants.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:arts_and_culture/components/confetti.dart';

class QrScannerPage extends StatefulWidget {
  const QrScannerPage({super.key});

  @override
  State<QrScannerPage> createState() => _QrScannerPageState();
}

class _QrScannerPageState extends State<QrScannerPage> {
  late MobileScannerController _controller;
  bool _processing = false;

  @override
  void initState() {
    super.initState();
    _controller = MobileScannerController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String? _extractHash(String raw) {
    try {
      final uri = Uri.parse(raw.trim());
      if (uri.scheme == uriScheme && uri.host == deepLinkEventPath) {
        if (uri.pathSegments.isNotEmpty) {
          final hash = uri.pathSegments.first;
          if (hash.isNotEmpty) return hash;
        }
      }
    } catch (_) {}
    return null;
  }

  void _onDetect(BarcodeCapture capture) async {
    if (_processing) return;
    final raw = capture.barcodes.firstOrNull?.rawValue;
    if (raw == null) return;

    final hash = _extractHash(raw);
    if (hash == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(qrNotRecognized),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() => _processing = true);
    await _controller.stop();

    if (!mounted) return;
    await _showCheckInDialog(hash);

    if (mounted) {
      setState(() => _processing = false);
      await _controller.start();
    }
  }

  Future<void> _showCheckInDialog(String hash) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const _LoadingDialog(),
    );

    String? errorMsg;
    Map<String, dynamic>? result;
    try {
      result = await ApiService().checkIn(hash);
    } catch (e) {
      errorMsg = e.toString().replaceFirst('Exception: ', '');
    }

    if (!mounted) return;
    Navigator.of(context).pop();

    final status = result?['status'] as String? ?? '';
    await showDialog(
      context: context,
      builder: (_) {
        if (errorMsg != null) return _ResultDialog.error(errorMsg);
        if (status == 'already_attended') {
          return _ResultDialog.alreadyAttended(result!);
        }
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showConfettiMix(context);
        });
        return _ResultDialog.success(result!);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(scanEventQR)),
      body: Stack(
        children: [
          MobileScanner(controller: _controller, onDetect: _onDetect),
          if (_processing)
            const ColoredBox(
              color: Colors.black38,
              child: Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }
}

class _LoadingDialog extends StatelessWidget {
  const _LoadingDialog();
  @override
  Widget build(BuildContext context) => const AlertDialog(
    content: SizedBox(
      height: 80,
      child: Center(child: CircularProgressIndicator()),
    ),
  );
}

class _ResultDialog extends StatelessWidget {
  final bool success;
  final String title;
  final String message;
  final String? eventName;
  final String? eventDate;
  final int? semesterCount;

  final bool isWarning;

  const _ResultDialog._({
    required this.success,
    required this.title,
    required this.message,
    this.eventName,
    this.eventDate,
    this.semesterCount,
    this.isWarning = false,
  });

  factory _ResultDialog.success(Map<String, dynamic> data) => _ResultDialog._(
    success: true,
    title: checkInSuccessTitle,
    message: checkInSuccessMessage,
    eventName: data['event'] as String?,
    eventDate: data['event_date'] as String?,
    semesterCount: data['semester_attendances'] as int?,
  );

  factory _ResultDialog.alreadyAttended(Map<String, dynamic> data) =>
      _ResultDialog._(
        success: false,
        title: alreadyAttendedTitle,
        message: alreadyAttendedMessage,
        eventName: data['event'] as String?,
        eventDate: data['event_date'] as String?,
        semesterCount: data['semester_attendances'] as int?,
        isWarning: true,
      );

  factory _ResultDialog.error(String msg) =>
      _ResultDialog._(success: false, title: checkInErrorTitle, message: msg);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          Icon(
            success
                ? Icons.check_circle
                : (isWarning ? Icons.info : Icons.error),
            color: success
                ? Colors.green
                : (isWarning ? Colors.orange : Colors.red),
          ),
          const SizedBox(width: 8),
          Text(title),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(message),
          if (eventName != null) ...[
            const SizedBox(height: 12),
            Text(
              eventName!,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            if (eventDate != null)
              Text(eventDate!, style: const TextStyle(color: Colors.grey)),
          ],
          if (semesterCount != null) ...[
            const SizedBox(height: 8),
            Text(
              '$semesterAttendedLabel $semesterCount',
              style: const TextStyle(fontSize: 13, color: Colors.grey),
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('OK'),
        ),
      ],
    );
  }
}
