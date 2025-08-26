import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';

class DownloadService {
  /// Obtient le dossier où sauvegarder les fichiers exportés
  static Future<Directory> _getExportDirectory() async {
    Directory dir;

    if (Platform.isAndroid) {
      // Essayer d'abord le dossier de téléchargements public
      dir = Directory('/storage/emulated/0/Download');
      if (!await dir.exists()) {
        print(
          'Dossier Download public non accessible, essai du dossier Documents de l\'app',
        );
        // fallback vers le dossier Documents de l'app si Download non accessible
        final appDir = await getApplicationDocumentsDirectory();
        dir = Directory('${appDir.path}/Downloads');
      } else {
        print('Dossier Download public accessible: ${dir.path}');
      }
    } else if (Platform.isIOS) {
      // iOS : Documents de l'app
      final appDir = await getApplicationDocumentsDirectory();
      dir = Directory('${appDir.path}/Downloads');
      print('Dossier iOS: ${dir.path}');
    } else {
      // Autres plateformes : Documents de l'app
      final appDir = await getApplicationDocumentsDirectory();
      dir = Directory('${appDir.path}/Downloads');
      print('Dossier autre plateforme: ${dir.path}');
    }

    if (!await dir.exists()) {
      print('Création du dossier: ${dir.path}');
      await dir.create(recursive: true);
    }

    return dir;
  }

  /// Sauvegarde un fichier binaire
  static Future<String?> saveToDownloads({
    required String fileName,
    required Uint8List fileBytes,
    String? mimeType,
  }) async {
    try {
      print('Tentative de sauvegarde du fichier: $fileName');
      final dir = await _getExportDirectory();
      print('Dossier de destination: ${dir.path}');

      final file = File('${dir.path}/$fileName');
      print('Chemin complet du fichier: ${file.path}');

      await file.writeAsBytes(fileBytes);
      print('Fichier sauvegardé avec succès: ${file.path}');
      print('Taille du fichier: ${fileBytes.length} bytes');

      return file.path;
    } catch (e) {
      print('Erreur lors de la sauvegarde du fichier: $e');
      print('Stack trace: ${StackTrace.current}');
      return null;
    }
  }

  /// Sauvegarde un fichier texte
  static Future<String?> saveTextToDownloads({
    required String fileName,
    required String content,
  }) async {
    try {
      final bytes = Uint8List.fromList(content.codeUnits);
      return await saveToDownloads(fileName: fileName, fileBytes: bytes);
    } catch (e) {
      print('Erreur lors de la sauvegarde du fichier texte: $e');
      return null;
    }
  }

  /// Vérifie si le dossier de téléchargements est accessible
  static Future<bool> isDownloadsAccessible() async {
    try {
      final dir = await _getExportDirectory();
      return await dir.exists();
    } catch (_) {
      return false;
    }
  }

  /// Retourne le chemin du dossier de téléchargement utilisé
  static Future<String?> getDownloadsPath() async {
    try {
      final dir = await _getExportDirectory();
      return dir.path;
    } catch (_) {
      return null;
    }
  }
}
