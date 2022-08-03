import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:maily/components/components.dart';

class AccountListPage extends ConsumerWidget {
  const AccountListPage();

  static const String name = 'account_list';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accounts = ref.watch(accountListProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: const Text('Accounts'),
            actions: [
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () => context.goNamed(AccountSetupPage.name),
              )
            ],
          ),
          if (accounts.isEmpty)
            const SliverFillRemaining(
              child: Center(
                child: Text('No accounts added!'),
              ),
            ),
          if (accounts.isNotEmpty)
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  const SizedBox(height: 4),
                  ...accounts
                      .map<Widget>((p0) => AccountTile(account: p0))
                      .toList()
                ],
              ),
            ),
        ],
      ),
    );
  }
}
