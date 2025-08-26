import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/services/image_service.dart';
import '../../models/person.dart';

class PersonCard extends StatelessWidget {
  final Person person;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const PersonCard({
    super.key,
    required this.person,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Photo de la personne
              ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: SizedBox(
                  width: 50,
                  height: 50,
                  child: FutureBuilder<bool>(
                    future: ImageService.imageExists(person.photoPath),
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data == true) {
                        return Image.file(
                          File(person.photoPath),
                          fit: BoxFit.cover,
                          errorBuilder: (context, err, stackTrace) {
                            return _buildPlaceholderIcon();
                          },
                        );
                      } else {
                        return _buildPlaceholderIcon();
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Informations de la personne
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nom et prénom avec badge de type
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${person.prenom} ${person.nom}',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(width: 8),
                        _buildTypeBadge(),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Informations spécifiques au type
                    if (person.isEtudiant) ...[
                      _buildInfoRow(
                        Icons.school,
                        'Niveau: ${person.niveau ?? ''}',
                      ),
                      _buildInfoRow(
                        Icons.book,
                        'Filière: ${person.filiere ?? ''}',
                      ),
                      _buildInfoRow(
                        Icons.badge,
                        'Matricule: ${person.matricule}',
                      ),
                    ] else ...[
                      _buildInfoRow(
                        Icons.business,
                        'Structure: ${person.structure ?? ''}',
                      ),
                      _buildInfoRow(
                        Icons.work,
                        'Fonction: ${person.fonction ?? ''}',
                      ),
                      _buildInfoRow(
                        Icons.badge,
                        'Matricule: ${person.matricule}',
                      ),
                    ],

                    // Date de création
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            size: 14,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Créé le ${DateFormat('dd/MM/yyyy').format(person.dateCreation)}',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Bouton de suppression
              IconButton(
                onPressed: onDelete,
                icon: const Icon(Icons.delete, color: Colors.red),
                tooltip: 'Supprimer',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeBadge() {
    final isEtudiant = person.isEtudiant;
    final color = isEtudiant
        ? const Color(0xFF4CAF50)
        : const Color(0xFF2196F3);
    final icon = isEtudiant ? Icons.school : Icons.business;
    final text = isEtudiant ? 'Étudiant' : 'Employé';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              text,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderIcon() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(25),
      ),
      child: const Icon(Icons.person, size: 30, color: Colors.grey),
    );
  }
}
