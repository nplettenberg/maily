import 'package:flutter/material.dart';

class MailyCard extends StatelessWidget {
  const MailyCard({
    required this.child,
    this.gradient,
    this.onTap,
  });

  final Gradient? gradient;
  final VoidCallback? onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: theme.colorScheme.onSurface.withOpacity(.7),
        gradient: gradient,
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          child: child,
        ),
      ),
    );
  }
}
