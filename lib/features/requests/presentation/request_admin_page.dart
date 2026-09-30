import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/network/firebase_bootstrap.dart';
import '../../../core/services/offer_marketplace_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../l10n/generated/app_localizations.dart';

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
      SnackBar(
          content:
              Text(AppLocalizations.of(context).requestAdminStatusUpdated)),
    );
  }

  Future<void> _editRequest(MarketplaceRequestItem request) async {
    final l10n = AppLocalizations.of(context);
    final serviceController = TextEditingController(text: request.service);
    final urgencyController = TextEditingController(text: request.urgency);
    final descriptionController =
        TextEditingController(text: request.description);
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
          title: Text(l10n.requestAdminEditTitle),
          content: SizedBox(
            width: 560,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: serviceController,
                    decoration: InputDecoration(
                      labelText: l10n.requestAdminService,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: urgencyController,
                    decoration: InputDecoration(
                      labelText: l10n.requestAdminUrgency,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: descriptionController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      labelText: l10n.requestAdminDescription,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: locationController,
                    decoration: InputDecoration(
                      labelText: l10n.requestAdminLocation,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: phoneController,
                    decoration: InputDecoration(
                      labelText: l10n.requestAdminPhone,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: l10n.requestAdminOffersCount,
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
                    decoration: InputDecoration(
                      labelText: l10n.requestAdminStatus,
                      border: const OutlineInputBorder(),
                    ),
                    items: [
                      DropdownMenuItem(
                          value: 'pending',
                          child: Text(l10n.requestsStatusPending)),
                      DropdownMenuItem(
                          value: 'awaiting_offers',
                          child: Text(l10n.requestsStatusAwaitingOffers)),
                      DropdownMenuItem(
                          value: 'accepted',
                          child: Text(l10n.requestsStatusAccepted)),
                      DropdownMenuItem(
                          value: 'in_progress',
                          child: Text(l10n.requestsStatusInProgress)),
                      DropdownMenuItem(
                          value: 'completed',
                          child: Text(l10n.requestsStatusCompleted)),
                      DropdownMenuItem(
                          value: 'cancelled',
                          child: Text(l10n.requestsStatusCancelled)),
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
                    decoration: InputDecoration(
                      labelText: l10n.requestAdminOffersStatus,
                      border: const OutlineInputBorder(),
                    ),
                    items: [
                      DropdownMenuItem(
                          value: 'open',
                          child: Text(l10n.requestAdminOffersStatusOpen)),
                      DropdownMenuItem(
                          value: 'accepted',
                          child: Text(l10n.requestAdminOffersStatusAccepted)),
                      DropdownMenuItem(
                          value: 'closed',
                          child: Text(l10n.requestAdminOffersStatusClosed)),
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
              onPressed:
                  isSaving ? null : () => Navigator.of(dialogContext).pop(),
              child: Text(l10n.boCommonCancel),
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

                      if (service.isEmpty ||
                          urgency.isEmpty ||
                          description.isEmpty ||
                          location.isEmpty ||
                          phone.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(l10n.requestAdminRequiredFields)),
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
                          SnackBar(content: Text(l10n.requestAdminUpdated)),
                        );
                      } catch (_) {
                        if (!context.mounted) return;
                        setDialogState(() => isSaving = false);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(l10n.requestAdminUpdateFailed)),
                        );
                      }
                    },
              style: FilledButton.styleFrom(backgroundColor: AppColors.navy),
              child: Text(isSaving ? l10n.boCommonSaving : l10n.boCommonSave),
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
        title: Text(AppLocalizations.of(context).requestAdminDeleteTitle),
        content: Text(
          AppLocalizations.of(context).requestAdminDeleteBody(
            request.service,
            request.location,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(AppLocalizations.of(context).boCommonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: FilledButton.styleFrom(backgroundColor: AppColors.danger),
            child: Text(AppLocalizations.of(context).boCommonDelete),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    try {
      await OfferMarketplaceService.deleteRequest(request.id);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(AppLocalizations.of(context).requestAdminDeleted)),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text(AppLocalizations.of(context).requestAdminDeleteFailed)),
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

  String _statusLabel(String status, AppLocalizations l10n) {
    switch (status) {
      case 'accepted':
        return l10n.requestsStatusAccepted;
      case 'awaiting_offers':
        return l10n.requestsStatusAwaitingOffers;
      case 'in_progress':
        return l10n.requestsStatusInProgress;
      case 'completed':
        return l10n.requestsStatusCompleted;
      case 'cancelled':
        return l10n.requestsStatusCancelled;
      default:
        return l10n.requestsStatusPending;
    }
  }

  Widget _buildCard(BuildContext context, MarketplaceRequestItem request) {
    final l10n = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
            color: _statusColor(request.status).withValues(alpha: 0.16)),
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
                    Text(request.service,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 4),
                    Text('${request.urgency} • ${request.location}',
                        style: const TextStyle(color: AppColors.muted)),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: _statusColor(request.status).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(_statusLabel(request.status, l10n),
                    style: TextStyle(
                        color: _statusColor(request.status),
                        fontWeight: FontWeight.w700)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(request.description,
              style: const TextStyle(color: AppColors.text, height: 1.45)),
          const SizedBox(height: 8),
          Text(l10n.requestAdminPhoneValue(request.phone),
              style: const TextStyle(color: AppColors.muted)),
          const SizedBox(height: 8),
          Text(
              l10n.requestAdminOffersValue(
                  request.offersCount, request.offersStatus),
              style: const TextStyle(color: AppColors.muted)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              OutlinedButton.icon(
                onPressed: () => _updateStatus(request.id, 'awaiting_offers'),
                icon: const Icon(Icons.mark_email_unread_outlined),
                label: Text(l10n.requestAdminRelaunch),
              ),
              OutlinedButton.icon(
                onPressed: () => _editRequest(request),
                icon: const Icon(Icons.edit_outlined),
                label: Text(l10n.boCommonEdit),
              ),
              OutlinedButton.icon(
                onPressed: () => _deleteRequest(request),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.danger,
                  side: const BorderSide(color: AppColors.danger),
                ),
                icon: const Icon(Icons.delete_outline),
                label: Text(l10n.boCommonDelete),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(l10n.requestAdminTitle),
        actions: [
          IconButton(
            tooltip: l10n.boCommonBackToBo,
            onPressed: () => context.go('/back-office'),
            icon: const Icon(Icons.dashboard_customize_outlined),
          ),
        ],
      ),
      body: !FirebaseBootstrap.isReady
          ? Center(child: Text(l10n.requestAdminFirebaseUnavailable))
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
                          colors: [
                            AppColors.navy,
                            Color(0xFF154972),
                            AppColors.primary
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(l10n.requestAdminHeroEyebrow,
                              style: const TextStyle(
                                  color: Colors.white70,
                                  fontWeight: FontWeight.w700)),
                          const SizedBox(height: 8),
                          Text(l10n.requestAdminHeroCount(requests.length),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w900)),
                          const SizedBox(height: 6),
                          Text(l10n.requestAdminHeroBody,
                              style: const TextStyle(color: Colors.white70)),
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
                          border: Border.all(
                              color: AppColors.primary.withValues(alpha: 0.08)),
                        ),
                        child: Text(
                          l10n.requestAdminEmpty,
                          style: const TextStyle(color: AppColors.muted),
                        ),
                      )
                    else
                      ...requests.map(
                        (request) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _buildCard(context, request),
                        ),
                      ),
                  ],
                );
              },
            ),
    );
  }
}
