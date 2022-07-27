import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:maily/components/components.dart';
import 'package:maily/core/core.dart';

final applicationProvider = Provider<Application>(
  (ref) => Application(reader: ref.read),
);

class Application {
  const Application({
    required Reader reader,
  }) : _reader = reader;

  final Reader _reader;

  Future<void> boot() async {
    setupLogger();

    await Future.delayed(const Duration(milliseconds: 100));

    _reader(applicationStateProvider.notifier).state =
        ApplicationState.initialized;

    _reader(routerProvider).goNamed(MailOverviewPage.name);
  }
}
