import 'package:flutter/material.dart';

class CguPage extends StatelessWidget {
  const CguPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Conditions générales d’utilisation')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          Text(
            'Conditions générales d’utilisation',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
          ),
          SizedBox(height: 16),
          Text(
            'Bienvenue sur LigueyPro. En utilisant cette application, vous acceptez les présentes conditions générales.',
            style: TextStyle(color: Color(0xFF6B7280), height: 1.6),
          ),
          SizedBox(height: 20),
          _SectionTitle(title: '1. Objet'),
          _SectionText(
            'L’application a pour objectif de mettre en relation les utilisateurs avec des professionnels de services disponibles dans leur zone géographique.',
          ),
          SizedBox(height: 12),
          _SectionTitle(title: '2. Utilisation du service'),
          _SectionText(
            'Vous vous engagez à fournir des informations exactes, notamment votre localisation, votre numéro de téléphone et votre description de besoin. Vous devez utiliser l’application de manière responsable et conforme à la loi.',
          ),
          SizedBox(height: 12),
          _SectionTitle(title: '3. Demandes et professionnels'),
          _SectionText(
            'Les demandes soumises sont transmises aux professionnels disponibles. La disponibilité, le prix et les délais peuvent varier selon les conditions réelles du prestataire et de la demande.',
          ),
          SizedBox(height: 12),
          _SectionTitle(title: '4. Responsabilités'),
          _SectionText(
            'L’application sert uniquement de plateforme de mise en relation. LigueyPro n’est pas responsable directe des prestations réalisées par les professionnels, des résultats obtenus ou des éventuels litiges entre utilisateurs et prestataires.',
          ),
          SizedBox(height: 12),
          _SectionTitle(title: '5. Données personnelles'),
          _SectionText(
            'Les données collectées, notamment le numéro de téléphone et la localisation, sont utilisées pour faciliter la mise en relation et le suivi des demandes. Elles doivent être traitées conformément à la réglementation sur la protection des données.',
          ),
          SizedBox(height: 12),
          _SectionTitle(title: '6. Modifications'),
          _SectionText(
            'Nous pouvons modifier ces conditions à tout moment. Les changements importants seront signalés dans l’application ou via les moyens disponibles.',
          ),
          SizedBox(height: 20),
          Text(
            'En continuant à utiliser l’application, vous confirmez avoir lu et accepté ces conditions.',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
      ),
    );
  }
}

class _SectionText extends StatelessWidget {
  const _SectionText(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(color: Color(0xFF6B7280), height: 1.6),
    );
  }
}
