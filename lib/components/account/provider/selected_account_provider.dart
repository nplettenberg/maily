import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:maily/components/components.dart';

final selectedAccountProvider = StateProvider<Account?>(
  (ref) {
    final accounts = ref.watch(accountListProvider);

    if (accounts.isNotEmpty) {
      // Improve: make default account configurable.
      return accounts.first;
    } else {
      return null;
    }
  },
);
