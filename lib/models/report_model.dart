class ReportModel {
  final String? id;
  final String description;
  final String typeInsalubrite; // ex: Ordures, Inondation, Gravats
  final String imageUrl;
  final double latitude;
  final double longitude;
  final DateTime date;
  final String statut; // En attente, En cours, Résolu

  ReportModel({
    this.id,
    required this.description,
    required this.typeInsalubrite,
    required this.imageUrl,
    required this.latitude,
    required this.longitude,
    required this.date,
    this.statut = "En attente",
  });

  // Convertit l'objet en Map pour l'envoyer vers une base de données (ex: Firebase)
  Map<String, dynamic> toMap() {
    return {
      'description': description,
      'type': typeInsalubrite,
      'imageUrl': imageUrl,
      'latitude': latitude,
      'longitude': longitude,
      'date': date.toIso8601String(),
      'statut': statut,
    };
  }
}