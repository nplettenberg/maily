import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class OAuthWebView extends StatelessWidget {
  const OAuthWebView({
    required this.authorizationUrl,
    required this.redirectUrl,
    required this.onSuccess,
  });

  final String authorizationUrl;
  final String redirectUrl;
  final ValueChanged<String> onSuccess;

  @override
  Widget build(BuildContext context) {
    return WebView(
      userAgent: 'maily',
      initialUrl: authorizationUrl,
      javascriptMode: JavascriptMode.unrestricted,
      gestureRecognizers: {Factory(() => EagerGestureRecognizer())},
      navigationDelegate: (navigation) {
        if (navigation.url.startsWith(redirectUrl)) {
          onSuccess(navigation.url);
          return NavigationDecision.prevent;
        }

        return NavigationDecision.navigate;
      },
    );
  }
}
