import 'package:flutter_web_auth/flutter_web_auth.dart';

const String kGmailScope = 'https://mail.google.com/';

const List<String> kOpenIdConnectScopes = [
  'openid',
  'profile',
  'email',
];

class GoogleAuthorizationService {
  const GoogleAuthorizationService();

  Uri buildAuthorizationUrl({
    required String clientId,
    required String redirectUrl,
    required List<String> scopes,
    String? loginHint,
  }) {
    return Uri.https(
      'accounts.google.com',
      '/o/oauth2/v2/auth',
      {
        'response_type': 'code',
        'client_id': clientId,
        'redirect_uri': redirectUrl,
        'scope': scopes.join(' '),
        if (loginHint != null) 'login_hint': loginHint,
      },
    );
  }

  /// TODO refactor when FlutterWebAuth plugin is removed
  Future<String> showOAuthWebView({
    required String clientId,
    required String redirectUrl,
    required List<String> scopes,
    String? loginHint,
  }) async {
    final authResult = await FlutterWebAuth.authenticate(
      callbackUrlScheme: redirectUrl,
      url: buildAuthorizationUrl(
        clientId: clientId,
        redirectUrl: redirectUrl,
        scopes: scopes,
      ).toString(),
    );

    final String? authCode = Uri.parse(authResult).queryParameters['code'];

    if (authCode == null) {
      throw Exception(
        'Could not get an authorization code from web view result',
      );
    }

    return authCode;
  }
}
