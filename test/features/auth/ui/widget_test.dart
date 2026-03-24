import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mobile_gym_app/main.dart';
import 'package:mobile_gym_app/features/auth/providers/auth_provider.dart';
import 'package:mobile_gym_app/features/auth/data/auth_repository.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {

  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
  });

  testWidgets('Login page visibility test', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [

          authRepositoryProvider.overrideWithValue(mockAuthRepository),
        ],
        child: const MaterialApp(
          home: Scaffold(body: AuthGate()),
        ),
      ),
    );

    expect(find.textContaining('Witaj ponownie'), findsOneWidget);
    expect(find.text('Zaloguj się'), findsOneWidget);

    expect(find.byType(TextField), findsNWidgets(2));

    await tester.pumpAndSettle();
  });
}