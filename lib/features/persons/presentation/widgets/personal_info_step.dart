import 'package:flutter/material.dart';

class PersonalInfoStep extends StatefulWidget {
  final TextEditingController nomController;
  final TextEditingController prenomController;
  final TextEditingController structureController;
  final TextEditingController fonctionController;
  final TextEditingController matriculeController;
  final TextEditingController niveauController;
  final TextEditingController filiereController;

  const PersonalInfoStep({
    super.key,
    required this.nomController,
    required this.prenomController,
    required this.structureController,
    required this.fonctionController,
    required this.matriculeController,
    required this.niveauController,
    required this.filiereController,
  });

  @override
  State<PersonalInfoStep> createState() => _PersonalInfoStepState();
}

class _PersonalInfoStepState extends State<PersonalInfoStep> {
  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Informations personnelles',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFFCA1B49),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Remplissez tous les champs obligatoires',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 32),

          // Nom et Prénom
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: widget.nomController,
                  decoration: const InputDecoration(
                    labelText: 'Nom de famille *',
                    hintText: 'Ex: Dupont, Martin',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  textCapitalization: TextCapitalization.words,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Le nom est requis';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: widget.prenomController,
                  decoration: const InputDecoration(
                    labelText: 'Prénom *',
                    hintText: 'Ex: Jean, Marie',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  textCapitalization: TextCapitalization.words,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Le prénom est requis';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Structure et Fonction
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: widget.structureController,
                  decoration: const InputDecoration(
                    labelText: 'Structure *',
                    hintText: 'Ex: Département, Service',
                    prefixIcon: Icon(Icons.business),
                  ),
                  textCapitalization: TextCapitalization.words,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'La structure est requise';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: widget.fonctionController,
                  decoration: const InputDecoration(
                    labelText: 'Fonction *',
                    hintText: 'Ex: Directeur, Enseignant',
                    prefixIcon: Icon(Icons.work),
                  ),
                  textCapitalization: TextCapitalization.words,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'La fonction est requise';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Matricule et Niveau
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: widget.matriculeController,
                  decoration: const InputDecoration(
                    labelText: 'Matricule *',
                    hintText: 'Ex: MAT001, EMP123',
                    prefixIcon: Icon(Icons.badge),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Le matricule est requis';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: widget.niveauController,
                  decoration: const InputDecoration(
                    labelText: 'Niveau *',
                    hintText: 'Ex: Bac+3, Master, Doctorat',
                    prefixIcon: Icon(Icons.school),
                  ),
                  textCapitalization: TextCapitalization.words,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Le niveau est requis';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Filière
          TextFormField(
            controller: widget.filiereController,
            decoration: const InputDecoration(
              labelText: 'Filière *',
              hintText: 'Ex: Informatique, Gestion, Médecine',
              prefixIcon: Icon(Icons.category),
            ),
            textCapitalization: TextCapitalization.words,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'La filière est requise';
              }
              return null;
            },
          ),

          const SizedBox(height: 24),

          // Information sur les champs obligatoires
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFCA1B49).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color(0xFFCA1B49).withValues(alpha: 0.3),
              ),
            ),
            child: const Row(
              children: [
                Icon(Icons.info_outline, color: Color(0xFFCA1B49)),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Tous les champs sont obligatoires pour identifier et classer la personne dans le système.',
                    style: TextStyle(color: Color(0xFFCA1B49), fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
