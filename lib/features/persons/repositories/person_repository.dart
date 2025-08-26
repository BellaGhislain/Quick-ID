import 'package:hive_flutter/hive_flutter.dart';

import '../../../core/constants/app_constants.dart';
import '../models/person.dart';

class PersonRepository {
  late Box<Person> _personBox;

  Future<void> initialize() async {
    _personBox = await Hive.openBox<Person>(AppConstants.personBoxName);
  }

  Future<void> close() async {
    await _personBox.close();
  }

  // CRUD Operations
  Future<List<Person>> getAllPersons() async {
    return _personBox.values.toList();
  }

  Future<List<Person>> getPersonsBySubInstanceId(int subInstanceId) async {
    return _personBox.values
        .where((person) => person.subInstanceId == subInstanceId)
        .toList();
  }

  Future<List<Person>> getPersonsBySubInstance(int subInstanceId) async {
    return getPersonsBySubInstanceId(subInstanceId);
  }

  Future<List<Person>> getPersonsByInstanceId(int instanceId) async {
    // This would require joining with SubInstance data
    // For now, we'll implement a simpler approach
    return _personBox.values.toList();
  }

  Future<Person?> getPersonById(int id) async {
    return _personBox.get(id);
  }

  Future<void> addPerson(Person person) async {
    await _personBox.put(person.id, person);
  }

  Future<void> updatePerson(Person person) async {
    await _personBox.put(person.id, person);
  }

  Future<void> deletePerson(int id) async {
    await _personBox.delete(id);
  }

  Future<void> deletePersonsBySubInstanceId(int subInstanceId) async {
    final persons = await getPersonsBySubInstanceId(subInstanceId);
    for (final person in persons) {
      await _personBox.delete(person.id);
    }
  }

  Future<int> getNextId() async {
    if (_personBox.isEmpty) return 1;

    // Trouver l'ID maximum existant et ajouter 1
    int maxId = 0;
    for (final person in _personBox.values) {
      if (person.id > maxId) {
        maxId = person.id;
      }
    }

    // S'assurer que l'ID est dans la plage valide pour Hive (0x00 à 0xffffff)
    int nextId = maxId + 1;
    if (nextId > 0xffffff) {
      // Si on dépasse la limite, chercher un ID libre
      nextId = 1;
      while (_personBox.containsKey(nextId)) {
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
    return _personBox.values.map((person) => person.toJson()).toList();
  }

  Future<List<Map<String, dynamic>>> exportToCsv() async {
    return _personBox.values
        .map(
          (person) => {
            'ID': person.id,
            'ID Sous-instance': person.subInstanceId,
            'Nom': person.nom,
            'Prénom': person.prenom,
            'Structure': person.structure,
            'Fonction': person.fonction,
            'Matricule': person.matricule,
            'Niveau': person.niveau,
            'Filière': person.filiere,
            'Chemin photo': person.photoPath,
            'Date de création': person.dateCreation.toIso8601String(),
          },
        )
        .toList();
  }

  Future<List<Map<String, dynamic>>> exportBySubInstanceIdToJson(
    int subInstanceId,
  ) async {
    final persons = await getPersonsBySubInstanceId(subInstanceId);
    return persons.map((person) => person.toJson()).toList();
  }

  Future<List<Map<String, dynamic>>> exportBySubInstanceIdToCsv(
    int subInstanceId,
  ) async {
    final persons = await getPersonsBySubInstanceId(subInstanceId);
    return persons
        .map(
          (person) => {
            'ID': person.id,
            'ID Sous-instance': person.subInstanceId,
            'Nom': person.nom,
            'Prénom': person.prenom,
            'Structure': person.structure,
            'Fonction': person.fonction,
            'Matricule': person.matricule,
            'Niveau': person.niveau,
            'Filière': person.filiere,
            'Chemin photo': person.photoPath,
            'Date de création': person.dateCreation.toIso8601String(),
          },
        )
        .toList();
  }

  Future<List<Map<String, dynamic>>> exportByInstanceIdToJson(
    int instanceId,
  ) async {
    // This would require joining with SubInstance data
    // For now, return all persons
    return exportToJson();
  }

  Future<List<Map<String, dynamic>>> exportByInstanceIdToCsv(
    int instanceId,
  ) async {
    // This would require joining with SubInstance data
    // For now, return all persons
    return exportToCsv();
  }
}
