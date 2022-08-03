// ignore_for_file: invalid_annotation_target

import 'package:enough_mail/enough_mail.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'oauth_token.freezed.dart';
part 'oauth_token.g.dart';

@freezed
class OAuthToken with _$OAuthToken {
  factory OAuthToken({
    @JsonKey(name: 'access_token') required String accessToken,
    @JsonKey(name: 'refresh_token') required String refreshToken,
    @JsonKey(name: 'token_type') required String tokenType,
    @JsonKey(name: 'scope') required String scope,
    @JsonKey(name: 'expires_in') required int expiresIn,
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
