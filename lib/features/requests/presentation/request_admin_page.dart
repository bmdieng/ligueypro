import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/network/firebase_bootstrap.dart';
import '../../../core/services/offer_marketplace_service.dart';
import '../../../core/theme/app_colors.dart';

class RequestAdminPage extends StatefulWidget {
  const RequestAdminPage({super.key});

  @override
  State<RequestAdminPage> createState() => _RequestAdminPageState();
}

class _RequestAdminPageState extends State<RequestAdminPage> {
  Future<void> _updateStatus(String requestId, String status) async {
    if (!FirebaseBootstrap.isReady) return;

    await FirebaseDatabase.instance.ref('requests/$requestId').update({
      'status': status,
      'updatedAt': ServerValue.timestamp,
    });

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Statut de la demande mis à jour.')),
    );
  }

  Future<void> _editRequest(MarketplaceRequestItem request) async {
    final serviceController = TextEditingController(text: request.service);
    final urgencyController = TextEditingController(text: request.urgency);
    final descriptionController = TextEditingController(text: request.description);
    final locationController = TextEditingController(text: request.location);
    final phoneController = TextEditingController(text: request.phone);

    var selectedStatus = request.status;
    var selectedOffersStatus = request.offersStatus;
    var offersCount = request.offersCount;
    var isSaving = false;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setDialogState) => AlertDialog(
          title: const Text('Modifier la demande'),
          content: SizedBox(
            width: 560,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: serviceController,
                    decoration: const InputDecoration(
                      labelText: 'Service',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: urgencyController,
                    decoration: const InputDecoration(
                      labelText: 'Urgence',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: descriptionController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: locationController,
                    decoration: const InputDecoration(
                      labelText: 'Localisation',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: phoneController,
                    decoration: const InputDecoration(
                      labelText: 'Téléphone',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Nombre d’offres',
                      border: const OutlineInputBorder(),
                      hintText: offersCount.toString(),
                    ),
                    onChanged: (value) {
                      final parsed = int.tryParse(value);
                      if (parsed != null) {
                        offersCount = parsed;
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: selectedStatus,
                    decoration: const InputDecoration(
                      labelText: 'Statut',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'pending', child: Text('En attente')),
                      DropdownMenuItem(value: 'awaiting_offers', child: Text('En attente d’offres')),
                      DropdownMenuItem(value: 'accepted', child: Text('Acceptée')),
                      DropdownMenuItem(value: 'in_progress', child: Text('En cours')),
                      DropdownMenuItem(value: 'completed', child: Text('Terminée')),
                      DropdownMenuItem(value: 'cancelled', child: Text('Annulée')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setDialogState(() => selectedStatus = value);
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: selectedOffersStatus,
                    decoration: const InputDecoration(
                      labelText: 'Statut des offres',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'open', child: Text('Ouvert')),
                      DropdownMenuItem(value: 'accepted', child: Text('Accepté')),
                      DropdownMenuItem(value: 'closed', child: Text('Fermé')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setDialogState(() => selectedOffersStatus = value);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: isSaving ? null : () => Navigator.of(dialogContext).pop(),
              child: const Text('Annuler'),
            ),
            FilledButton(
              onPressed: isSaving
                  ? null
                  : () async {
                      final service = serviceController.text.trim();
                      final urgency = urgencyController.text.trim();
                      final description = descriptionController.text.trim();
                      final location = locationController.text.trim();
                      final phone = phoneController.text.trim();

                      if (service.isEmpty || urgency.isEmpty || description.isEmpty || location.isEmpty || phone.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Tous les champs principaux doivent être remplis.')),
                        );
                        return;
                      }

                      setDialogState(() => isSaving = true);
                      try {
                        await OfferMarketplaceService.updateRequest(
                          requestId: request.id,
                          service: service,
                          urgency: urgency,
                          description: description,
                          location: location,
                          phone: phone,
                          status: selectedStatus,
                          offersStatus: selectedOffersStatus,
                          offersCount: offersCount,
                        );
                        if (!context.mounted) return;
                        Navigator.of(dialogContext).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Demande mise à jour.')),
                        );
                      } catch (_) {
                        if (!context.mounted) return;
                        setDialogState(() => isSaving = false);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Échec de la mise à jour.')),
                        );
                      }
                    },
              style: FilledButton.styleFrom(backgroundColor: AppColors.navy),
              child: Text(isSaving ? 'Enregistrement...' : 'Enregistrer'),
            ),
          ],
        ),
      ),
    );

    serviceController.dispose();
    urgencyController.dispose();
    descriptionController.dispose();
    locationController.dispose();
    phoneController.dispose();
  }

  Future<void> _deleteRequest(MarketplaceRequestItem request) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Supprimer la demande'),
        content: Text('Supprimer la demande ${request.service} de ${request.location} ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: FilledButton.styleFrom(backgroundColor: AppColors.danger),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    try {
      await OfferMarketplaceService.deleteRequest(request.id);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Demande supprimée.')),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Échec de la suppression.')),
      );
    }
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'accepted':
        return AppColors.success;
      case 'in_progress':
        return AppColors.primary;
      case 'completed':
        return AppColors.navy;
      case 'cancelled':
        return AppColors.danger;
      default:
        return AppColors.muted;
    }
  }

  String _statusLabel(String status) {
    switch (status) {
      case 'accepted':
        return 'Acceptée';
      case 'awaiting_offers':
        return 'En attente d’offres';
      case 'in_progress':
        return 'En cours';
      case 'completed':
        return 'Terminée';
      case 'cancelled':
        return 'Annulée';
      default:
        return 'En attente';
    }
  }

  Widget _buildCard(MarketplaceRequestItem request) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: _statusColor(request.status).withValues(alpha: 0.16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(request.service, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 4),
                    Text('${request.urgency} • ${request.location}', style: const TextStyle(color: AppColors.muted)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: _statusColor(request.status).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(_statusLabel(request.status), style: TextStyle(color: _statusColor(request.status), fontWeight: FontWeight.w700)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(request.description, style: const TextStyle(color: AppColors.text, height: 1.45)),
          const SizedBox(height: 8),
          Text('Téléphone : ${request.phone}', style: const TextStyle(color: AppColors.muted)),
          const SizedBox(height: 8),
          Text('Offres : ${request.offersCount} • ${request.offersStatus}', style: const TextStyle(color: AppColors.muted)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              OutlinedButton.icon(
                onPressed: () => _updateStatus(request.id, 'awaiting_offers'),
                icon: const Icon(Icons.mark_email_unread_outlined),
                label: const Text('Relancer'),
              ),
              OutlinedButton.icon(
                onPressed: () => _editRequest(request),
                icon: const Icon(Icons.edit_outlined),
                label: const Text('Modifier'),
              ),
              OutlinedButton.icon(
                onPressed: () => _deleteRequest(request),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.danger,
                  side: const BorderSide(color: AppColors.danger),
                ),
                icon: const Icon(Icons.delete_outline),
                label: const Text('Supprimer'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Demandes BO'),
        actions: [
          IconButton(
            tooltip: 'Retour BO',
            onPressed: () => context.go('/back-office'),
            icon: const Icon(Icons.dashboard_customize_outlined),
          ),
        ],
      ),
      body: !FirebaseBootstrap.isReady
          ? const Center(child: Text('Firebase indisponible'))
          : StreamBuilder<DatabaseEvent>(
              stream: FirebaseDatabase.instance.ref('requests').onValue,
              builder: (context, snapshot) {
                final requests = OfferMarketplaceService.requestsFromSnapshot(
                  snapshot.data?.snapshot.value,
                );

                return ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.navy, Color(0xFF154972), AppColors.primary],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Gestion des demandes', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w700)),
                          const SizedBox(height: 8),
                          Text('${requests.length} demande(s) enregistrée(s)', style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900)),
                          const SizedBox(height: 6),
                          const Text('Modifiez ou supprimez les demandes clients stockées dans /requests.', style: TextStyle(color: Colors.white70)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (requests.isEmpty)
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(color: AppColors.primary.withValues(alpha: 0.08)),
                        ),
                        child: const Text(
                          'Aucune demande n’est encore disponible dans Firebase.',
                          style: TextStyle(color: AppColors.muted),
                        ),
                      )
                    else
                      ...requests.map(
                        (request) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _buildCard(request),
                        ),
                      ),
                  ],
                );
              },
            ),
    );
  }
}
