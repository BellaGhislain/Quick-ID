import 'package:flutter/material.dart';

class SummaryStep extends StatelessWidget {
  final String nom;
  final String prenom;
  final String structure;
  final String fonction;
  final String matricule;
  final String niveau;
  final String filiere;
  final String? photoPath;

  const SummaryStep({
    super.key,
    required this.nom,
    required this.prenom,
    required this.structure,
    required this.fonction,
    required this.matricule,
    required this.niveau,
    required this.filiere,
    this.photoPath,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Résumé des informations',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFFCA1B49),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Vérifiez toutes les informations avant de valider',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
        const SizedBox(height: 32),

        // Photo
        if (photoPath != null) ...[
          Center(
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFCA1B49), width: 2),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.asset(
                  photoPath!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child: const Icon(
                        Icons.person,
                        size: 60,
                        color: Colors.grey,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],

        // Informations personnelles
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Informations personnelles',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                _buildInfoRow('Prénom', prenom),
                _buildInfoRow('Nom', nom),
                _buildInfoRow('Structure', structure),
                _buildInfoRow('Fonction', fonction),
                _buildInfoRow('Matricule', matricule),
                _buildInfoRow('Niveau', niveau),
                _buildInfoRow('Filière', filiere),
              ],
            ),
          ),
        ),

        const SizedBox(height: 24),

        // Confirmation message
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
              Icon(Icons.check_circle, color: Color(0xFFCA1B49)),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Toutes les informations sont prêtes ! Appuyez sur "Enregistrer" pour créer la personne.',
                  style: TextStyle(color: Color(0xFFCA1B49), fontSize: 14),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Edit reminder
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.blue[200]!),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline, color: Colors.blue[700]),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Vous pourrez modifier ces informations plus tard depuis la liste des personnes.',
                  style: TextStyle(color: Colors.blue[700], fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label :',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
