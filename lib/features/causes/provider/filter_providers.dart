import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/cause.dart';
import '../model/cause_category.dart';
import 'cause_providers.dart';

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

final filteredCausesProvider = Provider<AsyncValue<List<Cause>>>((ref) {
  final causes = ref.watch(causeListProvider);
  final query = ref.watch(searchQueryProvider).trim().toLowerCase();
  final category = ref.watch(selectedCategoryProvider);

  return causes.whenData((list) {
    return list.where((cause) {
      final matchesQuery =
          query.isEmpty || cause.title.toLowerCase().contains(query);
      final matchesCategory = category == null || cause.category == category;
      return matchesQuery && matchesCategory;
    }).toList(growable: false);
  });
});
