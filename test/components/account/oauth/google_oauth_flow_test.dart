import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maily/api/api.dart';
import 'package:maily/components/components.dart';
import 'package:mocktail/mocktail.dart';

import '../../../setup/mocks.dart';

void main() {
  group('callbackUrl', () {
    test('should end with :/', () {
      final flow = GoogleOAuthFlow(
        credentials: const OAuthClientCredentials(
          clientId: 'wow',
          clientSecret: '1234',
        ),
        authenticationService: MockAuthenticationService(),
        authorizationService: MockAuthorizationService(),
      );

      expect(flow.callbackUrl, endsWith(':/'));
    });

    test('should be revesed by . separator', () {
      const expectedResult = 'wow3.wow2.wow1';

      final flow = GoogleOAuthFlow(
        credentials: const OAuthClientCredentials(
          clientId: 'wow1.wow2.wow3',
          clientSecret: '1234',
        ),
        authenticationService: MockAuthenticationService(),
        authorizationService: MockAuthorizationService(),
      );

      expect(flow.callbackUrl, startsWith(expectedResult));
    });
  });

  group('requestFreshToken', () {
    test('should get oauth token', () async {
      const credentials = OAuthClientCredentials(
        clientId: 'test',
        clientSecret: 'veryWow',
      );

      final authenticationService = MockAuthenticationService();
      final authorizationService = MockAuthorizationService();

      final container = ProviderContainer(overrides: [
        environmentProvider.overrideWithValue(
          const Environment(google: credentials),
        ),
        googleAuthenticationServiceProvider
            .overrideWithValue(authenticationService),
        googleAuthorizationServiceProvider
            .overrideWithValue(authorizationService),
      ]);

      addTearDown(container.dispose);

      await container.read(googleAuthFlowProvider).requestFreshToken();

      verify(
        () => authorizationService.showOAuthWebView(
          callbackUrl: '',
          clientId: '',
          redirectUrl: '',
          scopes: [],
        ),
      );
    });
  });
}
