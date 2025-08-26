import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/providers/app_providers.dart';
import '../../../../core/services/export_service.dart';
import '../../../../core/services/modal_service.dart';
import '../../../instances/models/instance.dart';
import '../../models/sub_instance.dart';
import '../widgets/add_sub_instance_dialog.dart';
import '../widgets/sub_instance_card.dart';

class SubInstancesPage extends ConsumerStatefulWidget {
  final int instanceId;

  const SubInstancesPage({super.key, required this.instanceId});

  @override
  ConsumerState<SubInstancesPage> createState() => _SubInstancesPageState();
}

class _SubInstancesPageState extends ConsumerState<SubInstancesPage> {
  Instance? _instance;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    // Load instance details
    final instance = await ref
        .read(instanceRepositoryProvider)
        .getInstanceById(widget.instanceId);
    if (instance != null) {
      setState(() {
        _instance = instance;
      });
    }

    // Load sub-instances
    ref
        .read(subInstancesByInstanceProvider(widget.instanceId).notifier)
        .loadSubInstances();
  }

  @override
  Widget build(BuildContext context) {
    final subInstancesAsync = ref.watch(
      subInstancesByInstanceProvider(widget.instanceId),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(_instance?.nom ?? 'Sous-instances'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.file_download),
            onPressed: _showExportOptions,
            tooltip: 'Exporter',
          ),
        ],
      ),
      body: subInstancesAsync.when(
        data: (subInstances) => subInstances.isEmpty
            ? Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.meeting_room,
                        size: 64,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Aucune sous-instance dans "${_instance?.nom ?? "cette instance"}"',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Appuyez sur le bouton + pour créer votre première sous-instance',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: subInstances.length,
                itemBuilder: (context, index) {
                  final subInstance = subInstances[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: SubInstanceCard(
                      subInstance: subInstance,
                      onTap: () => _navigateToPersons(subInstance),
                      onEdit: () => _editSubInstance(subInstance),
                      onDelete: () => _deleteSubInstance(subInstance),
                    ),
                  );
                },
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stackTrace) => Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  'Erreur: $err',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    ref
                        .read(
                          subInstancesByInstanceProvider(
                            widget.instanceId,
                          ).notifier,
                        )
                        .loadSubInstances();
                  },
                  child: const Text('Réessayer'),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddSubInstanceDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _navigateToPersons(SubInstance subInstance) {
    context.go('/persons/${subInstance.id}');
  }

  void _showAddSubInstanceDialog() {
    showDialog(
      context: context,
      builder: (context) => AddSubInstanceDialog(instanceId: widget.instanceId),
    );
  }

  void _editSubInstance(SubInstance subInstance) {
    showDialog(
      context: context,
      builder: (context) => AddSubInstanceDialog(
        instanceId: widget.instanceId,
        subInstance: subInstance,
      ),
    );
  }

  void _deleteSubInstance(SubInstance subInstance) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: Text(
          'Êtes-vous sûr de vouloir supprimer la sous-instance "${subInstance.nom}" ?\n\nCette action supprimera également toutes les personnes associées.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref
                  .read(
                    subInstancesByInstanceProvider(widget.instanceId).notifier,
                  )
                  .deleteSubInstance(subInstance.id);
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
      isScrollControlled: true,
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

            Text(
              'Exporter les données de "${_instance?.nom ?? "cette instance"}"',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFFCA1B49),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            _buildExportOption(
              icon: Icons.file_download,
              title: 'Export de l\'instance (JSON)',
              subtitle: 'Format JSON pour l\'intégration',
              onTap: () {
                Navigator.of(context).pop();
                _exportInstance(ExportFormat.json);
              },
            ),

            const SizedBox(height: 16),

            _buildExportOption(
              icon: Icons.table_chart,
              title: 'Export de l\'instance (CSV)',
              subtitle: 'Format CSV pour Excel',
              onTap: () {
                Navigator.of(context).pop();
                _exportInstance(ExportFormat.csv);
              },
            ),

            const SizedBox(height: 16),

            _buildExportOption(
              icon: Icons.table_chart,
              title: 'Export de l\'instance (Excel)',
              subtitle: 'Format Excel (.xlsx)',
              onTap: () {
                Navigator.of(context).pop();
                _exportInstance(ExportFormat.excel);
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

  void _exportInstance(ExportFormat format) async {
    try {
      // Charger les sub-instances et les personnes
      await ref
          .read(subInstancesByInstanceProvider(widget.instanceId).notifier)
          .loadSubInstances();
      await ref.read(personsProvider.notifier).loadPersons();

      // Récupérer les données
      final subInstances =
          ref.read(subInstancesByInstanceProvider(widget.instanceId)).value ??
          [];
      final personsList = ref.read(personsProvider).value ?? [];

      // Filtrer les personnes appartenant à cette instance
      final persons = personsList
          .where((p) => subInstances.any((si) => si.id == p.subInstanceId))
          .map((e) => e.toJson())
          .toList();

      if (subInstances.isEmpty && persons.isEmpty) {
        throw Exception('Aucune donnée disponible pour l\'exportation');
      }

      final filePath = await ExportService.exportInstance(
        subInstances: subInstances.map((e) => e.toJson()).toList(),
        persons: persons,
        format: format,
        instanceName: _instance?.nom ?? 'instance',
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
}
