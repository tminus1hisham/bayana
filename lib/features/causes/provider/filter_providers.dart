import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/cause.dart';
import '../model/cause_category.dart';
import 'cause_providers.dart';
import 'favorites_provider.dart';

final searchQueryProvider = NotifierProvider<SearchQueryNotifier, String>(
  SearchQueryNotifier.new,
);

class SearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';

  void update(String value) => state = value;

  void clear() => state = '';
}

final selectedCategoryProvider =
    NotifierProvider<SelectedCategoryNotifier, CauseCategory?>(
      SelectedCategoryNotifier.new,
    );

class SelectedCategoryNotifier extends Notifier<CauseCategory?> {
  @override
  CauseCategory? build() => null;

  void select(CauseCategory? category) => state = category;
}

final showFavoritesOnlyProvider =
    NotifierProvider<ShowFavoritesOnlyNotifier, bool>(
      ShowFavoritesOnlyNotifier.new,
    );

class ShowFavoritesOnlyNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void update(bool value) => state = value;
}

final filteredCausesProvider = Provider<AsyncValue<List<Cause>>>((ref) {
  final causes = ref.watch(causeListProvider);
  final query = ref.watch(searchQueryProvider).trim().toLowerCase();
  final category = ref.watch(selectedCategoryProvider);
  final favoritesOnly = ref.watch(showFavoritesOnlyProvider);
  final favorites = ref.watch(favoritesProvider);

  return causes.whenData((list) {
    return list.where((cause) {
      final matchesQuery =
          query.isEmpty || cause.title.toLowerCase().contains(query);
      final matchesCategory = category == null || cause.category == category;
      final matchesFavorites = !favoritesOnly || favorites.contains(cause.id);
      return matchesQuery && matchesCategory && matchesFavorites;
    }).toList(growable: false);
  });
});
