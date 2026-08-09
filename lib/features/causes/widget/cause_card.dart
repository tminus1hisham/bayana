import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/util/string_x.dart';
import '../model/cause.dart';
import 'cause_image.dart';
import 'category_tag.dart';
import 'favorite_button.dart';
import 'rounded_backdrop.dart';

class CauseCard extends StatelessWidget {
  const CauseCard({super.key, required this.cause, this.onTap});

  final Cause cause;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 4, 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(AppTheme.imageRadius),
                child: SizedBox.square(
                  dimension: 96,
                  child: CauseImage(cause: cause),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _CauseSummary(cause: cause, titleMaxLines: 2),
              ),
              FavoriteButton(causeId: cause.id),
            ],
          ),
        ),
      ),
    );
  }
}

class CauseGridCard extends StatelessWidget {
  const CauseGridCard({super.key, required this.cause, this.onTap});

  final Cause cause;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: CauseImage(cause: cause),
                ),
                Positioned(
                  top: 4,
                  right: 4,
                  child: RoundedBackdrop(
                    child: FavoriteButton(causeId: cause.id),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: _CauseSummary(cause: cause, titleMaxLines: 2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CauseSummary extends StatelessWidget {
  const _CauseSummary({required this.cause, required this.titleMaxLines});

  final Cause cause;
  final int titleMaxLines;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        CategoryTag(category: cause.category),
        const SizedBox(height: 6),
        Text(
          cause.title.sentenceCase,
          maxLines: titleMaxLines,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
            height: 1.25,
          ),
        ),
        const SizedBox(height: 4),
        Flexible(
          child: Text(
            cause.description.sentenceCase,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }
}
