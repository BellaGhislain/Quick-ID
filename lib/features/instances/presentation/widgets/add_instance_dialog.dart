import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/app_providers.dart';
import '../../models/instance.dart';

class AddInstanceDialog extends ConsumerStatefulWidget {
  final Instance? instance;

  const AddInstanceDialog({super.key, this.instance});

  @override
  ConsumerState<AddInstanceDialog> createState() => _AddInstanceDialogState();
}

class _AddInstanceDialogState extends ConsumerState<AddInstanceDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nomController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.instance != null) {
      _nomController.text = widget.instance!.nom;
      _descriptionController.text = widget.instance!.description ?? '';
    }
  }

  @override
  void dispose() {
    _nomController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.instance == null ? 'Nouvelle instance' : 'Modifier l\'instance'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nomController,
              decoration: const InputDecoration(
                labelText: 'Nom *',
                hintText: 'Ex: École primaire, Entreprise ABC',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Le nom est requis';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Description optionnelle de l\'instance',
              ),
              maxLines: 3,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text('Annuler'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _saveInstance,
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(widget.instance == null ? 'Créer' : 'Modifier'),
        ),
      ],
    );
  }

  Future<void> _saveInstance() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      if (widget.instance == null) {
        // Create new instance
        final nextId = await ref.read(instanceRepositoryProvider).getNextId();
        final newInstance = Instance(
          id: nextId,
          nom: _nomController.text.trim(),
          description: _descriptionController.text.trim().isEmpty
              ? null
              : _descriptionController.text.trim(),
          dateCreation: DateTime.now(),
        );
        await ref.read(instancesProvider.notifier).addInstance(newInstance);
      } else {
        // Update existing instance
        final updatedInstance = widget.instance!.copyWith(
          nom: _nomController.text.trim(),
          description: _descriptionController.text.trim().isEmpty
              ? null
              : _descriptionController.text.trim(),
        );
        await ref.read(instancesProvider.notifier).updateInstance(updatedInstance);
      }

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.instance == null
                  ? 'Instance créée avec succès'
                  : 'Instance modifiée avec succès',
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erreur: $e'), backgroundColor: Colors.red));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}




