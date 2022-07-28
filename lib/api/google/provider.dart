import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:maily/api/api.dart';
import 'package:maily/components/components.dart';

final googleAuthenticationServiceProvider =
    Provider<GoogleAuthenticationService>((ref) {
  return GoogleAuthenticationService(
    clientCredentials: ref.watch(environmentProvider).google,
  );
});

final googleAuthorizationServiceProvider = Provider<GoogleAuthorizationService>(
  (_) => const GoogleAuthorizationService(),
);
