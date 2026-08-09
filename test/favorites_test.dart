import 'package:bayana/features/causes/provider/favorites_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late ProviderContainer container;

  setUp(() => container = ProviderContainer());
  tearDown(() => container.dispose());

  test('starts empty', () {
    expect(container.read(favoritesProvider), isEmpty);
  });

  test('toggle adds then removes a cause id', () {
    final notifier = container.read(favoritesProvider.notifier);

    notifier.toggle(3);
    expect(container.read(favoritesProvider), {3});

    notifier.toggle(3);
    expect(container.read(favoritesProvider), isEmpty);
  });

  test('emits a new set so listeners are notified', () {
    final notifier = container.read(favoritesProvider.notifier);
    final before = container.read(favoritesProvider);

    notifier.toggle(1);

    expect(identical(before, container.read(favoritesProvider)), isFalse);
  });

  test('isFavorite tracks only its own id', () {
    container.read(favoritesProvider.notifier).toggle(5);

    expect(container.read(isFavoriteProvider(5)), isTrue);
    expect(container.read(isFavoriteProvider(6)), isFalse);
  });
}
