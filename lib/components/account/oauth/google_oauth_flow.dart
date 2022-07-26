import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:http/http.dart' as http;
import 'package:maily/components/components.dart';
import 'package:maily/core/core.dart';

final googleAuthFlowProvider = Provider<GoogleOAuthFlow>(
  (ref) {
    final env = ref.watch(environmentProvider);

    return GoogleOAuthFlow(
      appClientId: env.google.clientId,
      appClientSecret: env.google.clientSecret,
    );
  },
);

class GoogleOAuthFlow extends OAuthFlow with LoggerMixin {
  GoogleOAuthFlow({
    required super.appClientId,
    required super.appClientSecret,
  });

  @override
  Future<OAuthToken?> requestFreshToken({
    String? email,
  }) async {
    final callbackUrlScheme = appClientId.split('.').reversed.join('.');

    final authRequest = Uri.https(
      'accounts.google.com',
      '/o/oauth2/v2/auth',
      {
        'response_type': 'code',
        'client_id': appClientId,
        'redirect_uri': '$callbackUrlScheme:/',
        'scope': 'https://mail.google.com/',
        if (email != null) 'login_hint': email,
      },
    );

    log.info(authRequest.toString());

    final authResult = await FlutterWebAuth.authenticate(
      url: authRequest.toString(),
      callbackUrlScheme: callbackUrlScheme,
    );

    final String? authCode = Uri.parse(authResult).queryParameters['code'];

    if (authCode == null) {
      throw Exception('Could not retrieve auth code for google auth');
    }

    final tokenResponse = await http.post(
      Uri.https('oauth2.googleapis.com', '/token'),
      body: {
        'client_id': appClientId,
        'client_secret': appClientSecret,
        'redirect_uri': '$callbackUrlScheme:/',
        'grant_type': 'authorization_code',
        'code': authCode,
      },
    );

    final tokenJson = jsonDecode(tokenResponse.body);

    return OAuthToken(
      accessToken: tokenJson['access_token'],
      refreshToken: tokenJson['refresh_token'],
      tokenType: tokenJson['token_type'],
      scope: tokenJson['scope'],
      expiresIn: tokenJson['expires_in'],
    );
  }

  @override
  Future<OAuthToken?> refreshToken(OAuthToken token) async {
    final callbackUrlScheme = appClientId.split('.').reversed.join('.');

    final response = await http.post(
      Uri.https('oauth2.googleapis.com', '/token'),
      body: {
        'client_id': appClientId,
        'client_secret': appClientSecret,
        'redirect_url': '$callbackUrlScheme:/',
        'grant_type': 'refresh_token',
        'refresh_token': token.refreshToken,
      },
    );

    final tokenJson = jsonDecode(response.body);

    return OAuthToken(
      accessToken: tokenJson['access_token'],
      refreshToken: tokenJson['refresh_token'],
      tokenType: tokenJson['token_type'],
      scope: tokenJson['scope'],
      expiresIn: tokenJson['expires_in'],
    );
  }
}
