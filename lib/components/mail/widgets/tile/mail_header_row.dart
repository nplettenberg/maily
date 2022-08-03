import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:maily/components/components.dart';

class MailHeaderRow extends StatelessWidget {
  const MailHeaderRow({
    required this.mail,
  });

  final Mail mail;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: Text.rich(
            TextSpan(
              children: [
                if (mail.sender.clearName != null) ...[
                  TextSpan(
                    text: mail.sender.clearName!,
                  ),
                  const TextSpan(text: ' <'),
                ],
                TextSpan(
                  text: mail.sender.address,
                  style: theme.textTheme.labelMedium,
                ),
                if (mail.sender.clearName != null) const TextSpan(text: '>'),
              ],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const Expanded(child: SizedBox()),
        MailHeaderDate(date: mail.receivedAt)
      ],
    );
  }
}

class MailHeaderDate extends StatelessWidget {
  const MailHeaderDate({
    required this.date,
  });

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat(DateFormat.ABBR_MONTH_WEEKDAY_DAY);

    return Text(dateFormat.format(date));
  }
}
