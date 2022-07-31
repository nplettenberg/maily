// ignore_for_file: avoid_print

import 'package:logging/logging.dart';

mixin LoggerMixin {
  Logger get log => Logger('$runtimeType');
}

void setupLogger({
  String? prefix,
  String separator = ' | ',
  String horizontalSeparator = '--------------------------------',
}) {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen(
    (LogRecord rec) {
      final List<String> content = <String>[
        if (prefix != null) ...<String>[
          prefix,
          separator,
        ],
        rec.level.name.padRight(7),
        separator,
        rec.loggerName.padRight(22),
        separator,
        rec.message,
      ];

      print(content.join());

      if (rec.error != null) {
        print(horizontalSeparator);
        print('ERROR');
        print(rec.error.toString());
        print(horizontalSeparator);

        if (rec.stackTrace != null) {
          print('STACK TRACE');
          rec.stackTrace.toString().trim().split('\n').forEach(print);
          print(horizontalSeparator);
        }
      }
    },
  );
}
