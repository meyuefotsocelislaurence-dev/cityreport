import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/report_model.dart';

/**
 * HomeController - Gestionnaire de logique de la page d'accueil dynamique.
 * 
 * Récupère les signalements réels de l'utilisateur depuis Supabase 
 * et calcule dynamiquement les statistiques d'impact citoyen (Eco-Points).
 */
class HomeController {
  final supabase = Supabase.instance.client;
  List<ReportModel> userReports = []; // Signalements de l'utilisateur (pour les stats)
  List<ReportModel> allReports = [];  // Tous les signalements (pour le flux communautaire)

  /**
   * Récupère les signalements personnels pour calculer les statistiques.
   */
  Future<void> fetchUserStats() async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) return;

      final response = await supabase
          .from('reports')
          .select()
          .eq('user_id', user.id);

      userReports = (response as List)
          .map((json) => ReportModel.fromMap(json))
          .toList();
    } catch (e) {
      print('Erreur de stats: $e');
    }
  }

  /**
   * Récupère TOUS les signalements de Douala (Flux Communautaire).
   */
  Future<List<ReportModel>> fetchAllCommunityReports() async {
    try {
      final response = await supabase
          .from('reports')
          .select()
          .order('created_at', ascending: false);

      allReports = (response as List)
          .map((json) => ReportModel.fromMap(json))
          .toList();
      
      return allReports;
    } catch (e) {
      print('Erreur de récupération communautaire: $e');
      return [];
    }
  }

  /**
   * Retourne le nombre total de signalements effectués par l'utilisateur.
   */
  int getUserTotalReports() => userReports.length;

  /** 
   * Calcul dynamique des points éco-citoyens (ex: 50 points par signalement).
   */
  int getEcoPoints() => userReports.length * 50;

  /** 
   * Calcul dynamique de l'impact CO2 évité (ex: 2kg par signalement résolu).
   */
  int getCo2Impact() {
    final resolvedCount = userReports.where((r) => r.statut.toLowerCase() == "résolu").length;
    return resolvedCount * 2;
  }

  /** Statistiques globales (pour la démo, on peut garder une base fixe + dynamique) */
  int getTotalReports() => 145 + userReports.length;
}