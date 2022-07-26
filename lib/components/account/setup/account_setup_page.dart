import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:maily/components/components.dart';

class AccountSetupPage extends ConsumerWidget {
  const AccountSetupPage();

  static const String name = 'account_setup';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            title: Text('New account'),
          ),
          SliverToBoxAdapter(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  MailyCard(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: const [
                          Text('GMail'),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          SliverFillRemaining(
            child: Center(
              child: ElevatedButton(
                child: const Text('Sign in with google!'),
                onPressed: () async {
                  final token =
                      await ref.watch(googleAuthFlowProvider).authenticate();

                  ref.watch(accountListProvider.notifier).add(
                        Account(
                          id: '123',
                          address: 'test@gmail.com',
                          accountType: AccountType.google,
                        ),
                        AccountCredentials.oauth(token: token),
                      );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
