import 'package:flutter_test/flutter_test.dart';
import 'package:cmu_sbnu_vms/app.dart';

void main() {
  testWidgets('app opens the local landing preview', (tester) async {
    await tester.pumpWidget(const NSRCApp());

    expect(find.text('A clearer view of volunteer work.'), findsOneWidget);
    expect(find.text('PREVIEW'), findsOneWidget);
    expect(
      find.text(
        'Concept only. Sign-in, member records, and public services are not connected.',
      ),
      findsOneWidget,
    );
  });
}
