import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:maily/components/components.dart';

part 'oauth_provider.freezed.dart';

final oAuthProvider = Provider.family(
  (ref, accountType) {
    switch (accountType) {
      case AccountType.google:
      default:
        return googleOAuthProvider;
    }
  },
);

@freezed
class OAuthState with _$OAuthState {
  const factory OAuthState.initializing() = _Initializing;

  const factory OAuthState.authorization({
    required String redirectUrl,
    required String authorizationUrl,
  }) = _Authorization;

  const factory OAuthState.authentication({
    required String authorizationCode,
  }) = _Authentication;

  const factory OAuthState.result({
    required OAuthFlowResult result,
  }) = _Result;
}

abstract class OAuthStateNotifier extends StateNotifier<OAuthState> {
  OAuthStateNotifier({
    required this.credentials,
    required AccountListNotifier accountListNotifier,
  })  : _accountListNotifier = accountListNotifier,
        super(const OAuthState.initializing()) {
    authorize();
  }

  final AccountListNotifier _accountListNotifier;
  final OAuthClientCredentials credentials;

  AccountType get accountType;

  Future<void> authorize();

  Future<void> authenticate(String authorizationCallback);

  @protected
  Future<OAuthToken> refreshToken({
    required OAuthToken token,
  });

  /// Requests a fresh token and stores it into credentials storage
  Future<OAuthToken> refresh({
    required OAuthToken token,
    required Account account,
  }) async {
    final newToken = await refreshToken(token: token);

    await _accountListNotifier.update(
      account,
      AccountCredentials.oauth(token: newToken),
    );

    return newToken;
  }

  Future<void> saveAccount(OAuthFlowResult result) {
    return _accountListNotifier.add(
      Account(
        id: Random().nextInt(100000).toString(),
        address: result.email,
        accountType: accountType,
      ),
      AccountCredentials.oauth(token: result.token),
    );
  }
}
