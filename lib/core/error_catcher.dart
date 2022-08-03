import 'dart:async';

import 'package:flutter/material.dart';
import 'package:maily/core/core.dart';

class ErrorCatcher with LoggerMixin {
  ErrorCatcher({
    required this.child,
  }) {
    _runGuarded();
  }

  final Widget child;

  void _runGuarded() {
    FlutterError.onError = (details) {
      log.severe('Caught flutter error!: $details');

      FlutterError.dumpErrorToConsole(details);
    };

    runZonedGuarded(
      () => runApp(child),
      (e, st) => log.severe('Uncaught exception!', e, st),
    );
  }
}
