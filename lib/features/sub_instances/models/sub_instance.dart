import 'package:hive/hive.dart';

part 'sub_instance.g.dart';

@HiveType(typeId: 1)
class SubInstance extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  int instanceId;

  @HiveField(2)
  String nom;

  @HiveField(3)
  DateTime dateCreation;

  @HiveField(4)
  String? description;

  SubInstance({
    required this.id,
    required this.instanceId,
    required this.nom,
    required this.dateCreation,
    this.description,
  });

  SubInstance copyWith({
    int? id,
    int? instanceId,
    String? nom,
    DateTime? dateCreation,
    String? description,
  }) {
    return SubInstance(
      id: id ?? this.id,
      instanceId: instanceId ?? this.instanceId,
      nom: nom ?? this.nom,
      dateCreation: dateCreation ?? this.dateCreation,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'instanceId': instanceId,
      'nom': nom,
      'dateCreation': dateCreation.toIso8601String(),
      'description': description,
    };
  }

  factory SubInstance.fromJson(Map<String, dynamic> json) {
    return SubInstance(
      id: json['id'] as int,
      instanceId: json['instanceId'] as int,
      nom: json['nom'] as String,
      dateCreation: DateTime.parse(json['dateCreation'] as String),
      description: json['description'] as String?,
    );
  }

  @override
  String toString() {
    return 'SubInstance(id: $id, instanceId: $instanceId, nom: $nom, dateCreation: $dateCreation, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SubInstance && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}



