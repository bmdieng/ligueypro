import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/network/firebase_bootstrap.dart';
import '../../../core/services/request_notification_service.dart';
import '../../../core/theme/app_colors.dart';

class RequestPage extends StatefulWidget {
  const RequestPage({super.key});

  @override
  State<RequestPage> createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  static const List<String> _fallbackServiceOptions = [
    'Plombier',
    'Électricien',
    'Ménage',
    'Climatisation',
    'Jardinage',
    'Autre',
  ];

  List<String> _serviceOptions = _fallbackServiceOptions;

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

  String _selectedService = _fallbackServiceOptions.first;
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
        _serviceOptions = _fallbackServiceOptions;
        _selectedService = _serviceOptions.first;
      });
      return;
    }

    try {
      final snapshot = await FirebaseDatabase.instance.ref('home/categories').get();
      final labels = <String>[];

      void collect(dynamic value) {
        if (value is Map) {
          final label = value['label']?.toString();
          if (label != null && label.trim().isNotEmpty) {
            labels.add(label);
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

      final loadedOptions = labels.isNotEmpty ? labels : _fallbackServiceOptions;
      if (!mounted) return;
      setState(() {
        _serviceOptions = loadedOptions;
        if (!_serviceOptions.contains(_selectedService)) {
          _selectedService = _serviceOptions.first;
        }
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _serviceOptions = _fallbackServiceOptions;
        _selectedService = _serviceOptions.first;
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
        const SnackBar(content: Text('Veuillez renseigner votre numéro de téléphone.')),
      );
      return;
    }

    setState(() => _isSending = true);

    try {
      final requestData = {
        'service': _selectedService,
        'urgency': _selectedUrgency,
        'description': requestText,
        'location': locationText.isEmpty ? 'Localisation non renseignée' : locationText,
        'phone': phoneText,
        'photoAttached': _photoAdded,
        'status': 'pending',
        'createdAt': ServerValue.timestamp,
      };

      if (FirebaseBootstrap.isReady) {
        final requestRef = FirebaseDatabase.instance.ref('requests').push();
        await requestRef.set(requestData);
      }

      await RequestNotificationService.sendRequestNotification(
        service: _selectedService,
        urgency: _selectedUrgency,
        location: locationText.isEmpty ? 'Localisation non renseignée' : locationText,
        phone: phoneText,
      );

      if (!mounted) return;
      await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Demande envoyée'),
          content: Text(
            FirebaseBootstrap.isReady
                ? 'Votre demande a été enregistrée et transmise aux professionnels disponibles.'
                : 'Votre demande a été enregistrée localement. Configure Firebase pour la sauvegarde en temps réel.',
          ),
          actions: [
            TextButton(onPressed: () => context.pop(), child: const Text('OK')),
          ],
        ),
      );

      _descriptionController.clear();
      _phoneController.clear();
      _locationController.text = 'Dakar, Sénégal';
      setState(() {
        _selectedService = _serviceOptions.isEmpty ? _fallbackServiceOptions.first : _serviceOptions.first;
        _selectedUrgency = _urgencyOptions.first;
        _photoAdded = false;
      });
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Échec de sauvegarde de la demande. Réessayez.')),
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
                child: DropdownButtonHideUnderline(
                  child: DropdownButtonFormField<String>(
                    value: _selectedService,
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
                  selectedColor: AppColors.primary.withOpacity(0.14),
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
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () => setState(() => _photoAdded = !_photoAdded),
              icon: Icon(
                _photoAdded ? Icons.check_circle : Icons.camera_alt_outlined,
                color: _photoAdded ? AppColors.primary : null,
              ),
              label: Text(_photoAdded ? 'Photo ajoutée' : 'Ajouter une photo'),
            ),
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
              onPressed: _isSending ? null : _submitRequest,
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
                  : const Text('Envoyer la demande'),
            ),
          ],
        ),
      ),
    );
  }
}
