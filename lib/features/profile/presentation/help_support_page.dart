import 'package:flutter/material.dart';

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Aide et support')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          Text(
            'Comment ça marche',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
          ),
          SizedBox(height: 12),
          _HelpCard(
            icon: Icons.search,
            title: 'Trouver un service',
            description:
                'Choisissez une catégorie ou utilisez la recherche pour trouver le bon professionnel près de chez vous.',
          ),
          SizedBox(height: 12),
          _HelpCard(
            icon: Icons.edit_note,
            title: 'Créer une demande',
            description:
                'Décrivez votre besoin, choisissez la catégorie et précisez l’urgence, votre localisation et votre numéro de téléphone.',
          ),
          SizedBox(height: 12),
          _HelpCard(
            icon: Icons.notifications_active,
            title: 'Suivre votre demande',
            description:
                'Consultez les demandes dans “Mes demandes” pour voir l’état et l’ordre d’urgence des interventions.',
          ),
          SizedBox(height: 20),
          Text(
            'Questions fréquentes',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
          ),
          SizedBox(height: 12),
          _FaqItem(
            question: 'Comment puis-je modifier une demande ?',
            answer:
                'Rendez-vous dans la liste de vos demandes et sélectionnez la demande concernée pour vérifier ou corriger les informations.',
          ),
          _FaqItem(
            question: 'Que faire si je ne reçois pas de réponse ?',
            answer:
                'Vous pouvez relancer votre demande, vérifier l’urgence sélectionnée et confirmer votre numéro de téléphone pour être recontacté.',
          ),
          _FaqItem(
            question: 'Comment contacter l’assistance ?',
            answer:
                'Vous pouvez nous écrire via le support de l’application ou appeler le centre d’assistance disponible dans votre région.',
          ),
          SizedBox(height: 20),
          _HelpCard(
            icon: Icons.support_agent,
            title: 'Besoin d’accompagnement ?',
            description:
                'Notre équipe peut vous aider pour la création d’une demande, le suivi ou la résolution d’un problème technique.',
          ),
        ],
      ),
    );
  }
}

class _HelpCard extends StatelessWidget {
  const _HelpCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF0B3157).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: const Color(0xFF0B3157)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    description,
                    style:
                        const TextStyle(color: Color(0xFF6B7280), height: 1.5),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FaqItem extends StatelessWidget {
  const _FaqItem({required this.question, required this.answer});

  final String question;
  final String answer;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        title:
            Text(question, style: const TextStyle(fontWeight: FontWeight.w700)),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              answer,
              style: const TextStyle(color: Color(0xFF6B7280), height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}
