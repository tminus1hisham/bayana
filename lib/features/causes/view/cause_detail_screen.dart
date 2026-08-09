import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/util/string_x.dart';
import '../model/cause.dart';
import '../widget/cause_image.dart';
import '../widget/category_tag.dart';
import '../widget/favorite_button.dart';
import '../widget/rounded_backdrop.dart';

class CauseDetailScreen extends StatelessWidget {
  const CauseDetailScreen({super.key, required this.cause});

  static Route<void> route(Cause cause) {
    return MaterialPageRoute(
      builder: (_) => CauseDetailScreen(cause: cause),
    );
  }

  final Cause cause;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: RoundedBackdrop(
                  child: FavoriteButton(causeId: cause.id),
                ),
              ),
            ],
            leading: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: RoundedBackdrop(
                child: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  tooltip: 'Back',
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: CauseImage(cause: cause),
            ),
          ),
          SliverPadding(
            padding: AppTheme.pagePadding.copyWith(top: 20, bottom: 40),
            sliver: SliverList.list(
              children: [
                CategoryTag(category: cause.category),
                const SizedBox(height: 12),
                Text(
                  cause.title.sentenceCase,
                  style: textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  cause.description.sentenceCase,
                  style: textTheme.bodyLarge?.copyWith(height: 1.6),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
