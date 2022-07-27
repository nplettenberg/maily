import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:maily/components/components.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage();

  static const String name = 'splash';

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  @override
  void initState() {
    super.initState();
    ref.read(applicationProvider).boot();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
