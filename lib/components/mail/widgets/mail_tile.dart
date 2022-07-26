import 'package:flutter/material.dart';
import 'package:maily/components/components.dart';

class MailTile extends StatelessWidget {
  const MailTile({
    required this.mail,
    this.onTap,
  });

  final Mail mail;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MailyCard(
      onTap: onTap,
      gradient: mail.seen
          ? null
          : LinearGradient(
              colors: [
                theme.colorScheme.primary,
                theme.colorScheme.primary.withOpacity(.5),
                Colors.transparent,
              ],
              begin: Alignment.bottomLeft,
              end: Alignment.bottomRight,
            ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MailHeaderRow(mail: mail),
          const SizedBox(height: 8),
          MailSubjectRow(mail: mail),
          const SizedBox(height: 8),
          if (mail.content != null) ...[
            MailContentPreview(mailContent: mail.content!),
            const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }
}
