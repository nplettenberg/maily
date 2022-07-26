// ignore_for_file: avoid_print

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';

mixin LoggerMixin {
  Logger get log => Logger('$runtimeType');
}

void setupLogger() {
  if (kReleaseMode) return;

  Logger.root.level = Level.ALL;

  const separator = ' | ';
  const horizontalSeparator = '--------------------------------';

  Logger.root.onRecord.listen((rec) {
    final content = [
      DateFormat('HH:mm:s.S').format(DateTime.now()),
      separator,
      rec.level.name.padRight(7),
      separator,
      if (rec.loggerName.isNotEmpty) ...[
        rec.loggerName.padRight(22),
        separator,
      ],
      rec.message,
    ];

    final color = _colorForLevel(rec.level);

    print(color(content.join()));

    if (rec.error != null) {
      print(color(horizontalSeparator));
      print(color('ERROR'));

      if (rec.error is Response) {
        print(color((rec.error! as Response).body));
      } else {
        print(color(rec.error.toString()));
      }

      print(color(horizontalSeparator));

      if (rec.stackTrace != null) {
        print(color('STACK TRACE'));
        for (final line in rec.stackTrace.toString().trim().split('\n')) {
          print(color(line));
        }
        print(color(horizontalSeparator));
      }
    }
  });
}

final _levelColors = {
  Level.FINEST: AnsiColor.fg(AnsiColor.grey(0.5)),
  Level.FINER: AnsiColor.fg(AnsiColor.grey(0.5)),
  Level.FINE: AnsiColor.fg(AnsiColor.grey(0.5)),
  Level.CONFIG: AnsiColor.fg(12),
  Level.INFO: AnsiColor.fg(12),
  Level.WARNING: AnsiColor.fg(208),
  Level.SEVERE: AnsiColor.fg(196),
  Level.SHOUT: AnsiColor.fg(199),
};

AnsiColor _colorForLevel(Level level) {
  return _levelColors[level] ?? AnsiColor.none();
}

/// Copied and modified from https://github.com/leisim/logger.
///
/// This class handles colorizing of terminal output.
class AnsiColor {
  AnsiColor.none()
      : fg = null,
        bg = null,
        color = false;

  AnsiColor.fg(this.fg)
      : bg = null,
        color = true;

  AnsiColor.bg(this.bg)
      : fg = null,
        color = true;

  /// ANSI Control Sequence Introducer, signals the terminal for new settings.
  static const ansiEsc = '\x1B[';

  /// Reset all colors and options for current SGRs to terminal defaults.
  static const ansiDefault = '${ansiEsc}0m';

  final int? fg;
  final int? bg;
  final bool color;

  @override
  String toString() {
    if (fg != null) {
      return '${ansiEsc}38;5;${fg}m';
    } else if (bg != null) {
      return '${ansiEsc}48;5;${bg}m';
    } else {
      return '';
    }
  }

  String call(String msg) {
    if (color) {
      return '${this}$msg$ansiDefault';
    } else {
      return msg;
    }
  }

  AnsiColor toFg() => AnsiColor.fg(bg);

  AnsiColor toBg() => AnsiColor.bg(fg);

  /// Defaults the terminal's foreground color without altering the background.
  String get resetForeground => color ? '${ansiEsc}39m' : '';

  /// Defaults the terminal's background color without altering the foreground.
  String get resetBackground => color ? '${ansiEsc}49m' : '';

  static int grey(double level) => 232 + (level.clamp(0.0, 1.0) * 23).round();
}
