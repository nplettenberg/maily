import 'package:enough_mail/enough_mail.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:maily/components/components.dart';

final mailClientProvider = FutureProvider<MailClient>((ref) async {
  final mailAccount = ref.watch(selectedAccountProvider);

  if (mailAccount == null) {
    throw Exception('No account selected!');
  }

  final accountCredentials = await ref.watch(
    accountCredentialsProvider(mailAccount).future,
  );

  final config = await Discover.discover(mailAccount.address);

  if (config != null) {
    final account = accountCredentials.when<MailAccount>(
      manual: (password, username) {
        return MailAccount.fromDiscoveredSettings(
          mailAccount.id,
          mailAccount.address,
          password,
          config,
        );
      },
      oauth: (token) {
        return MailAccount.fromDiscoveredSettingsWithAuth(
          mailAccount.id,
          mailAccount.address,
          OauthAuthentication(
            mailAccount.address,
            OauthToken(
              accessToken: token.accessToken,
              refreshToken: token.refreshToken,
              expiresIn: token.expiresIn,
              scope: token.scope,
              tokenType: token.tokenType,
            ),
          ),
          config,
        );
      },
    );

    final client = MailClient(
      account,
      isLogEnabled: kDebugMode,
      refresh: (client, expiredToken) async {
        if (mailAccount.accountType == AccountType.google) {
          return ref
              .watch(googleAuthFlowProvider)
              .refresh(OAuthToken.fromEnoughMail(expiredToken))
              .then((value) => value.toEnoughMail());
        }

        return null;
      },
    );

    await client.connect();

    return client;
  } else {
    throw Exception('Could not discover config for ${mailAccount.address}');
  }
});
