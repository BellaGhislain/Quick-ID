import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/providers/app_providers.dart';
import '../../../../core/services/export_service.dart';
import '../../../../core/services/modal_service.dart';
import '../../models/instance.dart';
import '../widgets/add_instance_dialog.dart';
import '../widgets/instance_card.dart';

class InstancesPage extends ConsumerStatefulWidget {
  const InstancesPage({super.key});

  @override
  ConsumerState<InstancesPage> createState() => _InstancesPageState();
}

class _InstancesPageState extends ConsumerState<InstancesPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(instancesProvider.notifier).loadInstances();
    });
  }

  @override
  Widget build(BuildContext context) {
    final instancesAsync = ref.watch(instancesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quick ID - Instances'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: _showAboutDialog,
            tooltip: 'À propos',
          ),
          IconButton(
            icon: const Icon(Icons.file_download),
            onPressed: _showExportOptions,
            tooltip: 'Exporter',
          ),
        ],
      ),
      body: instancesAsync.when(
        data: (instances) => instances.isEmpty
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.business, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'Aucune instance créée',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Appuyez sur le bouton + pour créer votre première instance',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: instances.length,
                itemBuilder: (context, index) {
                  final instance = instances[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: InstanceCard(
                      instance: instance,
                      onTap: () => _navigateToSubInstances(instance),
                      onEdit: () => _editInstance(instance),
                      onDelete: () => _deleteInstance(instance),
                    ),
                  );
                },
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Erreur: $error',
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addInstance,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _navigateToSubInstances(Instance instance) {
    context.go('/sub-instances/${instance.id}');
  }

  void _addInstance() {
    showDialog(
      context: context,
      builder: (context) => const AddInstanceDialog(),
    );
  }

  void _editInstance(Instance instance) {
    showDialog(
      context: context,
      builder: (context) => AddInstanceDialog(instance: instance),
    );
  }

  void _deleteInstance(Instance instance) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: Text(
          'Êtes-vous sûr de vouloir supprimer l\'instance "${instance.nom}" ?\n\nCette action supprimera également toutes les sous-instances et personnes associées.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(instancesProvider.notifier).deleteInstance(instance.id);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }

  void _showExportOptions() {
    ModalService.showBottomModal(
      context: context,
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              'Exporter les données',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFFCA1B49),
              ),
            ),
            const SizedBox(height: 24),

            _buildExportOption(
              icon: Icons.file_download,
              title: 'Export global (JSON)',
              subtitle: 'Format JSON pour l\'intégration',
              onTap: () {
                Navigator.of(context).pop();
                _exportGlobal(ExportFormat.json);
              },
            ),

            const SizedBox(height: 16),

            _buildExportOption(
              icon: Icons.table_chart,
              title: 'Export global (CSV)',
              subtitle: 'Format CSV pour Excel',
              onTap: () {
                Navigator.of(context).pop();
                _exportGlobal(ExportFormat.csv);
              },
            ),

            const SizedBox(height: 16),

            _buildExportOption(
              icon: Icons.table_chart,
              title: 'Export global (Excel)',
              subtitle: 'Format Excel (.xlsx)',
              onTap: () {
                Navigator.of(context).pop();
                _exportGlobal(ExportFormat.excel);
              },
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildExportOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!, width: 1),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFFCA1B49).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: const Color(0xFFCA1B49), size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: 16),
          ],
        ),
      ),
    );
  }

  void _exportGlobal(ExportFormat format) async {
    try {
      // Charger les données depuis les notifiers
      await ref.read(instancesProvider.notifier).loadInstances();
      await ref.read(subInstancesProvider.notifier).loadSubInstances();
      await ref.read(personsProvider.notifier).loadPersons();

      // Récupérer les données depuis les providers
      final instances = ref.read(instancesProvider).value ?? [];
      final subInstances = ref.read(subInstancesProvider).value ?? [];
      final persons = ref.read(personsProvider).value ?? [];

      if (instances.isEmpty && subInstances.isEmpty && persons.isEmpty) {
        throw Exception('Aucune donnée disponible pour l\'exportation');
      }

      // Convertir en JSON/CSV/Excel
      final filePath = await ExportService.exportToDownloads(
        instances: instances.map((e) => e.toJson()).toList(),
        subInstances: subInstances.map((e) => e.toJson()).toList(),
        persons: persons.map((e) => e.toJson()).toList(),
        format: format,
      );

      if (mounted && filePath != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Export ${format.name.toUpperCase()} réussi !\nFichier sauvegardé: ${filePath.split('/').last}',
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 4),
            action: SnackBarAction(
              label: 'OK',
              textColor: Colors.white,
              onPressed: () {},
            ),
          ),
        );
      } else {
        throw Exception('Erreur lors de la sauvegarde du fichier');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de l\'export: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }

  void _showAboutDialog() {
    context.go('/about');
  }
}
