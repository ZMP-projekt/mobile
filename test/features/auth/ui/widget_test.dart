import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_gym_app/features/auth/ui/login_page.dart';

void main() {
  testWidgets('Login page visibility test', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: LoginPage(),
    ));

    expect(find.textContaining('Gotowy na trening'), findsOneWidget);

    expect(find.text('ZALOGUJ SIĘ'), findsOneWidget);
    
    expect(find.byType(TextField), findsNWidgets(2));
  });
}