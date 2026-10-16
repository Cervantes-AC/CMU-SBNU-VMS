import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

/// A full-screen QR code scanner that returns the scanned barcode string.
///
/// QR codes are presentation of short-lived, activity-bound tokens.
/// Client-side scanning captures the token only; a trusted server must
/// validate signature, expiry, activity state, participant eligibility,
/// replay protection, and idempotency before any attendance is accepted.
class AttendanceQrScanner extends StatefulWidget {
  const AttendanceQrScanner({super.key});

  @override
  State<AttendanceQrScanner> createState() => _AttendanceQrScannerState();
}

class _AttendanceQrScannerState extends State<AttendanceQrScanner> {
  MobileScannerController? _controller;
  bool _isScanning = true;

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (!_isScanning) return;
    final barcodes = capture.barcodes;
    final code = barcodes.firstOrNull?.rawValue;
    if (code != null && code.isNotEmpty && mounted) {
      _isScanning = false;
      Navigator.of(context).pop(code);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR Code'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: MobileScanner(
              controller: _controller,
              onDetect: _onDetect,
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.black54,
              alignment: Alignment.center,
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.qr_code_scanner,
                      color: Colors.white, size: 48),
                  SizedBox(height: 12),
                  Text(
                    'Point the camera at a QR code',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Scanning captures the token only. A trusted server '
                    'must validate it before attendance is accepted.',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
