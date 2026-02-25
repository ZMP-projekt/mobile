import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_gym_app/main.dart';

void main() {
  testWidgets('Login page visibility test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.textContaining('Witaj'), findsOneWidget);
    expect(find.textContaining('Gotowy na trening'), findsOneWidget);

    expect(find.text('ZALOGUJ SIĘ'), findsOneWidget);
  });
}