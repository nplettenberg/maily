import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:maily/components/components.dart';

class MailOverviewPage extends ConsumerWidget {
  const MailOverviewPage();

  static const String name = 'mail_overview';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mails = ref.watch(mailInboxProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            title: Text('Maily'),
          ),
          mails.when<Widget>(
              loading: () => const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  ),
              error: (e, st) => SliverFillRemaining(
                    child: Center(child: Text('$e')),
                  ),
              data: (mails) {
                return SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      const SizedBox(height: 4),
                      for (final mail in mails) MailTile(mail: mail),
                    ],
                  ),
                );
              }),
        ],
      ),
    );
  }
}
