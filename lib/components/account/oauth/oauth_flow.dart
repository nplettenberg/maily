// ignore_for_file: invalid_annotation_target

import 'package:enough_mail/enough_mail.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:maily/components/components.dart';
import 'package:maily/core/core.dart';

part 'oauth_flow.freezed.dart';
part 'oauth_flow.g.dart';

abstract class OAuthFlow with LoggerMixin {
  const OAuthFlow({
    required this.credentials,
  });

  final OAuthClientCredentials credentials;

  Future<OAuthFlowResult> authenticate({
    String? email,
  }) async {
    try {
      return requestFreshToken(email: email);
    } catch (e, st) {
      log.severe('Could not get a fresh token!', e, st);
      rethrow;
    }
  }

  Future<OAuthToken> refresh(
    OAuthToken token,
  ) async {
    try {
      return refreshToken(token);
    } catch (e, st) {
      log.severe('Could refresh token!', e, st);
      rethrow;
    }
  }

  @protected
  @visibleForTesting
  Future<OAuthFlowResult> requestFreshToken({String? email});

  @protected
  @visibleForTesting
  Future<OAuthToken> refreshToken(OAuthToken token);

  @protected
  String get callbackUrl;
}

@freezed
class OAuthFlowResult with _$OAuthFlowResult {
  factory OAuthFlowResult({
    required String email,
    required OAuthToken token,
  }) = _OAuthFlowResult;
}

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
