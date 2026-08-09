import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../model/cause.dart';
import '../provider/cause_providers.dart';
import '../widget/cause_card.dart';
import '../widget/state_views.dart';

class CauseListScreen extends ConsumerWidget {
  const CauseListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final causes = ref.watch(causeListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Cause Explorer')),
      body: causes.when(
        loading: LoadingView.new,
        error: (error, _) => ErrorRetryView(
          error: error,
          onRetry: ref.read(causeListProvider.notifier).reload,
        ),
        data: (list) => RefreshIndicator(
          onRefresh: ref.read(causeListProvider.notifier).reload,
          child: _CauseList(list),
        ),
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
      itemBuilder: (context, index) => CauseCard(cause: causes[index]),
    );
  }
}
