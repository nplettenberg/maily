import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:maily/components/components.dart';
import 'package:maily/core/core.dart';

final accountCredentialsProvider =
    FutureProvider.family<AccountCredentials, Account>(
  (ref, account) async {
    final secureStorage = ref.watch(secureStorageProvider);

    final storedCredentials = await secureStorage.read(key: account.id);

    if (storedCredentials == null) {
      throw Exception('Could not read credentials for "${account.id}"');
    } else {
      return AccountCredentials.fromJson(jsonDecode(storedCredentials));
    }
  },
);
