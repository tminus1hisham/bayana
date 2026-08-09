import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../model/cause.dart';
import '../provider/cause_providers.dart';
import '../provider/favorites_provider.dart';
import '../provider/filter_providers.dart';
import '../widget/category_chips.dart';
import '../widget/cause_card.dart';
import '../widget/scope_switcher.dart';
import '../widget/search_field.dart';
import '../widget/state_views.dart';
import 'cause_detail_screen.dart';

class CauseListScreen extends ConsumerWidget {
  const CauseListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final causes = ref.watch(filteredCausesProvider);
    final notifier = ref.read(causeListProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Cause Explorer')),
      body: Column(
        children: [
          const Padding(
            padding: AppTheme.pagePadding,
            child: Column(
              children: [
                SearchField(),
                SizedBox(height: 12),
                ScopeSwitcher(),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const CategoryChips(),
          const SizedBox(height: 4),
          Expanded(
            child: causes.when(
              loading: LoadingView.new,
              error: (error, _) =>
                  ErrorRetryView(error: error, onRetry: notifier.retry),
              data: (list) => list.isEmpty
                  ? const _EmptyResults()
                  : RefreshIndicator(
                      onRefresh: notifier.refresh,
                      child: _CauseList(list),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CauseList extends StatelessWidget {
  const _CauseList(this.causes);

  static const _gridBreakpoint = 600.0;
  static const _spacing = 12.0;

  final List<Cause> causes;

  void _open(BuildContext context, Cause cause) {
    Navigator.of(context).push(CauseDetailScreen.route(cause));
  }

  @override
  Widget build(BuildContext context) {
    final padding = AppTheme.pagePadding.copyWith(top: 8, bottom: 24);

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < _gridBreakpoint) {
          return ListView.separated(
            padding: padding,
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: causes.length,
            separatorBuilder: (_, _) => const SizedBox(height: _spacing),
            itemBuilder: (context, index) => CauseCard(
              cause: causes[index],
              onTap: () => _open(context, causes[index]),
            ),
          );
        }

        final columns = switch (constraints.maxWidth) {
          >= 1200 => 4,
          >= 900 => 3,
          _ => 2,
        };
        final tileWidth =
            (constraints.maxWidth -
                padding.horizontal -
                _spacing * (columns - 1)) /
            columns;

        return GridView.builder(
          padding: padding,
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: causes.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: _spacing,
            mainAxisSpacing: _spacing,
            mainAxisExtent: tileWidth * 9 / 16 + 140,
          ),
          itemBuilder: (context, index) => CauseGridCard(
            cause: causes[index],
            onTap: () => _open(context, causes[index]),
          ),
        );
      },
    );
  }
}

class _EmptyResults extends ConsumerWidget {
  const _EmptyResults();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritesOnly = ref.watch(showFavoritesOnlyProvider);
    final hasFavorites = ref.watch(favoritesProvider).isNotEmpty;

    if (favoritesOnly && !hasFavorites) {
      return const EmptyView(
        icon: Icons.favorite_border,
        title: 'No favorites yet',
        message: 'Tap the heart on a cause to save it here.',
      );
    }

    return const EmptyView(
      title: 'No causes found',
      message: 'Try a different search term or category.',
    );
  }
}
