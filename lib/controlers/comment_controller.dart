import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/comment_model.dart';

/**
 * CommentController - Logique métier pour les échanges (chat) sur un signalement.
 */
class CommentController {
  final supabase = Supabase.instance.client;

  /**
   * Récupère tous les commentaires associés à un signalement.
   */
  Future<List<CommentModel>> fetchComments(String reportId) async {
    try {
      final response = await supabase
          .from('comments')
          .select()
          .eq('report_id', reportId)
          .order('created_at', ascending: true);

      return (response as List)
          .map((json) => CommentModel.fromMap(json))
          .toList();
    } catch (e) {
      print('Erreur de récupération des commentaires: $e');
      return [];
    }
  }

  /**
   * Envoie un nouveau commentaire à Supabase.
   */
  Future<bool> sendComment(String reportId, String content) async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) return false;

      await supabase.from('comments').insert({
        'report_id': reportId,
        'user_id': user.id,
        'content': content,
        'is_admin': false,
        'created_at': DateTime.now().toIso8601String(),
      });
      
      return true;
    } catch (e) {
      print('Erreur d\'envoi du commentaire: $e');
      return false;
    }
  }
}
