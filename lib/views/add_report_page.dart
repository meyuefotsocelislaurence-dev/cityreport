import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../controlers/report_controller.dart';

/**
 * AddReportPage - Formulaire de signalement dynamique.
 * 
 * Permet de capturer une photo (Web/Mobile), d'ajouter un titre,
 * une description détaillée et d'envoyer le tout à Supabase.
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
   * Action : Sélectionner une image (Caméra ou Galerie).
   * Compatible Web, iOS et Android.
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

  /** Élément individuel pour le sélecteur d'image */
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

  /**
   * Action : Soumission dynamique du rapport.
   * Upload image (Storage) + Enregistrement (Database).
   */
  Future<void> _submitReport() async {
    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();

    if (_controller.selectedImage == null || title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez ajouter une photo et un titre")),
      );
      return;
    }

    setState(() => _isSending = true);

    // Tentative de localisation (optionnelle mais recommandée)
    await _controller.getLocation();

    final success = await _controller.submitReport(
      title: title,
      description: description,
      typeInsalubrite: "Ordures ménagères", // Statistique par défaut (à dynamiser si besoin)
    );

    if (mounted) {
      setState(() => _isSending = false);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("SIGNALEMENT ENVOYÉ AVEC SUCCÈS"), backgroundColor: Color(0xFF059669)),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("ÉCHEC DE L'ENVOI. VÉRIFIEZ VOTRE CONNEXION."), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30, 80, 30, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /** Titre de la page */
              Text(
                "NOUVEAU RAPPORT",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: isDark ? Colors.white : const Color(0xFF1F2937),
                  letterSpacing: -1.0,
                ),
              ),
              const SizedBox(height: 40),

              /** Zone de Photo compatible WEB (Blob URLs) */
              GestureDetector(
                onTap: _showImagePicker,
                child: Container(
                  width: double.infinity,
                  height: 250,
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF121212) : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: isDark ? Colors.grey[800]! : const Color(0xFFCBD5E1),
                      width: 2,
                    ),
                  ),
                  child: _controller.selectedImage != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Image.network(
                            _controller.selectedImage!.path,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => const Icon(Icons.error, color: Colors.red),
                          ),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.camera_alt_outlined, size: 50, color: Colors.grey[300]),
                            const SizedBox(height: 10),
                            const Text(
                              "AJOUTER UNE PHOTO",
                              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.grey, letterSpacing: 1),
                            ),
                          ],
                        ),
                ),
              ),

              const SizedBox(height: 40),

              /** Formulaire */
              _buildFieldLabel("TITRE DU PROBLÈME"),
              _buildTextField(controller: _titleController, hintText: "Ex: Poubelle débordante", isDark: isDark),
              
              const SizedBox(height: 25),
              _buildFieldLabel("DESCRIPTION DÉTAILLÉE"),
              _buildTextField(controller: _descriptionController, hintText: "Décrivez la situation...", maxLines: 4, isDark: isDark),

              const SizedBox(height: 25),
              
              /** Badge de Localisation Statique pour la démo */
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? Colors.green.withOpacity(0.1) : const Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.location_on, color: Color(0xFF059669), size: 18),
                    SizedBox(width: 10),
                    Text(
                      "Localisation automatique activée",
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF059669)),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              /** Bouton Envoyer avec état de chargement (LOADING) */
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
                      ? const SizedBox(
                          width: 24, height: 24,
                          child: CircularProgressIndicator(color: Color(0xFF059669), strokeWidth: 2),
                        )
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
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.grey[400], letterSpacing: 1),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /** Labels stylisés */
  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        label,
        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF94A3B8), letterSpacing: 1),
      ),
    );
  }

  /** Champs de texte "Simple & Beau" */
  Widget _buildTextField({required TextEditingController controller, required String hintText, int maxLines = 1, required bool isDark}) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF8FAFC), 
        borderRadius: BorderRadius.circular(20),
        border: isDark ? Border.all(color: Colors.grey[800]!) : null,
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : const Color(0xFF1F2937)),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey[400], fontWeight: FontWeight.normal),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(20),
        ),
      ),
    );
  }
}