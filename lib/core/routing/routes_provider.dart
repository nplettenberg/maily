import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:maily/components/components.dart';

final routesProvider = Provider<List<GoRoute>>((ref) {
  return [
    GoRoute(
      name: SplashPage.name,
      path: '/splash',
      pageBuilder: (_, state) {
        return MaterialPage(
          key: state.pageKey,
          child: const SplashPage(),
        );
      },
    ),
    GoRoute(
        name: MailOverviewPage.name,
        path: '/mails',
        pageBuilder: (_, state) {
          return MaterialPage(
            key: state.pageKey,
            child: const MailOverviewPage(),
          );
        },
        routes: [
          GoRoute(
            name: AccountListPage.name,
            path: 'accounts',
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
                routes: [
                  GoRoute(
                    name: OAuthPage.name,
                    path: 'oauth/:provider',
                    pageBuilder: (_, state) {
                      final providerName = state.params['provider'];
                      final provider = ref.read(oAuthProvider(providerName));

                      return MaterialPage(
                        key: state.pageKey,
                        child: OAuthPage(
                          provider: provider,
                        ),
                      );
                    },
                  )
                ],
              ),
            ],
          ),
        ]),
  ];
});
