import 'package:flutter/material.dart';
import 'package:maily/components/components.dart';

class MailSubjectRow extends StatelessWidget {
  const MailSubjectRow({
    required this.mail,
  });

  final Mail mail;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: Text(
            mail.subject,
            style: theme.textTheme.labelLarge,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        //TODO: Flag if mail has attachments,
      ],
    );
  }
}
