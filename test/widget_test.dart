import 'package:flutter_test/flutter_test.dart';
import 'package:style/app.dart';

void main() {
  testWidgets('App dummy test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const StyleApp());
  });
}
