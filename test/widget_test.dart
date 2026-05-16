import 'package:flutter_test/flutter_test.dart';
import 'package:dentep_ca/main.dart';

void main() {
  testWidgets('App loads successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const TaskManagerApp());
    expect(find.text('My Tasks'), findsOneWidget);
  });
}
