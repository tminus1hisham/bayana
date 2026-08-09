import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../provider/cause_providers.dart';
import '../widget/cause_card.dart';

class CauseListScreen extends ConsumerWidget {
  const CauseListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final causes = ref.watch(causeListProvider).value ?? const [];

    return Scaffold(
      appBar: AppBar(title: const Text('Cause Explorer')),
      body: ListView.separated(
        padding: AppTheme.pagePadding.copyWith(top: 8, bottom: 24),
        itemCount: causes.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (context, index) => CauseCard(cause: causes[index]),
      ),
    );
  }
}
