import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quick_id/core/services/image_service.dart';

import '../../../../core/providers/app_providers.dart';
import '../../../instances/models/instance.dart';
import '../../../sub_instances/models/sub_instance.dart';
import '../../models/person.dart';

class AddPersonPage extends ConsumerStatefulWidget {
  final int subInstanceId;
  final PersonType? personType;

  const AddPersonPage({
    super.key,
    required this.subInstanceId,
    this.personType,
  });

  @override
  ConsumerState<AddPersonPage> createState() => _AddPersonPageState();
}

class _AddPersonPageState extends ConsumerState<AddPersonPage> {
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

  // Data for pre-filling
  SubInstance? _subInstance;
  Instance? _instance;
  PersonType? _selectedType;

  @override
  void initState() {
    super.initState();
    _selectedType = widget.personType;
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
    final subInstance = await ref
        .read(subInstanceRepositoryProvider)
        .getSubInstanceById(widget.subInstanceId);

    if (subInstance != null) {
      final instance = await ref
          .read(instanceRepositoryProvider)
          .getInstanceById(subInstance.instanceId);

      setState(() {
        _subInstance = subInstance;
        _instance = instance;
      });

      // Pre-fill fields based on hierarchy
      _prefillFields();
    }
  }

  void _prefillFields() {
    if (_selectedType == PersonType.etudiant) {
      // Pour les étudiants : niveau = nom de la sub-instance
      if (_subInstance != null) {
        _niveauController.text = _subInstance!.nom;
      }
    } else if (_selectedType == PersonType.employe) {
      // Pour les employés : structure = nom de la sub-instance
      if (_subInstance != null) {
        _structureController.text = _subInstance!.nom;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedType == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Quick ID - Type de personne'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.go('/persons/${widget.subInstanceId}'),
          ),
        ),
        body: _buildTypeSelection(),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Quick ID - Ajouter un ${_selectedType == PersonType.etudiant ? 'étudiant' : 'employé'} - ${_subInstance?.nom ?? ''}',
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/persons/${widget.subInstanceId}'),
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

  Widget _buildTypeSelection() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Quel type de personne souhaitez-vous ajouter ?',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFFCA1B49),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),

          // Option Étudiant
          _buildTypeCard(
            PersonType.etudiant,
            'Étudiant',
            'Pour les écoles et établissements d\'enseignement',
            Icons.school,
            const Color(0xFF4CAF50),
          ),

          const SizedBox(height: 24),

          // Option Employé
          _buildTypeCard(
            PersonType.employe,
            'Employé',
            'Pour les entreprises et organisations',
            Icons.business,
            const Color(0xFF2196F3),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeCard(
    PersonType type,
    String title,
    String description,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedType = type;
          });
          _prefillFields();
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Icon(icon, size: 40, color: color),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- PERSONAL INFO STEP ---
  Widget _personalInfoStep() {
    if (_selectedType == PersonType.etudiant) {
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
                  final path = await ImageService.takePhoto();
                  if (path != null) {
                    final savedPath = await ImageService.savePhotoWithName(
                      path,
                      _nomController.text.trim(),
                      _prenomController.text.trim(),
                    );
                    if (savedPath != null &&
                        await ImageService.imageExists(savedPath)) {
                      setState(() {
                        _photoPath = savedPath;
                      });
                    }
                  }
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.photo),
                label: const Text('Choisir depuis la galerie'),
                onPressed: () async {
                  final path = await ImageService.pickFromGallery();
                  if (path != null) {
                    final savedPath = await ImageService.savePhotoWithName(
                      path,
                      _nomController.text.trim(),
                      _prenomController.text.trim(),
                    );
                    if (savedPath != null &&
                        await ImageService.imageExists(savedPath)) {
                      setState(() {
                        _photoPath = savedPath;
                      });
                    }
                  }
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
    if (_selectedType == PersonType.etudiant) {
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
                ? const Color(0xFFCA1B49).withOpacity(0.2)
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
        if (_selectedType == PersonType.etudiant) {
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
        if (_photoPath == null ||
            !(await ImageService.imageExists(_photoPath!))) {
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
      final nextId = await ref.read(personRepositoryProvider).getNextId();

      final person = Person(
        id: nextId,
        subInstanceId: widget.subInstanceId,
        nom: _nomController.text.trim(),
        prenom: _prenomController.text.trim(),
        structure: _selectedType == PersonType.employe
            ? _structureController.text.trim()
            : null,
        fonction: _selectedType == PersonType.employe
            ? _fonctionController.text.trim()
            : null,
        matricule: _matriculeController.text.trim(),
        niveau: _selectedType == PersonType.etudiant
            ? _niveauController.text.trim()
            : null,
        filiere: _selectedType == PersonType.etudiant
            ? _filiereController.text.trim()
            : null,
        photoPath: _photoPath!,
        dateCreation: DateTime.now(),
        type: _selectedType!,
      );

      await ref.read(personRepositoryProvider).addPerson(person);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Personne enregistrée avec succès'),
            backgroundColor: Color(0xFFCA1B49),
          ),
        );
        context.go('/persons/${widget.subInstanceId}');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de l\'enregistrement: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}
