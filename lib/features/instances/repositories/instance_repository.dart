import 'package:hive_flutter/hive_flutter.dart';

import '../../../core/constants/app_constants.dart';
import '../models/instance.dart';

class InstanceRepository {
  late Box<Instance> _instanceBox;

  Future<void> initialize() async {
    _instanceBox = await Hive.openBox<Instance>(AppConstants.instanceBoxName);
  }

  Future<void> close() async {
    await _instanceBox.close();
  }

  // CRUD Operations
  Future<List<Instance>> getAllInstances() async {
    return _instanceBox.values.toList();
  }

  Future<Instance?> getInstanceById(int id) async {
    return _instanceBox.get(id);
  }

  Future<void> addInstance(Instance instance) async {
    await _instanceBox.put(instance.id, instance);
  }

  Future<void> updateInstance(Instance instance) async {
    await _instanceBox.put(instance.id, instance);
  }

  Future<void> deleteInstance(int id) async {
    await _instanceBox.delete(id);
  }

  Future<int> getNextId() async {
    if (_instanceBox.isEmpty) return 1;

    // Trouver l'ID maximum existant et ajouter 1
    int maxId = 0;
    for (final instance in _instanceBox.values) {
      if (instance.id > maxId) {
        maxId = instance.id;
      }
    }

    // S'assurer que l'ID est dans la plage valide pour Hive (0x00 à 0xffffff)
    int nextId = maxId + 1;
    if (nextId > 0xffffff) {
      // Si on dépasse la limite, chercher un ID libre
      nextId = 1;
      while (_instanceBox.containsKey(nextId)) {
        nextId++;
        if (nextId > 0xffffff) {
          throw Exception(
            'Impossible de générer un nouvel ID - limite Hive atteinte',
          );
        }
      }
    }

    return nextId;
  }

  // Export operations
  Future<List<Map<String, dynamic>>> exportToJson() async {
    return _instanceBox.values.map((instance) => instance.toJson()).toList();
  }

  Future<List<Map<String, dynamic>>> exportToCsv() async {
    return _instanceBox.values
        .map(
          (instance) => {
            'ID': instance.id,
            'Nom': instance.nom,
            'Date de création': instance.dateCreation.toIso8601String(),
            'Description': instance.description ?? '',
          },
        )
        .toList();
  }
}
