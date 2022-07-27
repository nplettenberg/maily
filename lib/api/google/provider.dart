import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:maily/api/api.dart';
import 'package:maily/components/components.dart';

final googleAuthenticationServiceProvider =
    Provider<AuthenticationService>((ref) {
  return AuthenticationService(
    clientCredentials: ref.watch(environmentProvider).google,
  );
});

final googleAuthorizationServiceProvider = Provider<AuthorizationService>(
  (_) => const AuthorizationService(),
);
