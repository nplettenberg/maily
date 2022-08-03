import 'package:enough_mail/enough_mail.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:maily/components/components.dart';

final mailClientProvider =
    FutureProvider.family<MailClient, Account?>((ref, mailAccount) async {
  final log = Logger('mailClientProvider');

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
        log.info('Persisted token expired: ${token.toEnoughMail().isExpired}');

        return MailAccount.fromDiscoveredSettingsWithAuth(
          mailAccount.id,
          mailAccount.address,
          OauthAuthentication(
            mailAccount.address,
            token.toEnoughMail(),
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
      refresh: (client, expiredToken) async {
        log.info('refreshing token');
        final providerRef = ref.read(oAuthProvider(mailAccount.accountType));
        final provider = ref.read(providerRef.notifier);

        final newToken = await provider.refresh(
          token: OAuthToken.fromEnoughMail(expiredToken),
          account: mailAccount,
        );

        log.info('refreshed token $newToken');

        return newToken.toEnoughMail();
      },
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
