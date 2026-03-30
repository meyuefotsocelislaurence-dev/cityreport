import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../models/report_model.dart';
import 'package:flutter/material.dart';

/**
 * MapController - Gestionnaire de la logique cartographique.
 * 
 * Responsable de la fourniture des marqueurs de signalements et 
 * de la gestion des interactions sur la carte OSM (OpenStreetMap).
 */
class MapController {
  
  /** 
   * Liste des signalements synchronisés avec le HomeController 
   * pour la cohérence visuelle de la démo.
   */
  final List<ReportModel> mockReports = [
    ReportModel(
      description: "Accumulation d'ordures ménagères devant le marché Alwa.",
      typeInsalubrite: "Ordures ménagères",
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

  /**
   * Génère les widgets de marqueurs pour la carte. 
   * Chaque marqueur est un cercle Jaune HYSACAM avec une icône centrale.
   */
  List<Marker> getMarkers(Function(ReportModel) onTap) {
    return mockReports.map((report) {
      return Marker(
        point: LatLng(report.latitude, report.longitude),
        width: 45,
        height: 45,
        child: GestureDetector(
          onTap: () => onTap(report),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFFBBF24), // Jaune Hysacam
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: const Icon(
              Icons.delete_outline_rounded,
              color: Color(0xFF059669), // Vert Hysacam
              size: 20,
            ),
          ),
        ),
      );
    }).toList();
  }
}