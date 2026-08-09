import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/util/string_x.dart';
import '../model/cause.dart';
import 'cause_image.dart';
import 'category_tag.dart';
import 'favorite_button.dart';

class CauseCard extends StatelessWidget {
  const CauseCard({super.key, required this.cause, this.onTap});

  final Cause cause;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CategoryTag(category: cause.category),
                    const SizedBox(height: 6),
                    Text(
                      cause.title.sentenceCase,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      cause.description.sentenceCase,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              FavoriteButton(causeId: cause.id),
            ],
          ),
        ),
      ),
    );
  }
}
