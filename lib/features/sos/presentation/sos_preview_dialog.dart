import 'package:flutter/material.dart';

class SosPreviewDialog {
  const SosPreviewDialog._();

  static Future<void> show(BuildContext context) {
    var showNotSent = false;
    return showDialog<void>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          icon: Icon(
            showNotSent ? Icons.block_outlined : Icons.warning_amber_rounded,
            color: const Color(0xFFB63D34),
            size: 40,
          ),
          title: Text(
            showNotSent ? 'NOT SENT · demonstration' : 'SOS is not connected',
          ),
          content: SizedBox(
            width: 420,
            child: showNotSent
                ? const Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'This is a simulated UI state. No server alert, responder notification, emergency call, or location collection occurred.',
                        style: TextStyle(height: 1.45),
                      ),
                      SizedBox(height: 14),
                      Text(
                        'No verified hotline numbers are configured. For immediate help, follow institution procedures and contact local emergency services directly.',
                        style: TextStyle(
                          fontSize: 12,
                          height: 1.45,
                          color: Color(0xFF6E581F),
                        ),
                      ),
                    ],
                  )
                : const Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'The project has no approved responder roster or alert service. This demonstration cannot send an SOS.',
                        style: TextStyle(height: 1.45),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'No location is requested or collected. The next screen only previews the not-sent message.',
                        style: TextStyle(
                          fontSize: 12,
                          height: 1.45,
                          color: Color(0xFF748078),
                        ),
                      ),
                    ],
                  ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(showNotSent ? 'Close' : 'Cancel'),
            ),
            if (!showNotSent)
              FilledButton(
                onPressed: () => setDialogState(() => showNotSent = true),
                child: const Text('Preview not-sent screen'),
              ),
          ],
        ),
      ),
    );
  }
}
