import 'package:flutter/material.dart';

import '../../../../core/services/image_service.dart';

class PhotoStep extends StatelessWidget {
  final String? photoPath;
  final Function(String?) onPhotoSelected;
  final String nom;
  final String prenom;

  const PhotoStep({
    super.key,
    required this.photoPath,
    required this.onPhotoSelected,
    required this.nom,
    required this.prenom,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Photo de la personne',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFFCA1B49),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'La photo est obligatoire et sera nommée selon le nom et prénom',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
        const SizedBox(height: 32),

        // Affichage de la photo actuelle
        if (photoPath != null) ...[
          Center(
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFCA1B49), width: 2),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.asset(
                  photoPath!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child: const Icon(
                        Icons.person,
                        size: 80,
                        color: Colors.grey,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],

        // Boutons d'action
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _takePhoto(context),
                icon: const Icon(Icons.camera_alt),
                label: const Text('Prendre une photo'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFCA1B49),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _pickFromGallery(context),
                icon: const Icon(Icons.photo_library),
                label: const Text('Choisir depuis la galerie'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFCA1B49),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),

        if (photoPath != null) ...[
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _removePhoto(context),
              icon: const Icon(Icons.delete, color: Colors.red),
              label: const Text(
                'Supprimer la photo',
                style: TextStyle(color: Colors.red),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.red),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],

        const SizedBox(height: 24),

        // Information sur la photo
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFCA1B49).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: const Color(0xFFCA1B49).withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            children: [
              const Icon(Icons.info_outline, color: Color(0xFFCA1B49)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'La photo sera automatiquement nommée : ${nom.isNotEmpty && prenom.isNotEmpty ? "${nom.toLowerCase()}_${prenom.toLowerCase()}_timestamp.jpg" : "nom_prenom_timestamp.jpg"}',
                  style: const TextStyle(
                    color: Color(0xFFCA1B49),
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _takePhoto(BuildContext context) async {
    try {
      final photoPath = await ImageService.takePhoto();
      if (photoPath != null) {
        // Sauvegarder avec le nom personnalisé
        final customPhotoPath = await ImageService.savePhotoWithName(
          photoPath,
          nom.isNotEmpty ? nom : 'nom',
          prenom.isNotEmpty ? prenom : 'prenom',
        );

        if (customPhotoPath != null) {
          onPhotoSelected(customPhotoPath);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Photo prise et sauvegardée avec succès'),
              backgroundColor: Color(0xFFCA1B49),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Erreur lors de la sauvegarde de la photo'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors de la prise de photo: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _pickFromGallery(BuildContext context) async {
    try {
      final photoPath = await ImageService.pickFromGallery();
      if (photoPath != null) {
        // Sauvegarder avec le nom personnalisé
        final customPhotoPath = await ImageService.savePhotoWithName(
          photoPath,
          nom.isNotEmpty ? nom : 'nom',
          prenom.isNotEmpty ? prenom : 'prenom',
        );

        if (customPhotoPath != null) {
          onPhotoSelected(customPhotoPath);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Photo sélectionnée et sauvegardée avec succès'),
              backgroundColor: Color(0xFFCA1B49),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Erreur lors de la sauvegarde de la photo'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors de la sélection: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _removePhoto(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: const Text('Êtes-vous sûr de vouloir supprimer cette photo ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onPhotoSelected(null);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Photo supprimée'),
                  backgroundColor: Color(0xFFCA1B49),
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }
}
