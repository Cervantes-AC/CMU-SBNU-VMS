import 'package:flutter/material.dart';

class HotlineDirectoryPreviewDialog {
  const HotlineDirectoryPreviewDialog._();

  static Future<void> show(BuildContext context) => showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Hotline directory preview'),
      content: SizedBox(
        width: 460,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(context).height * .65,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFBF0D7),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Fictional examples only. No real contacts or phone numbers were supplied. These entries cannot place calls.',
                    style: TextStyle(
                      fontSize: 11,
                      height: 1.45,
                      color: Color(0xFF6E581F),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const _HotlinePreviewCard(
                  title: 'Example campus contact',
                  purpose: 'Illustrative campus safety contact',
                  status: 'NOT VERIFIED',
                  statusColor: Color(0xFF9A6810),
                  review:
                      'Verification owner and review date are not configured.',
                ),
                const _HotlinePreviewCard(
                  title: 'Example community contact',
                  purpose: 'Illustrative community support contact',
                  status: 'EXPIRED SAMPLE',
                  statusColor: Color(0xFF9E342B),
                  review:
                      'Demonstration of an expired entry; no actual number is stored.',
                ),
                const SizedBox(height: 4),
                const Text(
                  'A real entry needs an approved owner, source, service hours, geographic scope, accessibility notes, and a second authorized verifier. Unverified or expired contacts must remain non-callable.',
                  style: TextStyle(
                    fontSize: 11,
                    height: 1.45,
                    color: Color(0xFF748078),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ],
    ),
  );
}

class _HotlinePreviewCard extends StatelessWidget {
  const _HotlinePreviewCard({
    required this.title,
    required this.purpose,
    required this.status,
    required this.statusColor,
    required this.review,
  });

  final String title;
  final String purpose;
  final String status;
  final Color statusColor;
  final String review;

  @override
  Widget build(BuildContext context) => Card(
    margin: const EdgeInsets.only(bottom: 8),
    child: Padding(
      padding: const EdgeInsets.all(13),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.phone_disabled_outlined, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              Text(
                status,
                style: TextStyle(
                  color: statusColor,
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),
          Text(purpose, style: const TextStyle(fontSize: 11)),
          const SizedBox(height: 4),
          const Text(
            'Phone number: not supplied',
            style: TextStyle(fontSize: 11),
          ),
          const SizedBox(height: 4),
          Text(
            review,
            style: const TextStyle(
              fontSize: 10,
              height: 1.4,
              color: Color(0xFF748078),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Call action unavailable',
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    ),
  );
}
