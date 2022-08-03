import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:maily/core/core.dart';

class MailyApp extends ConsumerWidget {
  const MailyApp();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      routeInformationProvider: router.routeInformationProvider,
      routeInformationParser: router.routeInformationParser,
      routerDelegate: router.routerDelegate,
      themeMode: ThemeMode.dark,
      theme: ThemeData.light().copyWith(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.deepOrange,
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.deepOrange,
        ),
      ),
    );
  }
}
