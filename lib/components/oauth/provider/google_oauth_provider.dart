import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:maily/api/api.dart';
import 'package:maily/components/components.dart';
import 'package:maily/core/core.dart';

final googleOAuthProvider =
    StateNotifierProvider.autoDispose<OAuthStateNotifier, OAuthState>(
  (ref) {
    return GoogleOAuthProvider(
      credentials: ref.watch(environmentProvider).google,
      accountListNotifier: ref.watch(accountListProvider.notifier),
      authenticationService: ref.watch(googleAuthenticationServiceProvider),
      authorizationService: ref.watch(googleAuthorizationServiceProvider),
    );
  },
);

class GoogleOAuthProvider extends OAuthStateNotifier with LoggerMixin {
  GoogleOAuthProvider({
    required OAuthClientCredentials credentials,
    required AccountListNotifier accountListNotifier,
    required GoogleAuthenticationService authenticationService,
    required GoogleAuthorizationService authorizationService,
  })  : _authenticationService = authenticationService,
        _authorizationService = authorizationService,
        super(
          credentials: credentials,
          accountListNotifier: accountListNotifier,
        );

  final GoogleAuthenticationService _authenticationService;
  final GoogleAuthorizationService _authorizationService;

  @override
  Future<void> authorize() async {
    log.info('Start authorize');

    state = OAuthState.authorization(
      redirectUrl: callbackUrl.toString(),
      authorizationUrl: _authorizationService.buildAuthorizationUrl(
        clientId: credentials.clientId,
        redirectUrl: callbackUrl,
        scopes: [
          kGmailScope,
          ...kOpenIdConnectScopes,
        ],
      ).toString(),
    );
  }

  @override
  Future<void> authenticate(String authorizationCallback) async {
    log.info('Received authorizationCallback: $authorizationCallback');

    final authorizationCode =
        Uri.parse(authorizationCallback).queryParameters['code'];

    log.info('Start authentication with authorizatioCode $authorizationCode');

    if (authorizationCode != null) {
      state = OAuthState.authentication(
        authorizationCode: authorizationCode,
      );

      final response = await _authenticationService.getOAuthToken(
        authorizationCode: authorizationCode,
        callbackUrl: callbackUrl,
      );

      log.info('Got auth response $response');

      if (response.profile == null) {
        log.warning('''
          Got no profile information with OAuth2 token!
          This can lead to errors to later point of time.
          This should never happen!
        ''');
      }

      state = OAuthState.result(
        result: OAuthFlowResult(
          email: response.profile!.email,
          token: response.token,
        ),
      );
    } else {
      //TODO error
    }
  }

  String get callbackUrl =>
      '${credentials.clientId.split('.').reversed.join('.')}:/';

  @override
  AccountType get accountType => AccountType.google;
}
