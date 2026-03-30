import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../controlers/map_controller.dart' as custom; 
import '../models/report_model.dart';

/**
 * MapPage - Visualisation interactive de l'insalubrité urbaine.
 * 
 * Permet de naviguer dans la ville de Douala, de voir les zones critiques
 * et de prévisualiser les signalements grâce à des marqueurs interactifs.
 * Design plein écran avec superposition d'éléments UI modernes.
 */
class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final custom.MapController _mapController = custom.MapController();
  final MapController _internalMapController = MapController();
  
  ReportModel? _selectedReport;
  
  // Position initiale (Douala centre)
  final LatLng _initialLocation = const LatLng(4.0511, 9.7679);

  /**
   * Gère le clic sur un marqueur pour afficher la prévisualisation.
   */
  void _onMarkerTap(ReportModel report) {
    setState(() {
      _selectedReport = report;
    });
    // Animation de centrage sur le marqueur
    _internalMapController.move(LatLng(report.latitude, report.longitude), 16.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          /** Moteur Cartographique (OSM) */
          FlutterMap(
            mapController: _internalMapController,
            options: MapOptions(
              initialCenter: _initialLocation, 
              initialZoom: 14.0,
              onTap: (tapPosition, point) => setState(() => _selectedReport = null),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.cityreport',
                // Amélioration visuelle optionnelle du style de carte (Grayscale via ColorFilter si besoin)
              ),
              
              /** Layer des signalements (Marqueurs Jaunes HYSACAM) */
              MarkerLayer(
                markers: _mapController.getMarkers(_onMarkerTap),
              ),

              /** Layer de MA POSITION (Point bleu pulsant) */
              MarkerLayer(
                markers: [
                  Marker(
                    point: _initialLocation,
                    width: 60, height: 60,
                    child: _buildUserLocationMarker(),
                  ),
                ],
              ),
            ],
          ),

          /** BARRE DE RECHERCHE SUPERPOSÉE (Top) */
          Positioned(
            top: 60,
            left: 20,
            right: 20,
            child: _buildSearchBar(),
          ),

          /** CARTE DE PRÉVISUALISATION (Bottom) */
          if (_selectedReport != null)
            Positioned(
              bottom: 110, // Juste au dessus de la barre de navigation
              left: 20,
              right: 20,
              child: _buildReportPreviewCard(_selectedReport!),
            ),
          
          /** BOUTON DE LOCALISATION */
          Positioned(
            bottom: (_selectedReport != null) ? 250 : 110,
            right: 20,
            child: FloatingActionButton(
              onPressed: () => _internalMapController.move(_initialLocation, 14.0),
              backgroundColor: Colors.white,
              elevation: 4,
              mini: true,
              child: const Icon(Icons.my_location, color: Color(0xFF059669)),
            ),
          ),
        ],
      ),
    );
  }

  /** UI : Marqueur de position utilisateur */
  Widget _buildUserLocationMarker() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 40, height: 40,
          decoration: BoxDecoration(color: Colors.blue.withOpacity(0.2), shape: BoxShape.circle),
        ),
        Container(
          width: 16, height: 16,
          decoration: BoxDecoration(
            color: Colors.blue, shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 3),
          ),
        ),
      ],
    );
  }

  /** UI : Barre de recherche moderne */
  Widget _buildSearchBar() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: const Row(
        children: [
          Icon(Icons.search, color: Color(0xFF94A3B8)),
          SizedBox(width: 15),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: "Rechercher un quartier...",
                hintStyle: TextStyle(color: Color(0xFF94A3B8), fontWeight: FontWeight.normal),
                border: InputBorder.none,
              ),
            ),
          ),
          Icon(Icons.mic_none, color: Color(0xFF94A3B8)),
        ],
      ),
    );
  }

  /** UI : Carte flottante de prévisualisation du signalement */
  Widget _buildReportPreviewCard(ReportModel report) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 40, offset: const Offset(0, 15)),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network(report.imageUrl, width: 70, height: 70, fit: BoxFit.cover),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  report.typeInsalubrite.toUpperCase(),
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Color(0xFF1F2937)),
                ),
                const SizedBox(height: 4),
                Text(
                  report.description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildStatusBadge(report.statut),
                    const Spacer(),
                    const Text("DÉTAILS", style: TextStyle(
                      color: Color(0xFF059669), fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1,
                    )),
                    const Icon(Icons.chevron_right, color: Color(0xFF059669), size: 16),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /** UI : Badge de statut stylisé */
  Widget _buildStatusBadge(String status) {
    final isPending = status == "En attente";
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isPending ? const Color(0xFFFEF3C7) : const Color(0xFFDCFCE7),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          fontSize: 8,
          fontWeight: FontWeight.w900,
          color: isPending ? const Color(0xFF92400E) : const Color(0xFF166534),
        ),
      ),
    );
  }
}