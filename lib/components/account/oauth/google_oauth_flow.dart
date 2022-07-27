import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:maily/api/api.dart';
import 'package:maily/components/components.dart';
import 'package:maily/core/core.dart';

final googleAuthFlowProvider = Provider<GoogleOAuthFlow>(
  (ref) {
    return GoogleOAuthFlow(
      credentials: ref.watch(environmentProvider).google,
      authenticationService: ref.watch(googleAuthenticationServiceProvider),
      authorizationService: ref.watch(googleAuthorizationServiceProvider),
    );
  },
);

class GoogleOAuthFlow extends OAuthFlow with LoggerMixin {
  GoogleOAuthFlow({
    required super.credentials,
    required AuthenticationService authenticationService,
    required AuthorizationService authorizationService,
  })  : _authenticationService = authenticationService,
        _authorizationService = authorizationService;

  final AuthenticationService _authenticationService;
  final AuthorizationService _authorizationService;

  @override
  Future<OAuthFlowResult> requestFreshToken({
    String? email,
  }) async {
    log.info('Handle google OAuth authorization');

    final authCode = await _authorizationService.showOAuthWebView(
      clientId: credentials.clientId,
      redirectUrl: callbackUrl,
      scopes: [
        kGmailScope,
        ...kOpenIdConnectScopes,
      ],
    );

    log.info('Got authorization code :$authCode');

    log.info('Requesting OAuth2 Token for google API');

    final response = await _authenticationService.getOAuthToken(
      authorizationCode: authCode,
      callbackUrl: callbackUrl,
    );

    if (response.profile == null) {
      log.warning('''
        Got no profile information with OAuth2 token!
        This can lead to errors to later point of time.
        This should never happen!
      ''');
    }

    return OAuthFlowResult(
      email: response.profile!.email,
      token: response.token,
    );
  }

  @override
  Future<OAuthToken> refreshToken(OAuthToken token) async {
    return _authenticationService.refreshOAuthToken(
      refreshToken: token.refreshToken,
      callbackUrl: callbackUrl,
    );
  }

  @override
  String get callbackUrl =>
      '${credentials.clientId.split('.').reversed.join('.')}:/';
}
