import 'package:hive_flutter/hive_flutter.dart';

import '../../../core/constants/app_constants.dart';
import '../models/sub_instance.dart';

class SubInstanceRepository {
  late Box<SubInstance> _subInstanceBox;

  Future<void> initialize() async {
    _subInstanceBox = await Hive.openBox<SubInstance>(
      AppConstants.subInstanceBoxName,
    );
  }

  Future<void> close() async {
    await _subInstanceBox.close();
  }

  // CRUD Operations
  Future<List<SubInstance>> getAllSubInstances() async {
    return _subInstanceBox.values.toList();
  }

  Future<List<SubInstance>> getSubInstancesByInstanceId(int instanceId) async {
    return _subInstanceBox.values
        .where((subInstance) => subInstance.instanceId == instanceId)
        .toList();
  }

  Future<SubInstance?> getSubInstanceById(int id) async {
    return _subInstanceBox.get(id);
  }

  Future<void> addSubInstance(SubInstance subInstance) async {
    await _subInstanceBox.put(subInstance.id, subInstance);
  }

  Future<void> updateSubInstance(SubInstance subInstance) async {
    await _subInstanceBox.put(subInstance.id, subInstance);
  }

  Future<void> deleteSubInstance(int id) async {
    await _subInstanceBox.delete(id);
  }

  Future<void> deleteSubInstancesByInstanceId(int instanceId) async {
    final subInstances = await getSubInstancesByInstanceId(instanceId);
    for (final subInstance in subInstances) {
      await _subInstanceBox.delete(subInstance.id);
    }
  }

  Future<int> getNextId() async {
    if (_subInstanceBox.isEmpty) return 1;

    // Trouver l'ID maximum existant et ajouter 1
    int maxId = 0;
    for (final subInstance in _subInstanceBox.values) {
      if (subInstance.id > maxId) {
        maxId = subInstance.id;
      }
    }

    // S'assurer que l'ID est dans la plage valide pour Hive (0x00 à 0xffffff)
    int nextId = maxId + 1;
    if (nextId > 0xffffff) {
      // Si on dépasse la limite, chercher un ID libre
      nextId = 1;
      while (_subInstanceBox.containsKey(nextId)) {
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
    return _subInstanceBox.values
        .map((subInstance) => subInstance.toJson())
        .toList();
  }

  Future<List<Map<String, dynamic>>> exportToCsv() async {
    return _subInstanceBox.values
        .map(
          (subInstance) => {
            'ID': subInstance.id,
            'ID Instance': subInstance.instanceId,
            'Nom': subInstance.nom,
            'Date de création': subInstance.dateCreation.toIso8601String(),
            'Description': subInstance.description ?? '',
          },
        )
        .toList();
  }

  Future<List<Map<String, dynamic>>> exportByInstanceIdToJson(
    int instanceId,
  ) async {
    final subInstances = await getSubInstancesByInstanceId(instanceId);
    return subInstances.map((subInstance) => subInstance.toJson()).toList();
  }

  Future<List<Map<String, dynamic>>> exportByInstanceIdToCsv(
    int instanceId,
  ) async {
    final subInstances = await getSubInstancesByInstanceId(instanceId);
    return subInstances
        .map(
          (subInstance) => {
            'ID': subInstance.id,
            'ID Instance': subInstance.instanceId,
            'Nom': subInstance.nom,
            'Date de création': subInstance.dateCreation.toIso8601String(),
            'Description': subInstance.description ?? '',
          },
        )
        .toList();
  }
}
