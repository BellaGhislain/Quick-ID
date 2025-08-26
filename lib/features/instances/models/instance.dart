import 'package:hive/hive.dart';

part 'instance.g.dart';

@HiveType(typeId: 0)
class Instance extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  String nom;

  @HiveField(2)
  DateTime dateCreation;

  @HiveField(3)
  String? description;

  Instance({required this.id, required this.nom, required this.dateCreation, this.description});

  Instance copyWith({int? id, String? nom, DateTime? dateCreation, String? description}) {
    return Instance(
      id: id ?? this.id,
      nom: nom ?? this.nom,
      dateCreation: dateCreation ?? this.dateCreation,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'dateCreation': dateCreation.toIso8601String(),
      'description': description,
    };
  }

  factory Instance.fromJson(Map<String, dynamic> json) {
    return Instance(
      id: json['id'] as int,
      nom: json['nom'] as String,
      dateCreation: DateTime.parse(json['dateCreation'] as String),
      description: json['description'] as String?,
    );
  }

  @override
  String toString() {
    return 'Instance(id: $id, nom: $nom, dateCreation: $dateCreation, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Instance && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}



