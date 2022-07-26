import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:maily/components/components.dart';

part 'account.freezed.dart';
part 'account.g.dart';

enum AccountType {
  google,
}

@freezed
class Account with _$Account {
  factory Account({
    required String id,
    required String address,
    required AccountType accountType,
    String? displayName,
    String? description,
  }) = _Account;

  factory Account.fromJson(Map<String, dynamic> json) =>
      _$AccountFromJson(json);
}

@freezed
class AccountConnections with _$AccountConnections {
  factory AccountConnections({
    required Connection incoming,
    required Connection outgoing,
  }) = _AccountConnections;
}

@freezed
class Connection with _$Connection {
  factory Connection({
    required String hostname,
    required int port,
  }) = _Connection;
}

@freezed
class AccountCredentials with _$AccountCredentials {
  factory AccountCredentials.manual({
    required String password,
    String? username,
  }) = _ManualAccountCredentials;

  factory AccountCredentials.oauth({
    required OAuthToken token,
  }) = _OAuthCredentials;

  factory AccountCredentials.fromJson(Map<String, dynamic> json) =>
      _$AccountCredentialsFromJson(json);
}
