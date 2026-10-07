import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import 'package:cmu_sbnu_vms/app.dart';
import 'package:cmu_sbnu_vms/core/theme/app_theme.dart';
import 'package:cmu_sbnu_vms/core/utils/responsive.dart';
import 'package:cmu_sbnu_vms/data/models/qr_duty.dart';
import 'package:cmu_sbnu_vms/features/auth/auth_controller.dart';

import 'qr_duty_controller.dart';

/// QR code scanner screen for duty check-in/check-out.
class QRDutyScannerScreen extends StatefulWidget {
  const QRDutyScannerScreen({
    super.key,
    required this.controller,
    required this.sessionController,
    required this.authController,
    required this.sessionId,
    required this.action,
  });

  final QRDutyScannerController controller;
  final SessionController sessionController;
  final AuthController authController;
  final String sessionId;
  final QRDutyAction action;

  @override
  State<QRDutyScannerScreen> createState() => _QRDutyScannerScreenState();
}

class _QRDutyScannerScreenState extends State<QRDutyScannerScreen> {
  MobileScannerController? _scannerController;
  bool _flashOn = false;
  bool _scanned = false;

  @override
  void initState() {
    super.initState();
    _scannerController = MobileScannerController(
      detectionSpeed: DetectionSpeed.normal,
      facing: CameraFacing.back,
    );
  }

  @override
  void dispose() {
    _scannerController?.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_scanned) return;
    final barcode = capture.barcodes.firstOrNull;
    if (barcode?.rawValue == null) return;
    _scanned = true;
    _scannerController?.stop();
    _processScan(barcode!.rawValue!);
  }

  Future<void> _processScan(String rawToken) async {
    final success = await widget.controller.scan(
      sessionId: widget.sessionId,
      rawToken: rawToken,
      action: widget.action,
    );
    if (!mounted) return;
    if (success) {
      _showSuccessDialog();
    } else {
      // Error is already in controller state
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() => _scanned = false);
          _scannerController?.start();
        }
      });
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Color(0xFF2E7D4F), size: 28),
            const SizedBox(width: 12),
            const Text('Success'),
          ],
        ),
        content: Text(
          widget.controller.state.lastResult != null
              ? 'Scan recorded successfully!\n\nAction: ${widget.controller.state.lastResult!.action.wire}\nTime: ${widget.controller.state.lastResult!.serverTime.toLocal()}'
              : 'Scan recorded successfully!',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop(); // Go back to previous screen
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final compact = AppBreakpoints.isCompact(MediaQuery.sizeOf(context).width);
    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, _) => Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          surfaceTintColor: Colors.transparent,
          title: Text(
            widget.action == QRDutyAction.checkIn ? 'Check In' : 'Check Out',
            style: const TextStyle(color: Colors.white),
          ),
          leading: IconButton(
            icon: const Icon(Icons.close_rounded, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: [
            IconButton(
              icon: Icon(_flashOn ? Icons.flash_on_rounded : Icons.flash_off_rounded, color: Colors.white),
              onPressed: () {
                _flashOn = !_flashOn;
                _scannerController?.toggleTorch();
                setState(() {});
              },
            ),
          ],
        ),
        body: Stack(
          children: [
            MobileScanner(
              controller: _scannerController,
              onDetect: _onDetect,
            ),
            // Overlay with scanning frame
            Center(
              child: Container(
                width: compact ? 240 : 280,
                height: compact ? 240 : 280,
                decoration: BoxDecoration(
                  border: Border.all(color: AppTheme.seed, width: 3),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            // Instruction text at bottom
            Positioned(
              bottom: 80,
              left: 24,
              right: 24,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.black.withAlpha(200),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Align the QR code within the frame',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                  if (widget.controller.state.scanning) ...[
                    const SizedBox(height: 12),
                    const CircularProgressIndicator(color: AppTheme.seed),
                  ],
                  if (widget.controller.state.errorMessage != null) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFB3372C).withAlpha(200),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        widget.controller.state.errorMessage!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white, fontSize: 13),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}