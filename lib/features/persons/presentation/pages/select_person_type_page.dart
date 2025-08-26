import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../models/person.dart';

class SelectPersonTypePage extends StatelessWidget {
  final int subInstanceId;

  const SelectPersonTypePage({super.key, required this.subInstanceId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quick ID - Type de personne'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/persons/$subInstanceId'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Quel type de personne souhaitez-vous ajouter ?',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFFCA1B49),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),

            // Option Étudiant
            _buildTypeCard(
              context,
              PersonType.etudiant,
              'Étudiant',
              'Pour les écoles et établissements d\'enseignement',
              Icons.school,
              const Color(0xFF4CAF50),
            ),

            const SizedBox(height: 24),

            // Option Employé
            _buildTypeCard(
              context,
              PersonType.employe,
              'Employé',
              'Pour les entreprises et organisations',
              Icons.business,
              const Color(0xFF2196F3),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeCard(
    BuildContext context,
    PersonType type,
    String title,
    String description,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () => _navigateToAddPerson(context, type),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Icon(icon, size: 40, color: color),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToAddPerson(BuildContext context, PersonType type) {
    context.go('/add-person/$subInstanceId?type=${type.name}');
  }
}
