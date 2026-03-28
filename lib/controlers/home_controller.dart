import '../models/report_model.dart';

class HomeController {
  // 1. Liste simulée des signalements pour la démonstration
  // Dans une version finale, ces données viendraient d'une API ou de Firebase
  List<ReportModel> getRecentReports() {
    return [
      ReportModel(
        description: "Accumulation d'ordures ménagères devant le marché.",
        typeInsalubrite: "Ordures ménagères",
        imageUrl: "assets/images/ordures.jpg", // Chemin fictif pour l'UI
        latitude: 4.0511,
        longitude: 9.7679,
        date: DateTime.now(),
        statut: "En attente",
      ),
      ReportModel(
        description: "Caniveau bouché provoquant des inondations sur la chaussée.",
        typeInsalubrite: "Eaux usées",
        imageUrl: "assets/images/eau.jpg",
        latitude: 4.0600,
        longitude: 9.7700,
        date: DateTime.now().subtract(const Duration(days: 1)),
        statut: "En cours",
      ),
      ReportModel(
        description: "Dépôt sauvage de gravats de construction.",
        typeInsalubrite: "Gravats",
        imageUrl: "assets/images/gravats.jpg",
        latitude: 4.0400,
        longitude: 9.7500,
        date: DateTime.now().subtract(const Duration(days: 2)),
        statut: "Résolu",
      ),
    ];
  }

  // 2. Logique pour les statistiques du tableau de bord
  int getTotalReports() {
    // Simule un total de signalements dans la ville
    return 145;
  }

  int getResolvedReports() {
    // Simule le nombre de problèmes résolus par les autorités
    return 92;
  }

  double getResolutionRate() {
    if (getTotalReports() == 0) return 0.0;
    return (getResolvedReports() / getTotalReports()) * 100;
  }

  // 3. Logique de filtrage (optionnel pour la soutenance)
  // Permet de montrer au jury que vous avez prévu une gestion par statut
  List<ReportModel> filterByStatus(String status) {
    return getRecentReports().where((r) => r.statut == status).toList();
  }
}