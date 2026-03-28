import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../models/report_model.dart';
import 'package:flutter/material.dart';

class MapController {
  List<ReportModel> mockReports = [
    ReportModel(
      description: "Décharge sauvage",
      typeInsalubrite: "Ordures",
      imageUrl: "",
      latitude: 4.0511,
      longitude: 9.7679,
      date: DateTime.now(),
    ),
  ];

  List<Marker> getMarkers() {
    return mockReports.map((report) {
      return Marker(
        point: LatLng(report.latitude, report.longitude),
        width: 80,
        height: 80,
        child: const Icon(Icons.location_on, color: Colors.red, size: 40),
      );
    }).toList();
  }
}