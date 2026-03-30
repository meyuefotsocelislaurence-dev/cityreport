// ignore_for_file: slash_for_doc_comments

import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/**
 * ReportController - Gestionnaire des signalements d'insalubrité.
 * 
 * Responsable de la capture d'image (Web & Mobile), de la localisation GPS 
 * et de la synchronisation avec Supabase (Storage + Database).
 */
class ReportController {
  XFile? selectedImage; // Utilisation de XFile pour la compatibilité Web
  Position? currentPosition;
  final ImagePicker _picker = ImagePicker();
  final supabase = Supabase.instance.client;

  /**
   * Sélectionne une image depuis la caméra ou la galerie.
   * Compatible Web, iOS et Android.
   */
  Future<void> pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      selectedImage = pickedFile;
    }
  }

  /**
   * Envoie le signalement complet à Supabase.
   * 1. Upload de la photo dans le bucket 'reports'.
   * 2. Insertion des données dans la table 'reports'.
   */
  Future<bool> submitReport({
    required String title,
    required String description,
    required String typeInsalubrite,
  }) async {
    if (selectedImage == null) return false;

    try {
      final user = supabase.auth.currentUser;
      if (user == null) return false;

      // 1. Génération d'un nom de fichier unique pour le stockage
      final fileName = 'report_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final imageBytes = await selectedImage!.readAsBytes();

      // 2. Upload vers Supabase Storage (Bucket: reports)
      await supabase.storage.from('reports').uploadBinary(
            fileName,
            imageBytes,
            fileOptions: const FileOptions(
              contentType: 'image/jpeg',
              upsert: true,
            ),
          );

      // 3. Récupération de l'URL publique de l'image
      final imageUrl = supabase.storage.from('reports').getPublicUrl(fileName);

      // 4. Insertion dans la table 'reports'
      await supabase.from('reports').insert({
        'user_id': user.id,
        'title': title,
        'description': description,
        'typeInsalubrite': typeInsalubrite,
        'imageUrl': imageUrl,
        'latitude': currentPosition?.latitude ?? 4.0511, // Fallback Douala
        'longitude': currentPosition?.longitude ?? 9.7679,
        'statut': 'En attente',
        'created_at': DateTime.now().toIso8601String(),
      });

      return true;
    } on StorageException catch (e) {
      print('Erreur Storage: ${e.message}');
      return false;
    } catch (e) {
      print('Erreur d\'envoi du rapport: $e');
      return false;
    }
  }

  /**
   * Tente de récupérer la position GPS actuelle de l'utilisateur.
   */
  Future<void> getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    currentPosition = await Geolocator.getCurrentPosition();
  }
}
