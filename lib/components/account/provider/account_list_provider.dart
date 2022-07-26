import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:maily/components/components.dart';
import 'package:maily/core/core.dart';
import 'package:shared_preferences/shared_preferences.dart';

final accountListProvider =
    StateNotifierProvider<AccountListNotifier, BuiltList<Account>>(
  (ref) {
    return AccountListNotifier(
      preferences: ref.watch(storageProvider),
      secureStorage: ref.watch(secureStorageProvider),
    );
  },
);

class AccountListNotifier extends StateNotifier<BuiltList<Account>> {
  AccountListNotifier({
    required SharedPreferences preferences,
    required FlutterSecureStorage secureStorage,
  })  : _preferences = preferences,
        _secureStorage = secureStorage,
        super(<Account>[].toBuiltList()) {
    _load();
  }

  final SharedPreferences _preferences;
  final FlutterSecureStorage _secureStorage;

  void _load() {
    final accounts = _preferences.getStringList('accounts') ?? [];

    state = state.rebuild(
      (p0) => p0.addAll(
        accounts.map(
          (e) => Account.fromJson(jsonDecode(e)),
        ),
      ),
    );
  }

  Future<void> add(Account account, AccountCredentials credentials) async {
    final accounts = <String>[
      ..._preferences.getStringList('accounts') ?? [],
      jsonEncode(account),
    ];

    await _preferences.setStringList('accounts', accounts);

    await _secureStorage.write(
      key: account.id,
      value: jsonEncode(credentials),
    );

    state = accounts
        .map<Account>((e) => Account.fromJson(jsonDecode(e)))
        .toBuiltList();
  }

  void remove(Account account) {}
}
