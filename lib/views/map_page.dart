import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../controlers/map_controller.dart' as custom; 

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    final custom.MapController mapController = custom.MapController();
    
    // Simulation de ma position actuelle (ex: centre de Douala)
    const LatLng myFakeLocation = LatLng(4.0511, 9.7679);

    return Scaffold(
      appBar: AppBar(title: const Text("Carte de l'Insalubrité")),
      body: FlutterMap(
        options: const MapOptions(
          initialCenter: myFakeLocation, 
          initialZoom: 14.0,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.cityreport',
          ),
          
          // Layer des signalements (Points rouges)
          MarkerLayer(
            markers: mapController.getMarkers(),
          ),

          // Layer de MA POSITION simulée (Point bleu)
          MarkerLayer(
            markers: [
              Marker(
                point: myFakeLocation,
                width: 60,
                height: 60,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Halo bleu transparent
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                    ),
                    // Point bleu central
                    Container(
                      width: 15,
                      height: 15,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      
      // Bouton pour se recentrer sur soi-même (simulé)
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Recalcul de votre position GPS...")),
          );
        },
        backgroundColor: Colors.white,
        child: const Icon(Icons.my_location, color: Colors.blue),
      ),
    );
  }
}