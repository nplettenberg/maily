import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:maily/components/components.dart';

class OAuthApproval extends StatelessWidget {
  const OAuthApproval({
    required this.result,
    required this.notifier,
  });

  final OAuthFlowResult result;
  final OAuthStateNotifier notifier;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Welcome'),
          const SizedBox(height: 8),
          Text(
            result.email,
            style: theme.textTheme.bodyLarge,
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                child: const Text('Dismiss'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              ElevatedButton(
                child: const Text('Add'),
                onPressed: () {
                  notifier.saveAccount(result);
                  context.goNamed(AccountListPage.name);
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
