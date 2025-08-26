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
  PersonType? _filterType;

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
      body: Column(
        children: [
          // Filter bar
          if (_instance != null) _buildFilterBar(),

          // Persons list
          Expanded(
            child: personsAsync.when(
              data: (persons) {
                final filteredPersons = _filterType != null
                    ? persons.where((p) => p.type == _filterType).toList()
                    : persons;

                if (filteredPersons.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.people, size: 64, color: Colors.grey),
                        const SizedBox(height: 16),
                        Text(
                          _filterType != null
                              ? 'Aucun ${_filterType == PersonType.etudiant ? 'étudiant' : 'employé'} dans "${_subInstance?.nom ?? "cette sous-instance"}"'
                              : 'Aucune personne dans "${_subInstance?.nom ?? "cette sous-instance"}"',
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
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
                  itemCount: filteredPersons.length,
                  itemBuilder: (context, index) {
                    final person = filteredPersons[index];
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
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddPerson(),
        backgroundColor: const Color(0xFFCA1B49),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildFilterBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Type d\'instance: ${_instance!.nom}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFFCA1B49),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildFilterChip(
                  'Tous',
                  null,
                  Icons.people,
                  Colors.grey,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildFilterChip(
                  'Étudiants',
                  PersonType.etudiant,
                  Icons.school,
                  const Color(0xFF4CAF50),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildFilterChip(
                  'Employés',
                  PersonType.employe,
                  Icons.business,
                  const Color(0xFF2196F3),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(
    String label,
    PersonType? type,
    IconData icon,
    Color color,
  ) {
    final isSelected = _filterType == type;

    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: isSelected ? Colors.white : color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : color,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _filterType = selected ? type : null;
        });
      },
      backgroundColor: Colors.white,
      selectedColor: color,
      checkmarkColor: Colors.white,
      side: BorderSide(color: color),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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

      final filteredPersons = _filterType != null
          ? persons.where((p) => p.type == _filterType).toList()
          : persons;

      if (filteredPersons.isEmpty) {
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
        filePath = await ExportService.exportToCsv(filteredPersons, fileName);
      } else {
        filePath = await ExportService.exportToExcel(filteredPersons, fileName);
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
