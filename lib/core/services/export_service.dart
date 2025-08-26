import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';

import '../constants/app_constants.dart';
import 'download_service.dart';

enum ExportFormat { json, csv, excel }

class ExportService {
  static Future<String> getExportDirectory() async {
    final directory = await getApplicationDocumentsDirectory();
    final exportDir = Directory(
      '${directory.path}/${AppConstants.exportDirectory}',
    );

    if (!await exportDir.exists()) {
      await exportDir.create(recursive: true);
    }

    return exportDir.path;
  }

  /// Exporte vers le dossier de téléchargements du téléphone
  static Future<String?> exportToDownloads({
    required List<Map<String, dynamic>> instances,
    required List<Map<String, dynamic>> subInstances,
    required List<Map<String, dynamic>> persons,
    required ExportFormat format,
    String? instanceName,
    String? subInstanceName,
  }) async {
    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      String fileName;
      String content;

      if (format == ExportFormat.json) {
        fileName = 'export_${instanceName ?? 'global'}_$timestamp.json';
        content = jsonEncode({
          'exportDate': DateTime.now().toIso8601String(),
          'instances': instances,
          'subInstances': subInstances,
          'persons': persons,
        });
      } else if (format == ExportFormat.csv) {
        fileName = 'export_${instanceName ?? 'global'}_$timestamp.csv';
        content = _generateCsvContent(instances, subInstances, persons);
      } else if (format == ExportFormat.excel) {
        fileName = 'export_${instanceName ?? 'global'}_$timestamp.xlsx';
        content = _generateCsvContent(instances, subInstances, persons);
      } else {
        return null;
      }

      return await DownloadService.saveTextToDownloads(
        fileName: fileName,
        content: content,
      );
    } catch (e) {
      print('Erreur export: $e');
      return null;
    }
  }

  /// Exporte une instance spécifique
  static Future<String?> exportInstance({
    required List<Map<String, dynamic>> subInstances,
    required List<Map<String, dynamic>> persons,
    required ExportFormat format,
    required String instanceName,
  }) async {
    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      String fileName;
      String content;

      if (format == ExportFormat.json) {
        fileName = 'export_${instanceName}_$timestamp.json';
        content = jsonEncode({
          'exportDate': DateTime.now().toIso8601String(),
          'instance': instanceName,
          'subInstances': subInstances,
          'persons': persons,
        });
      } else if (format == ExportFormat.csv) {
        fileName = 'export_${instanceName}_$timestamp.csv';
        content = _generateInstanceCsvContent(
          subInstances,
          persons,
          instanceName,
        );
      } else if (format == ExportFormat.excel) {
        fileName = 'export_${instanceName}_$timestamp.xlsx';
        content = _generateInstanceCsvContent(
          subInstances,
          persons,
          instanceName,
        );
      } else {
        return null;
      }

      return await DownloadService.saveTextToDownloads(
        fileName: fileName,
        content: content,
      );
    } catch (e) {
      print('Erreur export instance: $e');
      return null;
    }
  }

  /// Exporte une sous-instance spécifique
  static Future<String?> exportSubInstance({
    required List<Map<String, dynamic>> persons,
    required ExportFormat format,
    required String instanceName,
    required String subInstanceName,
  }) async {
    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      String fileName;
      String content;

      if (format == ExportFormat.json) {
        fileName = 'export_${instanceName}_${subInstanceName}_$timestamp.json';
        content = jsonEncode({
          'exportDate': DateTime.now().toIso8601String(),
          'instance': instanceName,
          'subInstance': subInstanceName,
          'persons': persons,
        });
      } else if (format == ExportFormat.csv) {
        fileName = 'export_${instanceName}_${subInstanceName}_$timestamp.csv';
        content = _generateSubInstanceCsvContent(
          persons,
          instanceName,
          subInstanceName,
        );
      } else if (format == ExportFormat.excel) {
        fileName = 'export_${instanceName}_${subInstanceName}_$timestamp.xlsx';
        content = _generateSubInstanceCsvContent(
          persons,
          instanceName,
          subInstanceName,
        );
      } else {
        return null;
      }

      return await DownloadService.saveTextToDownloads(
        fileName: fileName,
        content: content,
      );
    } catch (e) {
      print('Erreur export sous-instance: $e');
      return null;
    }
  }

  static String _generateCsvContent(
    List<Map<String, dynamic>> instances,
    List<Map<String, dynamic>> subInstances,
    List<Map<String, dynamic>> persons,
  ) {
    final csvData = <List<dynamic>>[];

    // Add instances
    if (instances.isNotEmpty) {
      csvData.add(['=== INSTANCES ===']);
      csvData.add(instances.first.keys.toList());
      csvData.addAll(instances.map((e) => e.values.toList()));
      csvData.add([]); // Empty line
    }

    // Add sub-instances
    if (subInstances.isNotEmpty) {
      csvData.add(['=== SOUS-INSTANCES ===']);
      csvData.add(subInstances.first.keys.toList());
      csvData.addAll(subInstances.map((e) => e.values.toList()));
      csvData.add([]); // Empty line
    }

    // Add persons
    if (persons.isNotEmpty) {
      csvData.add(['=== PERSONNES ===']);
      csvData.add(persons.first.keys.toList());
      csvData.addAll(persons.map((e) => e.values.toList()));
    }

    return const ListToCsvConverter().convert(csvData);
  }

  static String _generateInstanceCsvContent(
    List<Map<String, dynamic>> subInstances,
    List<Map<String, dynamic>> persons,
    String instanceName,
  ) {
    final csvData = <List<dynamic>>[];

    csvData.add(['=== INSTANCE: $instanceName ===']);
    csvData.add([]);

    // Add sub-instances
    if (subInstances.isNotEmpty) {
      csvData.add(['=== SOUS-INSTANCES ===']);
      csvData.add(subInstances.first.keys.toList());
      csvData.addAll(subInstances.map((e) => e.values.toList()));
      csvData.add([]); // Empty line
    }

    // Add persons
    if (persons.isNotEmpty) {
      csvData.add(['=== PERSONNES ===']);
      csvData.add(persons.first.keys.toList());
      csvData.addAll(persons.map((e) => e.values.toList()));
    }

    return const ListToCsvConverter().convert(csvData);
  }

  static String _generateSubInstanceCsvContent(
    List<Map<String, dynamic>> persons,
    String instanceName,
    String subInstanceName,
  ) {
    final csvData = <List<dynamic>>[];

    csvData.add(['=== INSTANCE: $instanceName ===']);
    csvData.add(['=== SOUS-INSTANCE: $subInstanceName ===']);
    csvData.add([]);

    // Add persons
    if (persons.isNotEmpty) {
      csvData.add(['=== PERSONNES ===']);
      csvData.add(persons.first.keys.toList());
      csvData.addAll(persons.map((e) => e.values.toList()));
    }

    return const ListToCsvConverter().convert(csvData);
  }
}
