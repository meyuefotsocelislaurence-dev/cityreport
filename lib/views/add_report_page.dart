import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../controlers/report_controller.dart';

/**
 * AddReportPage - Formulaire de signalement citoyen.
 * 
 * Permet de capturer une photo de l'insalubrité, d'ajouter un titre/description
 * et de récupérer automatiquement la position GPS pour envoi à HYSACAM.
 * Design conforme aux maquettes "Simple & Beau".
 */
class AddReportPage extends StatefulWidget {
  const AddReportPage({super.key});

  @override
  State<AddReportPage> createState() => _AddReportPageState();
}

class _AddReportPageState extends State<AddReportPage> {
  final ReportController _controller = ReportController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool _isSending = false;

  /**
   * Affiche le menu de sélection de source d'image (Caméra/Galerie).
   */
  void _showImagePicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(30),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildPickerOption(Icons.camera_alt_rounded, "Prendre une photo", ImageSource.camera),
              const SizedBox(height: 15),
              _buildPickerOption(Icons.photo_library_rounded, "Choisir dans la galerie", ImageSource.gallery),
            ],
          ),
        ),
      ),
    );
  }

  /** Option individuelle pour le sélecteur d'image */
  Widget _buildPickerOption(IconData icon, String label, ImageSource source) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF059669)),
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1F2937))),
      tileColor: const Color(0xFFF8FAFC),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      onTap: () async {
        Navigator.pop(context);
        await _controller.pickImage(source);
        if (mounted) setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30, 80, 30, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /** Titre de la page */
              const Text(
                "NOUVEAU RAPPORT",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF1F2937),
                  letterSpacing: -1.0,
                ),
              ),
              const SizedBox(height: 40),

              /** Zone de Photo avec pointillé stylisé */
              GestureDetector(
                onTap: _showImagePicker,
                child: Container(
                  width: double.infinity,
                  height: 250,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: const Color(0xFFCBD5E1),
                      width: 2,
                      style: BorderStyle.solid, // Flutter n'a pas de pointillés en standard, on utilise un look épuré
                    ),
                  ),
                  child: _controller.selectedImage != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Image.file(_controller.selectedImage!, fit: BoxFit.cover),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.camera_alt_outlined, size: 50, color: Colors.grey[300]),
                            const SizedBox(height: 10),
                            Text(
                              "AJOUTER UNE PHOTO",
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                                color: Colors.grey[400],
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ),
                ),
              ),

              const SizedBox(height: 40),

              /** Formulaire */
              _buildFieldLabel("TITRE DU PROBLÈME"),
              _buildTextField(controller: _titleController, hintText: "Ex: Poubelle débordante"),
              
              const SizedBox(height: 25),
              _buildFieldLabel("DESCRIPTION DÉTAILLÉE"),
              _buildTextField(controller: _descriptionController, hintText: "Décrivez la situation...", maxLines: 4),

              const SizedBox(height: 25),
              
              /** Badge de Localisation automatique */
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFDCFCE7), // Vert clair
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.location_on, color: Color(0xFF059669), size: 18),
                    SizedBox(width: 10),
                    Text(
                      "Lieu : Rue NJA-NJA, Bali",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF059669),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              /** Bouton Envoyer Jaune Hysacam */
              SizedBox(
                width: double.infinity,
                height: 65,
                child: ElevatedButton(
                  onPressed: _isSending ? null : _submitReport,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFBBF24), // Jaune HYSACAM
                    foregroundColor: const Color(0xFF059669), // Vert HYSACAM
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: _isSending
                      ? const CircularProgressIndicator(color: Color(0xFF059669), strokeWidth: 2)
                      : const Text(
                          "ENVOYER À HYSACAM",
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, letterSpacing: 1),
                        ),
                ),
              ),

              /** Lien Annuler */
              Center(
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    "ANNULER",
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      color: Colors.grey[400],
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /**
   * Logique d'envoi du signalement.
   */
  Future<void> _submitReport() async {
    if (_controller.selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Veuillez prendre une photo")));
      return;
    }
    
    setState(() => _isSending = true);
    
    // Simulation d'envoi
    await Future.delayed(const Duration(seconds: 2));
    
    if (mounted) {
      setState(() => _isSending = false);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Signalement envoyé avec succès !")));
      Navigator.pop(context);
    }
  }

  /** Label grisé pour les champs */
  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w900,
          color: Color(0xFF94A3B8),
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  /** Champ de texte stylisé */
  Widget _buildTextField({required TextEditingController controller, required String hintText, int maxLines = 1}) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1F2937)),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey[300], fontWeight: FontWeight.normal),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(20),
        ),
      ),
    );
  }
}