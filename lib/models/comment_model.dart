/**
 * CommentModel - Structure d'un message dans le fil de discussion d'un signalement.
 */
class CommentModel {
  final String? id;
  final String reportId;
  final String userId;
  final String content;
  final bool isAdmin;
  final DateTime createdAt;

  CommentModel({
    this.id,
    required this.reportId,
    required this.userId,
    required this.content,
    this.isAdmin = false,
    required this.createdAt,
  });

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      id: map['id']?.toString(),
      reportId: map['report_id']?.toString() ?? "",
      userId: map['user_id']?.toString() ?? "",
      content: map['content'] ?? "",
      isAdmin: map['is_admin'] ?? false,
      createdAt: DateTime.tryParse(map['created_at'] ?? "") ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'report_id': reportId,
      'user_id': userId,
      'content': content,
      'is_admin': isAdmin,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
