import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/providers/app_providers.dart';
import '../../../sub_instances/models/sub_instance.dart';
import '../../models/person.dart';

class EditPersonPage extends ConsumerStatefulWidget {
  final int personId;

  const EditPersonPage({super.key, required this.personId});

  @override
  ConsumerState<EditPersonPage> createState() => _EditPersonPageState();
}

class _EditPersonPageState extends ConsumerState<EditPersonPage> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  bool _isLoading = false;

  // Form data
  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _structureController = TextEditingController();
  final _fonctionController = TextEditingController();
  final _matriculeController = TextEditingController();
  final _niveauController = TextEditingController();
  final _filiereController = TextEditingController();
  String? _photoPath;

  Person? _person;
  SubInstance? _subInstance;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _nomController.dispose();
    _prenomController.dispose();
    _structureController.dispose();
    _fonctionController.dispose();
    _matriculeController.dispose();
    _niveauController.dispose();
    _filiereController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Charger les données de la personne
      final person = await ref
          .read(personRepositoryProvider)
          .getPersonById(widget.personId);
      if (person != null) {
        setState(() {
          _person = person;
          _nomController.text = person.nom;
          _prenomController.text = person.prenom;
          _structureController.text = person.structure ?? '';
          _fonctionController.text = person.fonction ?? '';
          _matriculeController.text = person.matricule;
          _niveauController.text = person.niveau ?? '';
          _filiereController.text = person.filiere ?? '';
          _photoPath = person.photoPath;
        });

        // Charger les détails de la sous-instance
        final subInstance = await ref
            .read(subInstanceRepositoryProvider)
            .getSubInstanceById(person.subInstanceId);
        if (subInstance != null) {
          setState(() {
            _subInstance = subInstance;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors du chargement: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_person == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Personne non trouvée'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.go('/'),
          ),
        ),
        body: const Center(child: Text('La personne demandée n\'existe pas.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Quick ID - Modifier un ${_person!.typeDisplayName} - ${_subInstance?.nom ?? ''}',
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/persons/${_person!.subInstanceId}'),
        ),
      ),
      body: Column(
        children: [
          // Progress indicator
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                for (int i = 0; i < 3; i++)
                  Expanded(
                    child: Container(
                      height: 4,
                      margin: EdgeInsets.only(right: i < 2 ? 8 : 0),
                      decoration: BoxDecoration(
                        color: i <= _currentStep
                            ? const Color(0xFFCA1B49)
                            : Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Step indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStepIndicator(0, 'Informations', Icons.person),
                _buildStepIndicator(1, 'Photo', Icons.camera_alt),
                _buildStepIndicator(2, 'Résumé', Icons.check_circle),
              ],
            ),
          ),

          // Content
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: _personalInfoStep(),
                ),
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: _photoStep(),
                ),
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: _summaryStep(),
                ),
              ],
            ),
          ),

          // Navigation buttons
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                if (_currentStep > 0)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _previousStep,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: Color(0xFFCA1B49)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Précédent'),
                    ),
                  ),
                if (_currentStep > 0) const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _nextStep,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFCA1B49),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : Text(_currentStep == 2 ? 'Enregistrer' : 'Suivant'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- PERSONAL INFO STEP ---
  Widget _personalInfoStep() {
    if (_person!.isEtudiant) {
      return _buildStudentForm();
    } else {
      return _buildEmployeeForm();
    }
  }

  Widget _buildStudentForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildField('Nom', _nomController),
        _buildField('Prénom', _prenomController),
        _buildField('Matricule', _matriculeController),
        _buildField('Niveau', _niveauController, isReadOnly: true),
        _buildField('Filière', _filiereController),
      ],
    );
  }

  Widget _buildEmployeeForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildField('Nom', _nomController),
        _buildField('Prénom', _prenomController),
        _buildField('Structure', _structureController, isReadOnly: true),
        _buildField('Fonction', _fonctionController),
        _buildField('Matricule', _matriculeController),
      ],
    );
  }

  Widget _buildField(
    String label,
    TextEditingController controller, {
    bool isReadOnly = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        readOnly: isReadOnly,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          filled: isReadOnly,
          fillColor: isReadOnly ? Colors.grey[100] : null,
        ),
      ),
    );
  }

  // --- PHOTO STEP ---
  Widget _photoStep() {
    return Column(
      children: [
        _photoPath != null
            ? Image.file(
                File(_photoPath!),
                width: 200,
                height: 200,
                fit: BoxFit.cover,
              )
            : const SizedBox(
                width: 200,
                height: 200,
                child: Icon(Icons.person, size: 100, color: Colors.grey),
              ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.camera_alt),
                label: const Text('Prendre une photo'),
                onPressed: () async {
                  // Implémentation de la prise de photo
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.photo),
                label: const Text('Choisir depuis la galerie'),
                onPressed: () async {
                  // Implémentation de la sélection depuis la galerie
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  // --- SUMMARY STEP ---
  Widget _summaryStep() {
    if (_person!.isEtudiant) {
      return Column(
        children: [
          _summaryCard('Nom', _nomController.text),
          _summaryCard('Prénom', _prenomController.text),
          _summaryCard('Matricule', _matriculeController.text),
          _summaryCard('Niveau', _niveauController.text),
          _summaryCard('Filière', _filiereController.text),
          if (_photoPath != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Image.file(
                File(_photoPath!),
                width: 200,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
        ],
      );
    } else {
      return Column(
        children: [
          _summaryCard('Nom', _nomController.text),
          _summaryCard('Prénom', _prenomController.text),
          _summaryCard('Structure', _structureController.text),
          _summaryCard('Fonction', _fonctionController.text),
          _summaryCard('Matricule', _matriculeController.text),
          if (_photoPath != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Image.file(
                File(_photoPath!),
                width: 200,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
        ],
      );
    }
  }

  Widget _summaryCard(String label, String value) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(value),
      ),
    );
  }

  Widget _buildStepIndicator(int step, String label, IconData icon) {
    final isActive = step == _currentStep;
    final isCompleted = step < _currentStep;

    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isCompleted
                ? const Color(0xFFCA1B49)
                : isActive
                ? const Color(0xFFCA1B49).withValues(alpha: 0.2)
                : Colors.grey[300],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(
            icon,
            color: isCompleted
                ? Colors.white
                : isActive
                ? const Color(0xFFCA1B49)
                : Colors.grey,
            size: 20,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            color: isActive ? const Color(0xFFCA1B49) : Colors.grey,
          ),
        ),
      ],
    );
  }

  void _nextStep() async {
    if (_currentStep < 2) {
      if (await _validateCurrentStep()) {
        setState(() {
          _currentStep++;
        });
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    } else {
      _savePerson();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<bool> _validateCurrentStep() async {
    switch (_currentStep) {
      case 0:
        if (_person!.isEtudiant) {
          if (_nomController.text.trim().isEmpty ||
              _prenomController.text.trim().isEmpty ||
              _matriculeController.text.trim().isEmpty ||
              _filiereController.text.trim().isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Veuillez remplir tous les champs obligatoires'),
                backgroundColor: Colors.red,
              ),
            );
            return false;
          }
        } else {
          if (_nomController.text.trim().isEmpty ||
              _prenomController.text.trim().isEmpty ||
              _fonctionController.text.trim().isEmpty ||
              _matriculeController.text.trim().isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Veuillez remplir tous les champs obligatoires'),
                backgroundColor: Colors.red,
              ),
            );
            return false;
          }
        }
        break;
      case 1:
        if (_photoPath == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('La photo est obligatoire'),
              backgroundColor: Colors.red,
            ),
          );
          return false;
        }
        break;
    }
    return true;
  }

  Future<void> _savePerson() async {
    if (!await _validateCurrentStep()) return;

    setState(() => _isLoading = true);

    try {
      final updatedPerson = _person!.copyWith(
        nom: _nomController.text.trim(),
        prenom: _prenomController.text.trim(),
        structure: _person!.isEmploye ? _structureController.text.trim() : null,
        fonction: _person!.isEmploye ? _fonctionController.text.trim() : null,
        matricule: _matriculeController.text.trim(),
        niveau: _person!.isEtudiant ? _niveauController.text.trim() : null,
        filiere: _person!.isEtudiant ? _filiereController.text.trim() : null,
        photoPath: _photoPath!,
      );

      await ref.read(personRepositoryProvider).updatePerson(updatedPerson);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Personne modifiée avec succès'),
            backgroundColor: Color(0xFFCA1B49),
          ),
        );
        context.go('/persons/${_person!.subInstanceId}');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de la modification: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}
