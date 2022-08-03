import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:maily/components/components.dart';

final selectedAccountProvider = StateProvider<Account?>(
  (ref) {
    final log = Logger('selectedAccountProvider');

    final accounts = ref.watch(accountListProvider);

    if (accounts.isNotEmpty) {
      log
        ..info('Returning first account as current account')
        ..info('Account: ${accounts.first}');
      // Improve: make default account configurable.
      return accounts.first;
    } else {
      log.info('No accounts configured. Returning null');
      return null;
    }
  },
);
