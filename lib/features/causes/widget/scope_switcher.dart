import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/filter_providers.dart';

class ScopeSwitcher extends ConsumerWidget {
  const ScopeSwitcher({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritesOnly = ref.watch(showFavoritesOnlyProvider);

    return SegmentedButton<bool>(
      showSelectedIcon: false,
      segments: const [
        ButtonSegment(
          value: false,
          label: Text('All causes'),
          icon: Icon(Icons.grid_view_rounded, size: 18),
        ),
        ButtonSegment(
          value: true,
          label: Text('Favorites'),
          icon: Icon(Icons.favorite, size: 18),
        ),
      ],
      selected: {favoritesOnly},
      onSelectionChanged: (selection) =>
          ref.read(showFavoritesOnlyProvider.notifier).update(selection.first),
    );
  }
}
