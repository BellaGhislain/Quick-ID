import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';

class DownloadService {
  /// Obtient le dossier où sauvegarder les fichiers exportés
  static Future<Directory> _getExportDirectory() async {
    Directory dir;

    if (Platform.isAndroid) {
      dir = Directory('/storage/emulated/0/Download');
      if (!await dir.exists()) {
        // fallback vers le dossier Documents de l'app si Download non accessible
        final appDir = await getApplicationDocumentsDirectory();
        dir = Directory('${appDir.path}/Downloads');
      }
    } else if (Platform.isIOS) {
      // iOS : Documents de l'app
      final appDir = await getApplicationDocumentsDirectory();
      dir = Directory('${appDir.path}/Downloads');
    } else {
      // Autres plateformes : Documents de l'app
      final appDir = await getApplicationDocumentsDirectory();
      dir = Directory('${appDir.path}/Downloads');
    }

    if (!await dir.exists()) {
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
      final dir = await _getExportDirectory();
      final file = File('${dir.path}/$fileName');
      await file.writeAsBytes(fileBytes);
      return file.path;
    } catch (e) {
      print('Erreur lors de la sauvegarde du fichier: $e');
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
