import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:maily/components/components.dart';

final mailInboxProvider = FutureProvider.family<List<Mail>, Account?>(
  (ref, account) async {
    final log = Logger('mailInboxProvider');

    final client = await ref.watch(mailClientProvider(account).future);

    log.info('Using $client to handle inbox');

    await client.selectInbox();

    return await client.fetchMessages(count: 25).then((mimeMessages) {
      return mimeMessages.map((mimeMessage) {
        return Mail(
          sender: Sender(
            address: mimeMessage.fromEmail ?? 'No sender...',
            clearName: mimeMessage.from?.first.personalName,
          ),
          content: MailContent(
            content: (mimeMessage.isTextPlainMessage()
                    ? mimeMessage.decodeTextPlainPart()
                    : mimeMessage.decodeTextHtmlPart()) ??
                '',
            contentType: mimeMessage.getHeaderContentType()?.mediaType.text,
          ),
          subject: mimeMessage.decodeSubject() ?? 'No subject...',
          receivedAt: mimeMessage.decodeDate() ?? DateTime.now(),
          seen: mimeMessage.isSeen,
        );
      }).toList();
    });
  },
);
