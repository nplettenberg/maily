import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:maily/components/components.dart';

part 'authentication_service.freezed.dart';
part 'authentication_service.g.dart';

class GoogleAuthenticationService {
  const GoogleAuthenticationService({
    required OAuthClientCredentials clientCredentials,
  }) : _clientCredentials = clientCredentials;

  final OAuthClientCredentials _clientCredentials;

  Future<TokenResponse> getOAuthToken({
    required String authorizationCode,
    required String callbackUrl,
  }) {
    return http.post(
      Uri.https('oauth2.googleapis.com', '/token'),
      body: {
        'client_id': _clientCredentials.clientId,
        'client_secret': _clientCredentials.clientSecret,
        'redirect_uri': callbackUrl,
        'grant_type': 'authorization_code',
        'code': authorizationCode,
      },
    ).then(
      (value) {
        final response = jsonDecode(value.body);

        final result = TokenResponse(
          token: OAuthToken.fromJson(response),
        );

        if (response['id_token'] != null) {
          return result.copyWith(
            profile: GoogleProfile.fromJson(
              JwtDecoder.decode(response['id_token']),
            ),
          );
        }

        return result;
      },
    );
  }

  Future<OAuthToken> refreshOAuthToken({
    required String refreshToken,
    required String callbackUrl,
  }) async {
    final response = await http.post(
      Uri.https('oauth2.googleapis.com', '/token'),
      body: {
        'client_id': _clientCredentials.clientId,
        'client_secret': _clientCredentials.clientSecret,
        'redirect_url': callbackUrl,
        'grant_type': 'refresh_token',
        'refresh_token': refreshToken,
      },
    );

    return OAuthToken.fromJson(jsonDecode(response.body));
  }
}

@freezed
class TokenResponse with _$TokenResponse {
  factory TokenResponse({
    required OAuthToken token,
    GoogleProfile? profile,
  }) = _TokenResponse;
}

// TODO add missing attributes
@freezed
class GoogleProfile with _$GoogleProfile {
  factory GoogleProfile({
    required String email,
  }) = _GoogleProfile;

  factory GoogleProfile.fromJson(Map<String, dynamic> json) =>
      _$GoogleProfileFromJson(json);
}
