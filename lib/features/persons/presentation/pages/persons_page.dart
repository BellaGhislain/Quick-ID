import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/providers/app_providers.dart';
import '../../../../core/services/export_service.dart';
import '../../../../core/services/modal_service.dart';
import '../../../instances/models/instance.dart';
import '../../../sub_instances/models/sub_instance.dart';
import '../../models/person.dart';
import '../widgets/person_card.dart';

class PersonsPage extends ConsumerStatefulWidget {
  final int subInstanceId;

  const PersonsPage({super.key, required this.subInstanceId});

  @override
  ConsumerState<PersonsPage> createState() => _PersonsPageState();
}

class _PersonsPageState extends ConsumerState<PersonsPage> {
  SubInstance? _subInstance;
  Instance? _instance;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    // Load sub-instance details
    final subInstance = await ref
        .read(subInstanceRepositoryProvider)
        .getSubInstanceById(widget.subInstanceId);
    if (subInstance != null) {
      setState(() {
        _subInstance = subInstance;
      });

      // Load instance details
      final instance = await ref
          .read(instanceRepositoryProvider)
          .getInstanceById(subInstance.instanceId);
      if (instance != null) {
        setState(() {
          _instance = instance;
        });
      }
    }

    // Load persons
    ref
        .read(personsBySubInstanceProvider(widget.subInstanceId).notifier)
        .loadPersons();
  }

  @override
  Widget build(BuildContext context) {
    final personsAsync = ref.watch(
      personsBySubInstanceProvider(widget.subInstanceId),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(_subInstance?.nom ?? 'Personnes'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/sub-instances/${_instance?.id ?? 0}'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.file_download),
            onPressed: _showExportOptions,
            tooltip: 'Exporter',
          ),
        ],
      ),
      body: personsAsync.when(
        data: (persons) => persons.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.people, size: 64, color: Colors.grey),
                    const SizedBox(height: 16),
                    Text(
                      'Aucune personne dans "${_subInstance?.nom ?? "cette sous-instance"}"',
                      style: const TextStyle(fontSize: 18, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Appuyez sur le bouton + pour enregistrer votre première personne',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: persons.length,
                itemBuilder: (context, index) {
                  final person = persons[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: PersonCard(
                      person: person,
                      onEdit: () => _editPerson(person),
                      onDelete: () => _deletePerson(person),
                    ),
                  );
                },
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stackTrace) => Center(
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
                        personsBySubInstanceProvider(
                          widget.subInstanceId,
                        ).notifier,
                      )
                      .loadPersons();
                },
                child: const Text('Réessayer'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddPerson(),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _navigateToAddPerson() {
    context.go('/add-person/${widget.subInstanceId}');
  }

  void _editPerson(Person person) {
    // Naviguer vers la page d'édition avec les données de la personne
    context.go('/edit-person/${person.id}');
  }

  void _deletePerson(Person person) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: Text(
          'Êtes-vous sûr de vouloir supprimer "${person.prenom} ${person.nom}" ?',
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
                    personsBySubInstanceProvider(widget.subInstanceId).notifier,
                  )
                  .deletePerson(person.id);
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
              'Exporter les données de "${_subInstance?.nom ?? "cette sous-instance"}"',
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
              title: 'Export de la sous-instance (JSON)',
              subtitle: 'Format JSON pour l\'intégration',
              onTap: () {
                Navigator.of(context).pop();
                _exportSubInstance(ExportFormat.json);
              },
            ),

            const SizedBox(height: 16),

            _buildExportOption(
              icon: Icons.table_chart,
              title: 'Export de la sous-instance (CSV)',
              subtitle: 'Format CSV pour Excel',
              onTap: () {
                Navigator.of(context).pop();
                _exportSubInstance(ExportFormat.csv);
              },
            ),

            const SizedBox(height: 16),

            _buildExportOption(
              icon: Icons.table_chart,
              title: 'Export de la sous-instance (Excel)',
              subtitle: 'Format Excel (.xlsx)',
              onTap: () {
                Navigator.of(context).pop();
                _exportSubInstance(ExportFormat.excel);
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

  void _exportSubInstance(ExportFormat format) async {
    try {
      final personsAsync = ref.read(
        personsBySubInstanceProvider(widget.subInstanceId),
      );

      if (personsAsync.hasValue) {
        final persons = personsAsync.value!.map((e) => e.toJson()).toList();

        final filePath = await ExportService.exportSubInstance(
          persons: persons,
          format: format,
          instanceName: _instance?.nom ?? 'instance',
          subInstanceName: _subInstance?.nom ?? 'sous-instance',
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
      } else {
        throw Exception('Données non disponibles');
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
