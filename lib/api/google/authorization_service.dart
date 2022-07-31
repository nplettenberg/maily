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
}
