import 'package:flutter/material.dart';
import 'package:maily/components/components.dart';

class MailContentPreview extends StatelessWidget {
  const MailContentPreview({
    required this.mailContent,
  });

  final MailContent mailContent;

  @override
  Widget build(BuildContext context) {
    return Text(
      mailContent.content,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}
