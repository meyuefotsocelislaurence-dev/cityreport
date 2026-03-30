import '../models/report_model.dart';

/**
 * HomeController - Gestionnaire de logique de la page d'accueil.
 * 
 * Fournit les données nécessaires pour le tableau de bord citoyen, 
 * incluant les statistiques d'impact et la liste des signalements récents.
 * Pour la soutenance, cette classe simule des données haute fidélité.
 */
class HomeController {
  /**
   * Retourne une liste enrichie de signalements avec des images Unsplash 
   * pour un rendu professionnel lors de la présentation.
   */
  List<ReportModel> getRecentReports() {
    return [
      ReportModel(
        description: "Accumulation d'ordures ménagères devant le marché Alwa.",
        typeInsalubrite: "Ordures ménagères",
        // Image haute qualité pour la démo
        imageUrl: "https://images.unsplash.com/photo-1530587191325-3db32d826c18?auto=format&fit=crop&w=600&q=80",
        latitude: 4.0511,
        longitude: 9.7679,
        date: DateTime.now(),
        statut: "En attente",
      ),
      ReportModel(
        description: "Caniveau bouché provoquant des inondations sur la chaussée.",
        typeInsalubrite: "Eaux usées",
        imageUrl: "https://images.unsplash.com/photo-1595273670150-db0a3d39074f?auto=format&fit=crop&w=600&q=80",
        latitude: 4.0600,
        longitude: 9.7700,
        date: DateTime.now().subtract(const Duration(days: 1)),
        statut: "En cours",
      ),
      ReportModel(
        description: "Dépôt sauvage de gravats de construction à Bonanjo.",
        typeInsalubrite: "Gravats",
        imageUrl: "https://images.unsplash.com/photo-1618477461853-cf6ed80faba5?auto=format&fit=crop&w=600&q=80",
        latitude: 4.0400,
        longitude: 9.7500,
        date: DateTime.now().subtract(const Duration(days: 2)),
        statut: "Résolu",
      ),
    ];
  }

  /** Retourne le nombre total de signalements effectués par l'utilisateur */
  int getUserTotalReports() => 24;

  /** Retourne les points éco-citoyens gagnés */
  int getEcoPoints() => 450;

  /** Retourne l'impact CO2 évité estimé (en kg) */
  int getCo2Impact() => 12;

  /** Statistiques globales (fictives pour la démo) */
  int getTotalReports() => 145;
  int getResolvedReports() => 92;

  /** Taux de résolution global */
  double getResolutionRate() {
    if (getTotalReports() == 0) return 0.0;
    return (getResolvedReports() / getTotalReports()) * 100;
  }
}