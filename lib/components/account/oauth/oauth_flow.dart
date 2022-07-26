import 'package:enough_mail/enough_mail.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:maily/core/core.dart';

part 'oauth_flow.freezed.dart';
part 'oauth_flow.g.dart';

abstract class OAuthFlow with LoggerMixin {
  const OAuthFlow({
    required this.appClientId,
    required this.appClientSecret,
  });

  final String appClientId;
  final String appClientSecret;

  Future<OAuthToken> authenticate({
    String? email,
  }) async {
    try {
      final token = await requestFreshToken(email: email);

      if (token == null) {
        throw Exception('Could not retrieve a new OAuthToken');
      }

      return token;
    } catch (e, st) {
      log.severe('Could not get a fresh token!', e, st);
      rethrow;
    }
  }

  Future<OAuthToken> refresh(
    OAuthToken token,
  ) async {
    try {
      final refreshedToken = await refreshToken(token);

      if (refreshedToken == null) {
        throw Exception('Could not retrieve a refreshed OAuthToken');
      }

      return refreshedToken;
    } catch (e, st) {
      log.severe('Could refresh token!', e, st);
      rethrow;
    }
  }

  @protected
  Future<OAuthToken?> requestFreshToken({String? email});

  @protected
  Future<OAuthToken?> refreshToken(OAuthToken token);
}

@freezed
class OAuthToken with _$OAuthToken {
  factory OAuthToken({
    required String accessToken,
    required String refreshToken,
    required String tokenType,
    required String scope,
    required int expiresIn,
  }) = _OAuthToken;

  factory OAuthToken.fromJson(Map<String, dynamic> json) =>
      _$OAuthTokenFromJson(json);

  factory OAuthToken.fromEnoughMail(OauthToken token) {
    return OAuthToken(
      accessToken: token.accessToken,
      refreshToken: token.refreshToken,
      tokenType: token.tokenType,
      scope: token.scope,
      expiresIn: token.expiresIn,
    );
  }

  OAuthToken._();

  OauthToken toEnoughMail() {
    return OauthToken(
      accessToken: accessToken,
      refreshToken: refreshToken,
      tokenType: tokenType,
      scope: scope,
      expiresIn: expiresIn,
    );
  }
}
