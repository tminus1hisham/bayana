import 'package:flutter/material.dart';

class RoundedBackdrop extends StatelessWidget {
  const RoundedBackdrop({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.75),
        shape: BoxShape.circle,
      ),
      child: child,
    );
  }
}
