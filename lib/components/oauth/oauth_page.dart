import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:maily/components/oauth/provider/oauth_provider.dart';
import 'package:maily/components/oauth/widgets/oauth_approval.dart';
import 'package:maily/components/oauth/widgets/oauth_web_view.dart';

class OAuthPage extends ConsumerWidget {
  const OAuthPage({
    required this.provider,
  });

  static const String name = 'oauth';

  final AutoDisposeStateNotifierProvider<OAuthStateNotifier, OAuthState>
      provider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(provider);
    final notifier = ref.watch(provider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('OAuth'),
      ),
      body: state.when<Widget>(
        initializing: () => const Center(child: CircularProgressIndicator()),
        authentication: (_) => const Center(child: CircularProgressIndicator()),
        authorization: (redirectUrl, authorizationUrl) => OAuthWebView(
          authorizationUrl: authorizationUrl,
          redirectUrl: redirectUrl,
          onSuccess: notifier.authenticate,
        ),
        result: (result) => OAuthApproval(
          result: result,
          notifier: notifier,
        ),
      ),
    );
  }
}
