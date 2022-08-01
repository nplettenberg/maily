import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maily/api/google/provider.dart';
import 'package:maily/components/components.dart';

import '../../../setup/mocks.dart';

void main() {
  group('authorize', () {
    test('should set valid OAuthState.authorization on construction', () {
      final accountListNotifier = MockAccountListNotifier();
      final googleAuthenticationService = MockAuthenticationService();

      final container = ProviderContainer(
        overrides: [
          environmentProvider.overrideWithValue(
            const Environment(
              google: OAuthClientCredentials(
                clientId: 'test',
                clientSecret: 'test123',
              ),
            ),
          ),
          accountListProvider.overrideWithValue(accountListNotifier),
          googleAuthenticationServiceProvider
              .overrideWithValue(googleAuthenticationService),
        ],
      );

      addTearDown(container.dispose);

      final actualState = container.read(googleOAuthProvider);

      const expectedState = OAuthState.authorization(
        redirectUrl: 'test:/',
        authorizationUrl:
            'https://accounts.google.com/o/oauth2/v2/auth?response_type=code'
            '&client_id=test&redirect_uri=test%3A%2F'
            '&scope=https%3A%2F%2Fmail.google.com%2F+openid+profile+email',
      );

      expect(actualState, equals(expectedState));
    });
  });
}
