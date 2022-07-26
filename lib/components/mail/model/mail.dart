import 'package:freezed_annotation/freezed_annotation.dart';

part 'mail.freezed.dart';

@freezed
class Mail with _$Mail {
  factory Mail({
    required Sender sender,
    required String subject,
    required DateTime receivedAt,
    required bool seen,
    MailContent? content,
  }) = _Mail;
}

@freezed
class MailContent with _$MailContent {
  factory MailContent({
    required String content,
    String? contentType,
  }) = _MailContent;
}

@freezed
class Sender with _$Sender {
  factory Sender({
    required String address,
    String? clearName,
  }) = _Sender;
}
