import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/network/firebase_bootstrap.dart';
import '../../../core/services/offer_marketplace_service.dart';
import '../../../core/theme/app_colors.dart';

class RequestOffersPage extends StatefulWidget {
  const RequestOffersPage({
    super.key,
    required this.requestId,
    required this.service,
    required this.location,
    required this.urgency,
  });

  final String requestId;
  final String service;
  final String location;
  final String urgency;

  @override
  State<RequestOffersPage> createState() => _RequestOffersPageState();
}

class _RequestOffersPageState extends State<RequestOffersPage> {
  bool _isAccepting = false;

  Future<void> _launchPhone(String phone) async {
    final uri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _acceptOffer(MarketplaceOfferItem offer) async {
    if (_isAccepting) {
      return;
    }

    setState(() => _isAccepting = true);
    await OfferMarketplaceService.acceptOffer(
      requestId: widget.requestId,
      offer: offer,
    );
    if (!mounted) {
      return;
    }
    setState(() => _isAccepting = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Offre de ${offer.professionalName} acceptée. Le règlement se fait ensuite en direct.',
        ),
      ),
    );
  }

  Widget _buildList(MarketplaceRequestDetails details) {
    final offers = details.offers;
    if (offers.isEmpty) {
      return ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border:
                  Border.all(color: AppColors.primary.withValues(alpha: 0.08)),
            ),
            child: const Column(
              children: [
                Icon(Icons.hourglass_top_rounded,
                    size: 42, color: AppColors.primary),
                SizedBox(height: 12),
                Text(
                  'Aucune offre reçue pour le moment',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Text(
                  'Les professionnels abonnés verront votre demande et pourront bientôt proposer leurs prix et délais.',
                  style: TextStyle(color: AppColors.muted, height: 1.4),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: offers.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final offer = offers[index];
        final hasAcceptedOffer = details.acceptedOfferId != null;
        final canAcceptThisOffer = !hasAcceptedOffer || offer.isAccepted;
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: offer.isAccepted
                  ? AppColors.success
                  : offer.highlighted
                      ? AppColors.primary
                      : AppColors.primary.withValues(alpha: 0.08),
              width: offer.isAccepted || offer.highlighted ? 1.5 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      offer.professionalName,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w800),
                    ),
                  ),
                  if (offer.isAccepted)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.success.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: const Text(
                        'Offre acceptée',
                        style: TextStyle(
                            color: AppColors.success,
                            fontWeight: FontWeight.w700,
                            fontSize: 12),
                      ),
                    )
                  else if (offer.highlighted)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: const Text(
                        'Offre mise en avant',
                        style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                            fontSize: 12),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text('${offer.planLabel.toUpperCase()} • ${offer.eta}',
                  style: const TextStyle(color: AppColors.muted)),
              const SizedBox(height: 10),
              Text(offer.price,
                  style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: AppColors.navy)),
              const SizedBox(height: 10),
              Text(offer.message, style: const TextStyle(height: 1.45)),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _launchPhone(offer.phone),
                      icon: const Icon(Icons.phone_outlined),
                      label: Text(
                        offer.isAccepted ? 'Appeler le pro' : 'Contacter',
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: canAcceptThisOffer && !_isAccepting
                          ? () => _acceptOffer(offer)
                          : null,
                      style: FilledButton.styleFrom(
                        backgroundColor: offer.isAccepted
                            ? AppColors.success
                            : AppColors.navy,
                      ),
                      child: Text(
                        offer.isAccepted
                            ? 'Offre retenue'
                            : hasAcceptedOffer
                                ? 'Déjà attribuée'
                                : _isAccepting
                                    ? 'Validation...'
                                    : 'Choisir cette offre',
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final fallbackDetails = OfferMarketplaceService.requestDetailsFromSnapshot(
      widget.requestId,
      null,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Offres reçues')),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.navy, Color(0xFF1D5D90)],
              ),
              borderRadius: BorderRadius.circular(22),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.service,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w800)),
                const SizedBox(height: 6),
                Text('${widget.urgency} • ${widget.location}',
                    style: const TextStyle(color: Colors.white70)),
              ],
            ),
          ),
          Expanded(
            child: FirebaseBootstrap.isReady &&
                    !widget.requestId.startsWith('fallback_')
                ? StreamBuilder<DatabaseEvent>(
                    stream: FirebaseDatabase.instance
                        .ref('requests/${widget.requestId}')
                        .onValue,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return _buildList(fallbackDetails);
                      }
                      final details =
                          OfferMarketplaceService.requestDetailsFromSnapshot(
                        widget.requestId,
                        snapshot.data?.snapshot.value,
                      );
                      return _buildList(
                        details.offers.isEmpty ? fallbackDetails : details,
                      );
                    },
                  )
                : _buildList(fallbackDetails),
          ),
        ],
      ),
    );
  }
}
