/**
 * ReportModel - Structure de données d'un signalement citoyen.
 * 
 * Modélise les informations transmises par l'utilisateur (description, type,
 * image, position) ainsi que le statut de traitement par HYSACAM.
 */
class ReportModel {
  final String? id;
  final String? title;
  final String description;
  final String typeInsalubrite; // ex: Ordures, Inondation, Gravats
  final String imageUrl;
  final double latitude;
  final double longitude;
  final DateTime date;
  final String statut; // En attente, En cours, Résolu

  ReportModel({
    this.id,
    this.title,
    required this.description,
    required this.typeInsalubrite,
    required this.imageUrl,
    required this.latitude,
    required this.longitude,
    required this.date,
    this.statut = "En attente",
  });

  /**
   * Factory constructor pour transformer un JSON Supabase en objet ReportModel.
   */
  factory ReportModel.fromMap(Map<String, dynamic> map) {
    return ReportModel(
      id: map['id']?.toString(),
      title: map['title'] as String?,
      description: map['description'] ?? "Aucune description",
      typeInsalubrite: map['typeInsalubrite'] ?? "Ordures ménagères",
      imageUrl: map['imageUrl'] ?? "",
      latitude: (map['latitude'] as num?)?.toDouble() ?? 4.0511,
      longitude: (map['longitude'] as num?)?.toDouble() ?? 9.7679,
      date: DateTime.tryParse(map['created_at'] ?? "") ?? DateTime.now(),
      statut: map['statut'] ?? "En attente",
    );
  }

  /**
   * Convertit l'objet en Map pour l'envoi vers une base de données.
   */
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'typeInsalubrite': typeInsalubrite,
      'imageUrl': imageUrl,
      'latitude': latitude,
      'longitude': longitude,
      'created_at': date.toIso8601String(),
      'statut': statut,
    };
  }
}