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
    final reload = ref.read(causeListProvider.notifier).reload;

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
                  ErrorRetryView(error: error, onRetry: reload),
              data: (list) => list.isEmpty
                  ? const _EmptyResults()
                  : RefreshIndicator(
                      onRefresh: reload,
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

  final List<Cause> causes;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: AppTheme.pagePadding.copyWith(top: 8, bottom: 24),
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: causes.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final cause = causes[index];
        return CauseCard(
          cause: cause,
          onTap: () =>
              Navigator.of(context).push(CauseDetailScreen.route(cause)),
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
