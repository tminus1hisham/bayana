import 'cause_category.dart';

class Cause {
  const Cause({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.category,
  });

  factory Cause.fromJson(Map<String, dynamic> json) {
    final userId = json['userId'] as int;
    return Cause(
      id: json['id'] as int,
      userId: userId,
      title: (json['title'] as String).trim(),
      description: (json['body'] as String).trim(),
      category: CauseCategory.fromUserId(userId),
    );
  }

  final int id;
  final int userId;
  final String title;
  final String description;
  final CauseCategory category;

  String get imageUrl => 'https://picsum.photos/seed/$id/400/300';

  @override
  bool operator ==(Object other) => other is Cause && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
