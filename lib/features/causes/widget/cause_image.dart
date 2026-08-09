import 'package:flutter/material.dart';

import '../model/cause.dart';

class CauseImage extends StatelessWidget {
  const CauseImage({super.key, required this.cause, this.fit = BoxFit.cover});

  final Cause cause;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Hero(
      tag: 'cause-image-${cause.id}',
      child: Image.network(
        cause.imageUrl,
        fit: fit,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return ColoredBox(
            color: scheme.surfaceContainerHighest,
            child: const Center(
              child: SizedBox.square(
                dimension: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) => ColoredBox(
          color: scheme.surfaceContainerHighest,
          child: Icon(
            Icons.image_not_supported_outlined,
            color: scheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
