import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/app_providers.dart';
import '../../models/sub_instance.dart';

class AddSubInstanceDialog extends ConsumerStatefulWidget {
  final int instanceId;
  final SubInstance? subInstance;

  const AddSubInstanceDialog({super.key, required this.instanceId, this.subInstance});

  @override
  ConsumerState<AddSubInstanceDialog> createState() => _AddSubInstanceDialogState();
}

class _AddSubInstanceDialogState extends ConsumerState<AddSubInstanceDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nomController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.subInstance != null) {
      _nomController.text = widget.subInstance!.nom;
      _descriptionController.text = widget.subInstance!.description ?? '';
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
      title: Text(
        widget.subInstance == null ? 'Nouvelle sous-instance' : 'Modifier la sous-instance',
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nomController,
              decoration: const InputDecoration(
                labelText: 'Nom *',
                hintText: 'Ex: Classe 6A, Département RH',
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
                hintText: 'Description optionnelle de la sous-instance',
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
          onPressed: _isLoading ? null : _saveSubInstance,
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(widget.subInstance == null ? 'Créer' : 'Modifier'),
        ),
      ],
    );
  }

  Future<void> _saveSubInstance() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      if (widget.subInstance == null) {
        // Create new sub-instance
        final nextId = await ref.read(subInstanceRepositoryProvider).getNextId();
        final newSubInstance = SubInstance(
          id: nextId,
          instanceId: widget.instanceId,
          nom: _nomController.text.trim(),
          description: _descriptionController.text.trim().isEmpty
              ? null
              : _descriptionController.text.trim(),
          dateCreation: DateTime.now(),
        );
        await ref
            .read(subInstancesByInstanceProvider(widget.instanceId).notifier)
            .addSubInstance(newSubInstance);
      } else {
        // Update existing sub-instance
        final updatedSubInstance = widget.subInstance!.copyWith(
          nom: _nomController.text.trim(),
          description: _descriptionController.text.trim().isEmpty
              ? null
              : _descriptionController.text.trim(),
        );
        await ref
            .read(subInstancesByInstanceProvider(widget.instanceId).notifier)
            .updateSubInstance(updatedSubInstance);
      }

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.subInstance == null
                  ? 'Sous-instance créée avec succès'
                  : 'Sous-instance modifiée avec succès',
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
