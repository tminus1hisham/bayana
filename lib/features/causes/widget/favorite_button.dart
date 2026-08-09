import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/favorites_provider.dart';

class FavoriteButton extends ConsumerWidget {
  const FavoriteButton({super.key, required this.causeId});

  final int causeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFavorite = ref.watch(isFavoriteProvider(causeId));

    return IconButton(
      onPressed: () => ref.read(favoritesProvider.notifier).toggle(causeId),
      tooltip: isFavorite ? 'Remove from favorites' : 'Save to favorites',
      icon: Icon(
        isFavorite ? Icons.favorite : Icons.favorite_border,
        color: isFavorite ? Theme.of(context).colorScheme.error : null,
      ),
    );
  }
}
