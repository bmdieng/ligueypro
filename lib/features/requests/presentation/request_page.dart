import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../../../core/network/firebase_bootstrap.dart';
import '../../../core/services/request_submission_service.dart';
import '../../../core/theme/app_colors.dart';

class RequestPage extends StatefulWidget {
  const RequestPage({super.key});

  @override
  State<RequestPage> createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  List<String> _serviceOptions = const [];

  static const List<String> _urgencyOptions = [
    'Standard',
    'Urgent',
    'Très urgent',
  ];

  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController(
    text: 'Dakar, Sénégal',
  );
  final TextEditingController _phoneController = TextEditingController();

  String? _selectedService;
  String _selectedUrgency = _urgencyOptions.first;
  bool _isSending = false;
  bool _photoAdded = false;

  @override
  void initState() {
    super.initState();
    _loadServiceOptions();
  }

  Future<void> _loadServiceOptions() async {
    if (!FirebaseBootstrap.isReady) {
      setState(() {
        _serviceOptions = const [];
        _selectedService = null;
      });
      return;
    }

    try {
      final snapshot =
          await FirebaseDatabase.instance.ref('home/categories').get();
      final services = <_ServiceOption>[];
      var fallbackOrder = 0;

      void collect(dynamic value) {
        if (value is Map) {
          final label = value['label']?.toString();
          if (label != null && label.trim().isNotEmpty) {
            final rawOrder = value['order'];
            final order = rawOrder is num
                ? rawOrder.toInt()
                : int.tryParse(rawOrder?.toString() ?? '') ?? fallbackOrder;
            services.add(_ServiceOption(label: label, order: order));
            fallbackOrder++;
            return;
          }
          for (final item in value.values) {
            collect(item);
          }
        } else if (value is List) {
          for (final item in value) {
            collect(item);
          }
        }
      }

      collect(snapshot.value);

      services.sort((a, b) {
        if (a.order != b.order) {
          return a.order.compareTo(b.order);
        }
        return a.label.toLowerCase().compareTo(b.label.toLowerCase());
      });

      final seenLabels = <String>{};
      final loadedOptions = services
          .where((service) => seenLabels.add(service.label.toLowerCase()))
          .map((service) => service.label)
          .toList();
      if (!mounted) return;
      setState(() {
        _serviceOptions = loadedOptions;
        if (_serviceOptions.isEmpty) {
          _selectedService = null;
        } else if (_selectedService == null ||
            !_serviceOptions.contains(_selectedService)) {
          _selectedService = _serviceOptions.first;
        }
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _serviceOptions = const [];
        _selectedService = null;
      });
    }
  }

  Future<void> _submitRequest() async {
    final requestText = _descriptionController.text.trim();
    final locationText = _locationController.text.trim();
    final phoneText = _phoneController.text.trim();

    if (requestText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez décrire votre besoin.')),
      );
      return;
    }

    if (phoneText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Veuillez renseigner votre numéro de téléphone.')),
      );
      return;
    }

    if (_selectedService == null || _selectedService!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Aucun service n’est disponible pour le moment.'),
        ),
      );
      return;
    }

    setState(() => _isSending = true);

    try {
      final draft = ServiceRequestDraft(
        service: _selectedService!,
        urgency: _selectedUrgency,
        description: requestText,
        location:
            locationText.isEmpty ? 'Localisation non renseignée' : locationText,
        phone: phoneText,
        photoAttached: _photoAdded,
      );

      await RequestSubmissionService.submitRequest(draft: draft);

      if (!mounted) return;
      await showDialog<void>(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Demande envoyée'),
          content: const Text(
            'Votre demande a été publiée. Les professionnels abonnés peuvent maintenant recevoir cette demande et vous envoyer leurs offres.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Voir mes demandes'),
            ),
          ],
        ),
      );

      _descriptionController.clear();
      _phoneController.clear();
      _locationController.text = 'Dakar, Sénégal';
      setState(() {
        _selectedService =
            _serviceOptions.isEmpty ? null : _serviceOptions.first;
        _selectedUrgency = _urgencyOptions.first;
        _photoAdded = false;
      });
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Échec de sauvegarde de la demande. Réessayez.')),
      );
    } finally {
      if (mounted) {
        setState(() => _isSending = false);
      }
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _locationController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nouvelle demande')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              'Décrivez votre besoin',
              style: TextStyle(fontSize: 21, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 16),
            DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: _serviceOptions.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.symmetric(vertical: 18),
                        child: Text(
                          'Aucun service disponible dans Firebase.',
                          style: TextStyle(color: AppColors.muted),
                        ),
                      )
                    : DropdownButtonHideUnderline(
                        child: DropdownButtonFormField<String>(
                          initialValue: _selectedService,
                          decoration: const InputDecoration(
                            labelText: 'Type de service',
                            border: InputBorder.none,
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
                            if (value != null) {
                              setState(() => _selectedService = value);
                            }
                          },
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Résumé de votre demande',
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 8),
                  Text('Service : ${_selectedService ?? 'Non disponible'}'),
                  const SizedBox(height: 4),
                  Text('Urgence : $_selectedUrgency'),
                  const SizedBox(height: 4),
                  Text(
                    _descriptionController.text.trim().isEmpty
                        ? 'Ajoutez une description claire pour améliorer le matching.'
                        : _descriptionController.text.trim(),
                    style: const TextStyle(color: AppColors.muted),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Paiement direct : le client règle ensuite le professionnel hors application, après réception des offres.',
                    style: TextStyle(
                      color: AppColors.navy,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Urgence',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _urgencyOptions.map((urgency) {
                final isSelected = _selectedUrgency == urgency;
                return ChoiceChip(
                  label: Text(urgency),
                  selected: isSelected,
                  selectedColor: AppColors.primary.withValues(alpha: 0.14),
                  onSelected: (_) => setState(() => _selectedUrgency = urgency),
                );
              }).toList(),
            ),
            const SizedBox(height: 18),
            const Text(
              'Description',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _descriptionController,
              maxLines: 6,
              decoration: const InputDecoration(
                hintText: 'Ex. Mon climatiseur ne refroidit plus…',
                border: OutlineInputBorder(),
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Numéro de téléphone',
                prefixIcon: Icon(Icons.phone, color: AppColors.primary),
                hintText: '+221 77 123 45 67',
                border: OutlineInputBorder(),
              ),
            ),
            // const SizedBox(height: 16),
            // OutlinedButton.icon(
            //   onPressed: () => setState(() => _photoAdded = !_photoAdded),
            //   icon: Icon(
            //     _photoAdded ? Icons.check_circle : Icons.camera_alt_outlined,
            //     color: _photoAdded ? AppColors.primary : null,
            //   ),
            //   label: Text(_photoAdded ? 'Photo ajoutée' : 'Ajouter une photo'),
            // ),
            const SizedBox(height: 16),
            TextField(
              controller: _locationController,
              decoration: const InputDecoration(
                labelText: 'Localisation',
                prefixIcon: Icon(Icons.location_on, color: AppColors.primary),
                hintText: 'Votre adresse ou quartier',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: _isSending || _selectedService == null
                  ? null
                  : _submitRequest,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.navy,
                padding: const EdgeInsets.all(16),
              ),
              child: _isSending
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text('Publier la demande'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ServiceOption {
  const _ServiceOption({required this.label, required this.order});

  final String label;
  final int order;
}
