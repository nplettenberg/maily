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
      const expectedAuthorizationCode = 'wow123';

      final expectedToken = OAuthToken(
        accessToken: 'token',
        expiresIn: 500,
        refreshToken: 'refreshToken',
        scope: 'scopes',
        tokenType: '',
      );

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

      when(
        () => authorizationService.showOAuthWebView(
          clientId: any(named: 'clientId'),
          redirectUrl: any(named: 'redirectUrl'),
          scopes: any(named: 'scopes'),
        ),
      ).thenAnswer((_) async => expectedAuthorizationCode);

      when(
        () => authenticationService.getOAuthToken(
          authorizationCode: any(named: 'authorizationCode'),
          callbackUrl: any(named: 'callbackUrl'),
        ),
      ).thenAnswer(
        (_) async => TokenResponse(
          profile: GoogleProfile(
            email: 'test@test.de',
          ),
          token: expectedToken,
        ),
      );

      final result =
          await container.read(googleAuthFlowProvider).requestFreshToken();

      expect(result.token, equals(expectedToken));
      expect(result.email, isNotEmpty);
      expect(result.email, equals('test@test.de'));

      verify(
        () => authorizationService.showOAuthWebView(
          clientId: 'test',
          redirectUrl: 'test:/',
          scopes: [
            kGmailScope,
            ...kOpenIdConnectScopes,
          ],
        ),
      );

      verify(
        () => authenticationService.getOAuthToken(
          authorizationCode: expectedAuthorizationCode,
          callbackUrl: 'test:/',
        ),
      );
    });
  });
}
