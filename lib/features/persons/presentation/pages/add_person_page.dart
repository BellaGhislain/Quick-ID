import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quick_id/core/services/image_service.dart';

import '../../../../core/providers/app_providers.dart';
import '../../../sub_instances/models/sub_instance.dart';
import '../../models/person.dart';

class AddPersonPage extends ConsumerStatefulWidget {
  final int subInstanceId;

  const AddPersonPage({super.key, required this.subInstanceId});

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
    final subInstance = await ref
        .read(subInstanceRepositoryProvider)
        .getSubInstanceById(widget.subInstanceId);
    if (subInstance != null) {
      setState(() {
        _subInstance = subInstance;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Quick ID - Ajouter une personne - ${_subInstance?.nom ?? ''}',
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

  // --- PERSONAL INFO STEP ---
  Widget _personalInfoStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildField('Nom', _nomController),
        _buildField('Prénom', _prenomController),
        _buildField('Structure', _structureController),
        _buildField('Fonction', _fonctionController),
        _buildField('Matricule', _matriculeController),
        _buildField('Niveau', _niveauController),
        _buildField('Filière', _filiereController),
      ],
    );
  }

  Widget _buildField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
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
    return Column(
      children: [
        _summaryCard('Nom', _nomController.text),
        _summaryCard('Prénom', _prenomController.text),
        _summaryCard('Structure', _structureController.text),
        _summaryCard('Fonction', _fonctionController.text),
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
        if (_nomController.text.trim().isEmpty ||
            _prenomController.text.trim().isEmpty ||
            _structureController.text.trim().isEmpty ||
            _fonctionController.text.trim().isEmpty ||
            _matriculeController.text.trim().isEmpty ||
            _niveauController.text.trim().isEmpty ||
            _filiereController.text.trim().isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Veuillez remplir tous les champs obligatoires'),
              backgroundColor: Colors.red,
            ),
          );
          return false;
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
        structure: _structureController.text.trim(),
        fonction: _fonctionController.text.trim(),
        matricule: _matriculeController.text.trim(),
        niveau: _niveauController.text.trim(),
        filiere: _filiereController.text.trim(),
        photoPath: _photoPath!,
        dateCreation: DateTime.now(),
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
