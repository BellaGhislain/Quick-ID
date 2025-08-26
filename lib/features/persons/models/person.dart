import 'package:hive/hive.dart';

part 'person.g.dart';

enum PersonType {
  @HiveField(0)
  etudiant,
  @HiveField(1)
  employe,
}

@HiveType(typeId: 2)
class Person extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  int subInstanceId;

  @HiveField(2)
  String nom;

  @HiveField(3)
  String prenom;

  @HiveField(4)
  String? structure; // Pour les employés

  @HiveField(5)
  String? fonction; // Pour les employés

  @HiveField(6)
  String matricule;

  @HiveField(7)
  String? niveau; // Pour les étudiants

  @HiveField(8)
  String? filiere; // Pour les étudiants

  @HiveField(9)
  String photoPath; // Maintenant obligatoire

  @HiveField(10)
  DateTime dateCreation;

  @HiveField(11)
  PersonType type;

  Person({
    required this.id,
    required this.subInstanceId,
    required this.nom,
    required this.prenom,
    this.structure,
    this.fonction,
    required this.matricule,
    this.niveau,
    this.filiere,
    required this.photoPath,
    required this.dateCreation,
    required this.type,
  });

  Person copyWith({
    int? id,
    int? subInstanceId,
    String? nom,
    String? prenom,
    String? structure,
    String? fonction,
    String? matricule,
    String? niveau,
    String? filiere,
    String? photoPath,
    DateTime? dateCreation,
    PersonType? type,
  }) {
    return Person(
      id: id ?? this.id,
      subInstanceId: subInstanceId ?? this.subInstanceId,
      nom: nom ?? this.nom,
      prenom: prenom ?? this.prenom,
      structure: structure ?? this.structure,
      fonction: fonction ?? this.fonction,
      matricule: matricule ?? this.matricule,
      niveau: niveau ?? this.niveau,
      filiere: filiere ?? this.filiere,
      photoPath: photoPath ?? this.photoPath,
      dateCreation: dateCreation ?? this.dateCreation,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subInstanceId': subInstanceId,
      'nom': nom,
      'prenom': prenom,
      'structure': structure,
      'fonction': fonction,
      'matricule': matricule,
      'niveau': niveau,
      'filiere': filiere,
      'photoPath': photoPath,
      'dateCreation': dateCreation.toIso8601String(),
      'type': type.name,
    };
  }

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      id: json['id'] as int,
      subInstanceId: json['subInstanceId'] as int,
      nom: json['nom'] as String,
      prenom: json['prenom'] as String,
      structure: json['structure'] as String?,
      fonction: json['fonction'] as String?,
      matricule: json['matricule'] as String,
      niveau: json['niveau'] as String?,
      filiere: json['filiere'] as String?,
      photoPath: json['photoPath'] as String,
      dateCreation: DateTime.parse(json['dateCreation'] as String),
      type: PersonType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => PersonType.etudiant,
      ),
    );
  }

  @override
  String toString() {
    return 'Person(id: $id, nom: $nom, prenom: $prenom, type: $type)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Person && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  // Getters pour faciliter l'accès aux champs selon le type
  bool get isEtudiant => type == PersonType.etudiant;
  bool get isEmploye => type == PersonType.employe;

  // Titre affiché selon le type
  String get typeDisplayName => isEtudiant ? 'Étudiant' : 'Employé';
}
