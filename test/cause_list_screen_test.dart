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

Future<void> _pumpScreen(WidgetTester tester, Size size) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        causeRepositoryProvider.overrideWithValue(
          FakeCauseRepository(_fixtures),
        ),
      ],
      child: const MaterialApp(home: CauseListScreen()),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('shows a spinner before the causes arrive', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          causeRepositoryProvider.overrideWithValue(
            FakeCauseRepository(_fixtures),
          ),
        ],
        child: const MaterialApp(home: CauseListScreen()),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('lays out row cards on a narrow screen', (tester) async {
    await _pumpScreen(tester, const Size(400, 900));

    expect(find.byType(CauseCard), findsWidgets);
    expect(find.byType(CauseGridCard), findsNothing);
  });

  testWidgets('lays out grid cards on a wide screen', (tester) async {
    await _pumpScreen(tester, const Size(1000, 900));

    expect(find.byType(CauseGridCard), findsWidgets);
    expect(find.byType(CauseCard), findsNothing);
  });

  testWidgets('shows an empty state when the search matches nothing', (
    tester,
  ) async {
    await _pumpScreen(tester, const Size(400, 900));

    await tester.enterText(find.byType(TextField), 'nothing matches this');
    await tester.pumpAndSettle();

    expect(find.text('No causes found'), findsOneWidget);
  });
}
