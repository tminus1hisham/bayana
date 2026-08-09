import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../model/cause_category.dart';
import '../provider/filter_providers.dart';

class CategoryChips extends ConsumerWidget {
  const CategoryChips({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(selectedCategoryProvider);
    final notifier = ref.read(selectedCategoryProvider.notifier);

    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: AppTheme.pagePadding,
        itemCount: CauseCategory.values.length + 1,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          if (index == 0) {
            return ChoiceChip(
              label: const Text('All'),
              selected: selected == null,
              onSelected: (_) => notifier.select(null),
            );
          }

          final category = CauseCategory.values[index - 1];
          return ChoiceChip(
            label: Text(category.label),
            selected: selected == category,
            onSelected: (isSelected) =>
                notifier.select(isSelected ? category : null),
          );
        },
      ),
    );
  }
}
