import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/services/pro_lead_capture_service.dart';
import '../../../core/theme/app_colors.dart';

class ProLeadCapturePage extends StatefulWidget {
  const ProLeadCapturePage({super.key});

  @override
  State<ProLeadCapturePage> createState() => _ProLeadCapturePageState();
}

class _ProLeadCapturePageState extends State<ProLeadCapturePage> {
  static const List<String> _serviceOptions = [
    'Plombier',
    'Électricien',
    'Ménage',
    'Climatisation',
    'Jardinage',
    'Informatique',
    'Autre',
  ];

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _businessNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  String _selectedService = _serviceOptions.first;
  bool _isSubmitting = false;

  Future<void> _submitLead() async {
    final fullName = _fullNameController.text.trim();
    final phone = _phoneController.text.trim();
    final city = _cityController.text.trim();

    if (fullName.isEmpty || phone.isEmpty || city.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Renseignez au minimum votre nom, téléphone et ville.'),
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    await ProLeadCaptureService.submitLead(
      ProLeadDraft(
        fullName: fullName,
        phone: phone,
        service: _selectedService,
        city: city,
        businessName: _businessNameController.text.trim().isEmpty
            ? null
            : _businessNameController.text.trim(),
        note: _noteController.text.trim().isEmpty
            ? null
            : _noteController.text.trim(),
      ),
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _isSubmitting = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Votre demande pro a bien été enregistrée. Vous pouvez maintenant compléter votre profil ou consulter les plans.',
        ),
      ),
    );

    _fullNameController.clear();
    _businessNameController.clear();
    _phoneController.clear();
    _cityController.clear();
    _noteController.clear();
    setState(() {
      _selectedService = _serviceOptions.first;
    });
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _businessNameController.dispose();
    _phoneController.dispose();
    _cityController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final compact = width < 920;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            compact
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHero(context),
                      const SizedBox(height: 16),
                      _buildFormCard(context),
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 3, child: _buildHero(context)),
                      const SizedBox(width: 16),
                      Expanded(flex: 2, child: _buildFormCard(context)),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildHero(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.navy, Color(0xFF154972), AppColors.primary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              OutlinedButton.icon(
                onPressed: () => context.go('/for-pros'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white38),
                ),
                icon: const Icon(Icons.arrow_back_outlined),
                label: const Text('Retour'),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(999),
            ),
            child: const Text(
              'Entrée rapide pour les pros',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'Laissez vos coordonnées et démarrez votre activation professionnelle.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 34,
              fontWeight: FontWeight.w900,
              height: 1.05,
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'Ce formulaire sert de préqualification rapide. Ensuite, vous pouvez compléter votre profil, choisir un abonnement et accéder à votre back-office sécurisé.',
            style: TextStyle(color: Colors.white70, height: 1.45),
          ),
          const SizedBox(height: 22),
          const _LeadBenefit(
            icon: Icons.check_circle_outline,
            title: 'Réponse rapide',
            body: 'Capturez un lead pro sans remplir tout le profil complet.',
          ),
          const SizedBox(height: 12),
          const _LeadBenefit(
            icon: Icons.badge_outlined,
            title: 'Qualification métier',
            body:
                'Identifiez le service et la ville avant l’onboarding complet.',
          ),
          const SizedBox(height: 12),
          const _LeadBenefit(
            icon: Icons.workspace_premium_outlined,
            title: 'Passage fluide vers l’abonnement',
            body: 'Orientez ensuite le pro vers les plans et le BO sécurisé.',
          ),
        ],
      ),
    );
  }

  Widget _buildFormCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Formulaire pro',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 8),
          const Text(
            'Quelques informations suffisent pour initier votre parcours professionnel.',
            style: TextStyle(color: AppColors.muted, height: 1.4),
          ),
          const SizedBox(height: 18),
          TextField(
            controller: _fullNameController,
            decoration: const InputDecoration(
              labelText: 'Nom complet',
              prefixIcon: Icon(Icons.person_outline),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _businessNameController,
            decoration: const InputDecoration(
              labelText: 'Nom commercial ou atelier',
              prefixIcon: Icon(Icons.storefront_outlined),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 14),
          DropdownButtonFormField<String>(
            initialValue: _selectedService,
            decoration: const InputDecoration(
              labelText: 'Métier principal',
              border: OutlineInputBorder(),
            ),
            items: _serviceOptions
                .map(
                  (service) => DropdownMenuItem(
                    value: service,
                    child: Text(service),
                  ),
                )
                .toList(),
            onChanged: (value) {
              if (value == null) {
                return;
              }
              setState(() {
                _selectedService = value;
              });
            },
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              labelText: 'Téléphone',
              prefixIcon: Icon(Icons.phone_outlined),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _cityController,
            decoration: const InputDecoration(
              labelText: 'Ville ou zone',
              prefixIcon: Icon(Icons.location_on_outlined),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _noteController,
            minLines: 3,
            maxLines: 4,
            decoration: const InputDecoration(
              labelText: 'Commentaire',
              hintText: 'Parlez de votre activité, disponibilité ou besoin.',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: _isSubmitting ? null : _submitLead,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.navy,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              icon: _isSubmitting
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.send_outlined),
              label: Text(
                _isSubmitting ? 'Envoi...' : 'Envoyer ma demande pro',
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => context.go('/pro-subscription'),
                  icon: const Icon(Icons.workspace_premium_outlined),
                  label: const Text('Voir les plans'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => context.go('/add-professional'),
                  icon: const Icon(Icons.person_add_alt_1_outlined),
                  label: const Text('Profil complet'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LeadBenefit extends StatelessWidget {
  const _LeadBenefit({
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: Colors.white),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                body,
                style: const TextStyle(color: Colors.white70, height: 1.35),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
