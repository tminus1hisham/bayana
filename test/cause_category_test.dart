import 'package:bayana/features/causes/model/cause.dart';
import 'package:bayana/features/causes/model/cause_category.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CauseCategory.fromUserId', () {
    test('cycles the five categories over user ids 1 to 10', () {
      final mapped = [
        for (var userId = 1; userId <= 10; userId++)
          CauseCategory.fromUserId(userId),
      ];

      expect(mapped, [
        CauseCategory.health,
        CauseCategory.education,
        CauseCategory.emergency,
        CauseCategory.environment,
        CauseCategory.empowerment,
        CauseCategory.health,
        CauseCategory.education,
        CauseCategory.emergency,
        CauseCategory.environment,
        CauseCategory.empowerment,
      ]);
    });

    test('stays in range for ids beyond the documented set', () {
      expect(CauseCategory.fromUserId(11), CauseCategory.health);
      expect(CauseCategory.fromUserId(0), CauseCategory.empowerment);
    });
  });

  group('Cause.fromJson', () {
    test('maps title, body and id and derives category and image', () {
      final cause = Cause.fromJson(const {
        'userId': 2,
        'id': 7,
        'title': ' clean water for schools ',
        'body': ' a borehole for two villages ',
      });

      expect(cause.id, 7);
      expect(cause.title, 'clean water for schools');
      expect(cause.description, 'a borehole for two villages');
      expect(cause.category, CauseCategory.education);
      expect(cause.imageUrl, 'https://picsum.photos/seed/7/400/300');
    });
  });
}
