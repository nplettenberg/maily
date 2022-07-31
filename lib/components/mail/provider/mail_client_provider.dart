import 'package:enough_mail/enough_mail.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:maily/components/components.dart';

final mailClientProvider = FutureProvider<MailClient>((ref) async {
  final log = Logger('mailClientProvider');

  final mailAccount = ref.watch(selectedAccountProvider);

  if (mailAccount == null) {
    throw Exception('No account selected!');
  }

  final accountCredentials = await ref.watch(
    accountCredentialsProvider(mailAccount).future,
  );

  log.info('Got credentials for ${mailAccount.address}: $accountCredentials');

  final config = await Discover.discover(mailAccount.address);

  if (config != null) {
    final account = accountCredentials.when<MailAccount>(
      manual: (password, _) {
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

    log.info('Discovered account $account');

    final client = MailClient(
      account,
      isLogEnabled: kDebugMode,
      logName: 'MailClient',
    );

    log.info('created client $client');

    if (!client.isConnected) {
      log.info('connecting client');
      await client.connect();
    }

    return client;
  } else {
    throw Exception('Could not discover config for ${mailAccount.address}');
  }
});
