import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:maily/components/components.dart';

final routesProvider = Provider<List<GoRoute>>((_) {
  return [
    GoRoute(
      name: MailOverviewPage.name,
      path: '/mails',
      pageBuilder: (_, state) {
        return MaterialPage(
          key: state.pageKey,
          child: const MailOverviewPage(),
        );
      },
    ),
    GoRoute(
      name: AccountListPage.name,
      path: '/accounts',
      pageBuilder: (_, state) {
        return MaterialPage(
          key: state.pageKey,
          child: const AccountListPage(),
        );
      },
      routes: [
        GoRoute(
          name: AccountSetupPage.name,
          path: 'add',
          pageBuilder: (_, state) {
            return MaterialPage(
              key: state.pageKey,
              child: const AccountSetupPage(),
            );
          },
        ),
      ],
    ),
  ];
});
