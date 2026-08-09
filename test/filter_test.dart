import 'package:bayana/features/causes/data/cause_repository.dart';
import 'package:bayana/features/causes/model/cause.dart';
import 'package:bayana/features/causes/model/cause_category.dart';
import 'package:bayana/features/causes/provider/cause_providers.dart';
import 'package:bayana/features/causes/provider/favorites_provider.dart';
import 'package:bayana/features/causes/provider/filter_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeCauseRepository implements CauseRepository {
  const FakeCauseRepository(this.causes);

  final List<Cause> causes;

  @override
  Future<List<Cause>> getCauses() async => causes;
}

Cause _cause(int id, String title, CauseCategory category) => Cause(
  id: id,
  userId: id,
  title: title,
  description: 'description $id',
  category: category,
);

final _fixtures = [
  _cause(1, 'Clean water for schools', CauseCategory.health),
  _cause(2, 'School books drive', CauseCategory.education),
  _cause(3, 'Flood relief fund', CauseCategory.emergency),
];

void main() {
  late ProviderContainer container;

  setUp(() async {
    container = ProviderContainer(
      overrides: [
        causeRepositoryProvider.overrideWithValue(
          FakeCauseRepository(_fixtures),
        ),
      ],
    );
    await container.read(causeListProvider.future);
  });

  tearDown(() => container.dispose());

  List<Cause> filtered() => container.read(filteredCausesProvider).value ?? [];

  test('returns every cause with no filters applied', () {
    expect(filtered().length, 3);
  });

  test('search matches titles case insensitively', () {
    container.read(searchQueryProvider.notifier).update('SCHOOL');

    expect(filtered().map((cause) => cause.id), [1, 2]);
  });

  test('category filter narrows to one category', () {
    container.read(selectedCategoryProvider.notifier).select(
      CauseCategory.emergency,
    );

    expect(filtered().single.id, 3);
  });

  test('favorites only keeps saved causes', () {
    container.read(favoritesProvider.notifier).toggle(2);
    container.read(showFavoritesOnlyProvider.notifier).update(true);

    expect(filtered().single.id, 2);
  });

  test('search and category combine', () {
    container.read(searchQueryProvider.notifier).update('school');
    container.read(selectedCategoryProvider.notifier).select(
      CauseCategory.education,
    );

    expect(filtered().single.id, 2);
  });

  test('returns nothing when filters match no cause', () {
    container.read(searchQueryProvider.notifier).update('bicycles');

    expect(filtered(), isEmpty);
  });
}
