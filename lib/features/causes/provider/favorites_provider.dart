import 'package:flutter_riverpod/flutter_riverpod.dart';

final favoritesProvider = NotifierProvider<FavoritesNotifier, Set<int>>(
  FavoritesNotifier.new,
);

class FavoritesNotifier extends Notifier<Set<int>> {
  @override
  Set<int> build() => const {};

  void toggle(int causeId) {
    state = state.contains(causeId)
        ? (state.toSet()..remove(causeId))
        : (state.toSet()..add(causeId));
  }
}

final isFavoriteProvider = Provider.family<bool, int>(
  (ref, causeId) => ref.watch(favoritesProvider).contains(causeId),
);
