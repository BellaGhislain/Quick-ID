import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class ImageService {
  static final ImagePicker _picker = ImagePicker();

  /// Vérifie et demande les permissions nécessaires
  static Future<bool> _checkPermissions() async {
    if (Platform.isAndroid) {
      if (await Permission.photos.isGranted ||
          await Permission.storage.isGranted) {
        return true;
      }

      // Android 13 et +
      if (await Permission.photos.request().isGranted) {
        return true;
      }

      // Android < 13
      if (await Permission.storage.request().isGranted) {
        return true;
      }

      return false;
    }
    return true; // iOS géré automatiquement
  }

  /// Prendre une photo avec la caméra
  static Future<String?> takePhoto() async {
    try {
      if (!await _checkPermissions()) {
        print('Permission refusée pour accéder aux images');
        return null;
      }

      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
        maxWidth: 1024,
        maxHeight: 1024,
      );

      if (photo != null) {
        return await _saveImage(photo.path);
      }
      return null;
    } catch (e) {
      print('Erreur lors de la prise de photo: $e');
      return null;
    }
  }

  /// Choisir une image depuis la galerie
  static Future<String?> pickFromGallery() async {
    try {
      if (!await _checkPermissions()) {
        print('Permission refusée pour accéder aux images');
        return null;
      }

      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 1024,
        maxHeight: 1024,
      );

      if (image != null) {
        return await _saveImage(image.path);
      }
      return null;
    } catch (e) {
      print('Erreur lors de la sélection depuis la galerie: $e');
      return null;
    }
  }

  /// Sauvegarde simple d'une image
  static Future<String> _saveImage(String sourcePath) async {
    final imageDir = await _getImageDirectory();
    if (!await imageDir.exists()) {
      await imageDir.create(recursive: true);
    }

    final fileName = 'image_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final targetPath = '${imageDir.path}/$fileName';

    final sourceFile = File(sourcePath);
    await sourceFile.copy(targetPath);

    return targetPath;
  }

  /// Sauvegarde d'une image avec nom + prénom
  static Future<String?> savePhotoWithName(
    String sourcePath,
    String nom,
    String prenom,
  ) async {
    try {
      final imageDir = await _getImageDirectory();
      if (!await imageDir.exists()) {
        await imageDir.create(recursive: true);
      }

      final cleanNom = _cleanFileName(nom);
      final cleanPrenom = _cleanFileName(prenom);
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = '${cleanNom}_${cleanPrenom}_$timestamp.jpg';
      final targetPath = '${imageDir.path}/$fileName';

      final sourceFile = File(sourcePath);
      await sourceFile.copy(targetPath);

      return targetPath;
    } catch (e) {
      print('Erreur lors de la sauvegarde de l\'image: $e');
      return null;
    }
  }

  /// Retourne le dossier public "Pictures/QuickID"
  static Future<Directory> _getImageDirectory() async {
    Directory? directory;

    if (Platform.isAndroid) {
      directory = Directory('/storage/emulated/0/Pictures/QuickID');
    } else {
      directory = await getApplicationDocumentsDirectory();
      directory = Directory('${directory.path}/QuickID');
    }

    return directory;
  }

  /// Nettoyage du nom de fichier
  static String _cleanFileName(String name) {
    return name
        .replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_')
        .replaceAll(RegExp(r'_+'), '_')
        .toLowerCase()
        .trim();
  }

  /// Supprimer une image
  static Future<void> deleteImage(String imagePath) async {
    try {
      final file = File(imagePath);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      print('Erreur lors de la suppression de l\'image: $e');
    }
  }

  /// Supprimer toutes les images
  static Future<void> clearAllImages() async {
    try {
      final imageDir = await _getImageDirectory();
      if (await imageDir.exists()) {
        await imageDir.delete(recursive: true);
        await imageDir.create(recursive: true);
      }
    } catch (e) {
      print('Erreur lors du nettoyage des images: $e');
    }
  }

  /// Vérifie si une image existe
  static Future<bool> imageExists(String imagePath) async {
    try {
      final file = File(imagePath);
      return await file.exists();
    } catch (e) {
      return false;
    }
  }

  /// Retourne un File si l'image existe
  static Future<File?> getImageFile(String imagePath) async {
    try {
      final file = File(imagePath);
      if (await file.exists()) {
        return file;
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
