import 'package:bayana/core/network/api_exception.dart';
import 'package:bayana/features/causes/data/cause_repository.dart';
import 'package:bayana/features/causes/model/cause.dart';
import 'package:bayana/features/causes/model/cause_category.dart';
import 'package:bayana/features/causes/provider/cause_providers.dart';
import 'package:bayana/features/causes/view/cause_list_screen.dart';
import 'package:bayana/features/causes/widget/cause_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeCauseRepository implements CauseRepository {
  const FakeCauseRepository(this.causes);

  final List<Cause> causes;

  @override
  Future<List<Cause>> getCauses() async => causes;
}

class FlakyCauseRepository implements CauseRepository {
  FlakyCauseRepository(this.causes);

  final List<Cause> causes;
  bool shouldFail = true;

  @override
  Future<List<Cause>> getCauses() async {
    if (shouldFail) {
      shouldFail = false;
      throw const ApiException('No internet connection.');
    }
    return causes;
  }
}

final _fixtures = [
  for (var id = 1; id <= 6; id++)
    Cause(
      id: id,
      userId: id,
      title: 'cause number $id with a fairly long title to wrap onto two lines',
      description: 'a description that is long enough to need clipping $id',
      category: CauseCategory.fromUserId(id),
    ),
];

Future<void> _pumpScreen(
  WidgetTester tester, {
  Size size = const Size(400, 900),
  CauseRepository? repository,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        causeRepositoryProvider.overrideWithValue(
          repository ?? FakeCauseRepository(_fixtures),
        ),
      ],
      child: const MaterialApp(home: CauseListScreen()),
    ),
  );
}

void main() {
  testWidgets('shows a spinner before the causes arrive', (tester) async {
    await _pumpScreen(tester);

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('lays out row cards on a narrow screen', (tester) async {
    await _pumpScreen(tester);
    await tester.pumpAndSettle();

    expect(find.byType(CauseCard), findsWidgets);
    expect(find.byType(CauseGridCard), findsNothing);
  });

  testWidgets('lays out grid cards on a wide screen', (tester) async {
    await _pumpScreen(tester, size: const Size(1000, 900));
    await tester.pumpAndSettle();

    expect(find.byType(CauseGridCard), findsWidgets);
    expect(find.byType(CauseCard), findsNothing);
  });

  testWidgets('recovers from an error when retry is tapped', (tester) async {
    await _pumpScreen(tester, repository: FlakyCauseRepository(_fixtures));
    await tester.pumpAndSettle();

    expect(find.text('No internet connection.'), findsOneWidget);

    await tester.tap(find.text('Try again'));
    await tester.pumpAndSettle();

    expect(find.byType(CauseCard), findsWidgets);
  });

  testWidgets('shows an empty state when the search matches nothing', (
    tester,
  ) async {
    await _pumpScreen(tester);
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'nothing matches this');
    await tester.pumpAndSettle();

    expect(find.text('No causes found'), findsOneWidget);
  });

  testWidgets('favorite toggles from the card and drives the tab', (
    tester,
  ) async {
    await _pumpScreen(tester);
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.favorite_border).first);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Favorites'));
    await tester.pumpAndSettle();

    expect(find.byType(CauseCard), findsOneWidget);
  });

  testWidgets('favorites tab is empty until something is saved', (
    tester,
  ) async {
    await _pumpScreen(tester);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Favorites'));
    await tester.pumpAndSettle();

    expect(find.text('No favorites yet'), findsOneWidget);
  });
}
