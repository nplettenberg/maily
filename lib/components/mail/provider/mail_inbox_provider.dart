import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:maily/components/components.dart';

final mailInboxProvider = FutureProvider<List<Mail>>((ref) async {
  final client = await ref.watch(mailClientProvider.future);

  await client.selectInbox();

  return await client.fetchMessages(count: 25).then((mimeMessages) {
    return mimeMessages.map((mimeMessage) {
      return Mail(
        sender: Sender(
          address: mimeMessage.fromEmail ?? 'No sender...',
          clearName: mimeMessage.from?.first.personalName,
        ),
        content: MailContent(
          content: mimeMessage.renderMessage(renderHeader: false),
          contentType: mimeMessage.getHeaderContentType()?.mediaType.text,
        ),
        subject: mimeMessage.decodeSubject() ?? 'No subject...',
        receivedAt: mimeMessage.decodeDate() ?? DateTime.now(),
        seen: mimeMessage.isSeen,
      );
    }).toList();
  });
});
