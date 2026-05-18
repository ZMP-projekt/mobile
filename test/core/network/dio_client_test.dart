import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:mobile_gym_app/core/auth/auth_token_store.dart';
import 'package:mobile_gym_app/core/network/dio_client.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthTokenStore extends Mock implements AuthTokenStore {}

void main() {
  late MockAuthTokenStore tokenStore;
  late ProviderContainer container;
  late Dio dio;
  late DioAdapter dioAdapter;

  setUp(() {
    tokenStore = MockAuthTokenStore();
    when(() => tokenStore.read()).thenAnswer((_) async => 'jwt-token');
    when(() => tokenStore.clear()).thenAnswer((_) async {});

    container = ProviderContainer(
      overrides: [authTokenStoreProvider.overrideWithValue(tokenStore)],
    );
    addTearDown(container.dispose);

    dio = container.read(dioProvider);
    dioAdapter = DioAdapter(dio: dio);
  });

  test('clears stored token on 401 responses', () async {
    dioAdapter.onGet('/api/protected', (server) {
      server.reply(401, {'message': 'Unauthorized'});
    });

    await expectLater(dio.get('/api/protected'), throwsA(isA<DioException>()));

    verify(() => tokenStore.clear()).called(1);
  });

  test('does not clear stored token on 403 domain errors', () async {
    dioAdapter.onGet('/api/classes/138/participants', (server) {
      server.reply(403, {'message': 'Forbidden'});
    });

    await expectLater(
      dio.get('/api/classes/138/participants'),
      throwsA(isA<DioException>()),
    );

    verifyNever(() => tokenStore.clear());
  });
}
