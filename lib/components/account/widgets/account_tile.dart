import 'package:flutter/material.dart';
import 'package:maily/components/components.dart';

class AccountTile extends StatelessWidget {
  const AccountTile({
    required this.account,
  });

  final Account account;

  Widget _buildSubtitle() {
    switch (account.accountType) {
      case AccountType.google:
        return const Text('Google account');
      default:
        return const SizedBox();
    }
  }

  Widget _buildLeading(ThemeData theme) {
    switch (account.accountType) {
      case AccountType.google:
        return const GoogleMailLogo();
      default:
        return const DefaultMailLogo();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MailyCard(
      child: ListTile(
        leading: Padding(
          padding: const EdgeInsets.all(8),
          child: _buildLeading(theme),
        ),
        title: Text(account.address),
        subtitle: _buildSubtitle(),
      ),
    );
  }
}

class DefaultMailLogo extends StatelessWidget {
  const DefaultMailLogo();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Icon(
      Icons.mail_outlined,
      size: 40,
      color: theme.colorScheme.onPrimaryContainer,
    );
  }
}

class GoogleMailLogo extends StatelessWidget {
  const GoogleMailLogo();

  @override
  Widget build(BuildContext context) {
    return Image.asset('assets/logo/gmail.png');
  }
}
