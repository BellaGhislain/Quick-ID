import 'package:hive/hive.dart';

part 'person.g.dart';

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
  String structure;

  @HiveField(5)
  String fonction;

  @HiveField(6)
  String matricule;

  @HiveField(7)
  String niveau;

  @HiveField(8)
  String filiere;

  @HiveField(9)
  String photoPath; // Maintenant obligatoire

  @HiveField(10)
  DateTime dateCreation;

  Person({
    required this.id,
    required this.subInstanceId,
    required this.nom,
    required this.prenom,
    required this.structure,
    required this.fonction,
    required this.matricule,
    required this.niveau,
    required this.filiere,
    required this.photoPath,
    required this.dateCreation,
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
    };
  }

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      id: json['id'] as int,
      subInstanceId: json['subInstanceId'] as int,
      nom: json['nom'] as String,
      prenom: json['prenom'] as String,
      structure: json['structure'] as String,
      fonction: json['fonction'] as String,
      matricule: json['matricule'] as String,
      niveau: json['niveau'] as String,
      filiere: json['filiere'] as String,
      photoPath: json['photoPath'] as String,
      dateCreation: DateTime.parse(json['dateCreation'] as String),
    );
  }

  @override
  String toString() {
    return 'Person(id: $id, subInstanceId: $subInstanceId, nom: $nom, prenom: $prenom, structure: $structure, fonction: $fonction, matricule: $matricule, niveau: $niveau, filiere: $filiere, photoPath: $photoPath, dateCreation: $dateCreation)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Person && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
