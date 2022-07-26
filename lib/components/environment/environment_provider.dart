import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'environment_provider.freezed.dart';

final environmentProvider = Provider<Environment>(
  (_) {
    return const Environment(
      google: OAuthClientCredentials(
        clientId: String.fromEnvironment('google_client_id'),
        clientSecret: String.fromEnvironment('google_client_secret'),
      ),
    );
  },
);

@freezed
class Environment with _$Environment {
  const factory Environment({
    required OAuthClientCredentials google,
  }) = _Environment;
}

@freezed
class OAuthClientCredentials with _$OAuthClientCredentials {
  const factory OAuthClientCredentials({
    required String clientId,
    required String clientSecret,
  }) = _OAuthClientCredentials;
}
