import 'package:hive_flutter/hive_flutter.dart';

import '../../../core/constants/app_constants.dart';
import '../models/person.dart';

class PersonRepository {
  late Box<Person> _personBox;

  Future<void> initialize() async {
    try {
      print('🔄 Initialisation du PersonRepository...');
      print('Ouverture de la box Hive: ${AppConstants.personBoxName}');

      _personBox = await Hive.openBox<Person>(AppConstants.personBoxName);
      print('✅ Box Hive ouverte avec succès');
      print('Nombre d\'éléments dans la box: ${_personBox.length}');

      // Migration des anciennes données qui n'ont pas le champ 'type'
      print('🔄 Début de la migration des données...');
      await _migrateOldData();
      print('✅ Migration terminée');
    } catch (e, stackTrace) {
      print('❌ ERREUR CRITIQUE lors de l\'initialisation du PersonRepository:');
      print('Erreur: $e');
      print('Stack trace: $stackTrace');
      // En cas d'erreur, on continue pour ne pas bloquer l'application
      // Mais on essaie quand même d'ouvrir la box
      try {
        _personBox = await Hive.openBox<Person>(AppConstants.personBoxName);
        print('✅ Box Hive ouverte en mode dégradé');
      } catch (e2) {
        print('❌ Impossible d\'ouvrir la box Hive: $e2');
        rethrow; // On relance l'erreur car c'est critique
      }
    }
  }

  Future<void> _migrateOldData() async {
    try {
      print('=== DÉBUT DE LA MIGRATION DES DONNÉES ===');
      final persons = _personBox.values.toList();
      print('Nombre de personnes trouvées: ${persons.length}');

      bool hasChanges = false;

      for (int i = 0; i < persons.length; i++) {
        final person = persons[i];
        print('--- Traitement personne $i (ID: ${person.id}) ---');
        print('Type actuel: ${person.type}');
        print('Structure: ${person.structure}');
        print('Fonction: ${person.fonction}');
        print('Niveau: ${person.niveau}');
        print('Filiere: ${person.filiere}');

        try {
          // Si la personne n'a pas de type défini, on la migre
          if (person.type == PersonType.etudiant &&
              person.structure == null &&
              person.fonction == null &&
              person.niveau != null &&
              person.filiere != null) {
            print('✅ Étudiant existant - déjà correct');
            continue; // Déjà correct
          } else if (person.type == PersonType.employe &&
              person.niveau == null &&
              person.filiere == null &&
              person.structure != null &&
              person.fonction != null) {
            print('✅ Employé existant - déjà correct');
            continue; // Déjà correct
          } else {
            print('🔄 Migration nécessaire - détermination du type...');

            // Déterminer le type basé sur les champs existants
            PersonType newType;
            if (person.niveau != null || person.filiere != null) {
              newType = PersonType.etudiant;
              print(
                '📚 Type déterminé: Étudiant (niveau: ${person.niveau}, filiere: ${person.filiere})',
              );
            } else if (person.structure != null || person.fonction != null) {
              newType = PersonType.employe;
              print(
                '💼 Type déterminé: Employé (structure: ${person.structure}, fonction: ${person.fonction})',
              );
            } else {
              // Par défaut, considérer comme étudiant
              newType = PersonType.etudiant;
              print(
                '📚 Type par défaut: Étudiant (aucun champ spécifique trouvé)',
              );
            }

            print('🔄 Création de la nouvelle instance...');

            // Créer une nouvelle instance avec le bon type
            final updatedPerson = Person(
              id: person.id,
              subInstanceId: person.subInstanceId,
              nom: person.nom,
              prenom: person.prenom,
              structure: person.structure,
              fonction: person.fonction,
              matricule: person.matricule,
              niveau: person.niveau,
              filiere: person.filiere,
              photoPath: person.safePhotoPath,
              dateCreation: person.safeDateCreation,
              type: newType,
            );

            print('💾 Sauvegarde de la personne migrée...');
            await _personBox.put(person.id, updatedPerson);
            hasChanges = true;
            print('✅ Personne migrée avec succès');
          }
        } catch (e, stackTrace) {
          print('❌ ERREUR lors de la migration de la personne ${person.id}:');
          print('Erreur: $e');
          print('Stack trace: $stackTrace');
          print('Données de la personne problématique:');
          print('  - ID: ${person.id}');
          print('  - Nom: ${person.nom}');
          print('  - Prénom: ${person.prenom}');
          print('  - Matricule: ${person.matricule}');
          print('  - Photo: ${person.photoPath}');
          print('  - Date: ${person.dateCreation}');
          print('  - Type: ${person.type}');
          print('  - Structure: ${person.structure}');
          print('  - Fonction: ${person.fonction}');
          print('  - Niveau: ${person.niveau}');
          print('  - Filiere: ${person.filiere}');

          // En cas d'erreur, on continue pour ne pas bloquer l'application
          continue;
        }
      }

      if (hasChanges) {
        print('🎉 Migration des données terminée avec succès');
      } else {
        print('ℹ️ Aucune migration nécessaire');
      }
      print('=== FIN DE LA MIGRATION DES DONNÉES ===');
    } catch (e, stackTrace) {
      print('❌ ERREUR CRITIQUE lors de la migration:');
      print('Erreur: $e');
      print('Stack trace: $stackTrace');
      // En cas d'erreur, on continue pour ne pas bloquer l'application
    }
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
            'Type': person.typeDisplayName,
            'Structure': person.structure ?? '',
            'Fonction': person.fonction ?? '',
            'Matricule': person.matricule,
            'Niveau': person.niveau ?? '',
            'Filière': person.filiere ?? '',
            'Chemin photo': person.safePhotoPath,
            'Date de création': person.safeDateCreation.toIso8601String(),
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
            'Type': person.typeDisplayName,
            'Structure': person.structure ?? '',
            'Fonction': person.fonction ?? '',
            'Matricule': person.matricule,
            'Niveau': person.niveau ?? '',
            'Filière': person.filiere ?? '',
            'Chemin photo': person.safePhotoPath,
            'Date de création': person.safeDateCreation.toIso8601String(),
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
