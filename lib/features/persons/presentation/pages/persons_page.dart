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
        data: (persons) {
          if (persons.isEmpty) {
            return Center(
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
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: persons.length,
            itemBuilder: (context, index) {
              final person = persons[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: PersonCard(
                  person: person,
                  onTap: () => _navigateToEditPerson(person),
                  onDelete: () => _deletePerson(person),
                ),
              );
            },
          );
        },
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
        onPressed: () => _navigateToAddPerson(),
        backgroundColor: const Color(0xFFCA1B49),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _navigateToAddPerson() {
    context.go('/add-person/${widget.subInstanceId}');
  }

  void _navigateToEditPerson(Person person) {
    context.go('/edit-person/${person.id}');
  }

  Future<void> _deletePerson(Person person) async {
    final confirmed = await ModalService.showConfirmationDialog(
      context: context,
      title: 'Confirmer la suppression',
      content:
          'Êtes-vous sûr de vouloir supprimer ${person.prenom} ${person.nom} ?',
      confirmText: 'Supprimer',
      cancelText: 'Annuler',
    );

    if (confirmed) {
      try {
        await ref.read(personRepositoryProvider).deletePerson(person.id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Personne supprimée avec succès'),
              backgroundColor: Color(0xFFCA1B49),
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erreur lors de la suppression: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  void _showExportOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Exporter les données',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.table_chart),
                    label: const Text('CSV'),
                    onPressed: () {
                      Navigator.pop(context);
                      _exportData('csv');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFCA1B49),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.table_view),
                    label: const Text('Excel'),
                    onPressed: () {
                      Navigator.pop(context);
                      _exportData('excel');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFCA1B49),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _exportData(String format) async {
    try {
      final persons = await ref
          .read(personRepositoryProvider)
          .getPersonsBySubInstance(widget.subInstanceId);

      if (persons.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Aucune donnée à exporter'),
              backgroundColor: Colors.orange,
            ),
          );
        }
        return;
      }

      final fileName =
          '${_subInstance?.nom ?? 'personnes'}_${DateTime.now().millisecondsSinceEpoch}';

      String? filePath;
      if (format == 'csv') {
        filePath = await ExportService.exportToCsv(persons, fileName);
      } else {
        filePath = await ExportService.exportToExcel(persons, fileName);
      }

      if (filePath != null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Données exportées en $format avec succès'),
                  const SizedBox(height: 4),
                  Text(
                    'Fichier: ${filePath.split('/').last}',
                    style: const TextStyle(fontSize: 12),
                  ),
                  Text(
                    'Chemin: $filePath',
                    style: const TextStyle(fontSize: 10),
                  ),
                ],
              ),
              backgroundColor: const Color(0xFFCA1B49),
              duration: const Duration(seconds: 5),
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erreur: Impossible d\'exporter en $format'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      print('Erreur lors de l\'export: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de l\'export: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
