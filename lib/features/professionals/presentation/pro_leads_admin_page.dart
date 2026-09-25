import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/network/firebase_bootstrap.dart';
import '../../../core/services/pro_lead_capture_service.dart';
import '../../../core/theme/app_colors.dart';

class ProLeadsAdminPage extends StatefulWidget {
  const ProLeadsAdminPage({super.key});

  @override
  State<ProLeadsAdminPage> createState() => _ProLeadsAdminPageState();
}

class _ProLeadsAdminPageState extends State<ProLeadsAdminPage> {
  String _selectedStatus = 'all';

  bool _isLeadOverdue(ProLeadItem lead) {
    return lead.status != 'qualified' &&
        lead.status != 'rejected' &&
        DateTime.now().difference(lead.submittedAt) > const Duration(hours: 24);
  }

  int _leadPriorityScore(ProLeadItem lead) {
    if (_isLeadOverdue(lead) && lead.status == 'new') {
      return 0;
    }
    if (_isLeadOverdue(lead) && lead.status == 'contacted') {
      return 1;
    }
    if (lead.status == 'new') {
      return 2;
    }
    if (lead.status == 'contacted') {
      return 3;
    }
    if (lead.status == 'qualified') {
      return 4;
    }
    return 5;
  }

  List<ProLeadItem> _sortLeadsForOps(List<ProLeadItem> leads) {
    final sorted = [...leads];
    sorted.sort((a, b) {
      final priorityCompare =
          _leadPriorityScore(a).compareTo(_leadPriorityScore(b));
      if (priorityCompare != 0) {
        return priorityCompare;
      }

      return b.submittedAt.compareTo(a.submittedAt);
    });
    return sorted;
  }

  int _countByStatus(List<ProLeadItem> leads, String status) {
    return leads.where((lead) => lead.status == status).length;
  }

  int _countRecentLeads(List<ProLeadItem> leads, Duration duration) {
    final now = DateTime.now();
    return leads
        .where((lead) => now.difference(lead.submittedAt) <= duration)
        .length;
  }

  int _countOverdueLeads(List<ProLeadItem> leads) {
    final now = DateTime.now();
    return leads
        .where(
          (lead) =>
              lead.status != 'qualified' &&
              lead.status != 'rejected' &&
              now.difference(lead.submittedAt) > const Duration(hours: 24),
        )
        .length;
  }

  String _formatRelativeTime(DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);
    if (diff.inMinutes < 1) {
      return 'à l’instant';
    }
    if (diff.inHours < 1) {
      return 'il y a ${diff.inMinutes} min';
    }
    if (diff.inDays < 1) {
      return 'il y a ${diff.inHours} h';
    }
    if (diff.inDays < 7) {
      return 'il y a ${diff.inDays} j';
    }
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  Future<void> _launchPhone(String phone) async {
    final uri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _updateStatus(ProLeadItem lead, String status) async {
    await ProLeadCaptureService.updateLeadStatus(
        leadId: lead.id, status: status);
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Statut mis à jour : ${_statusLabel(status)}')),
    );
  }

  String _statusLabel(String status) {
    switch (status) {
      case 'contacted':
        return 'Contacté';
      case 'qualified':
        return 'Qualifié';
      case 'rejected':
        return 'Refusé';
      default:
        return 'Nouveau';
    }
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'contacted':
        return AppColors.navy;
      case 'qualified':
        return AppColors.success;
      case 'rejected':
        return AppColors.danger;
      default:
        return AppColors.primary;
    }
  }

  Widget _buildStatusFilter() {
    const statuses = ['all', 'new', 'contacted', 'qualified', 'rejected'];
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final status in statuses)
          ChoiceChip(
            label: Text(status == 'all' ? 'Tous' : _statusLabel(status)),
            selected: _selectedStatus == status,
            onSelected: (_) {
              setState(() {
                _selectedStatus = status;
              });
            },
          ),
      ],
    );
  }

  Widget _buildContent(
    List<ProLeadItem> leads, {
    required DateTime? syncedAt,
    required bool isLiveSync,
  }) {
    final filteredLeads = _selectedStatus == 'all'
        ? leads
        : leads.where((lead) => lead.status == _selectedStatus).toList();
    final prioritizedLeads = _sortLeadsForOps(filteredLeads);
    final newCount = leads.where((lead) => lead.status == 'new').length;
    final qualifiedCount = _countByStatus(leads, 'qualified');
    final contactedCount = _countByStatus(leads, 'contacted');
    final rejectedCount = _countByStatus(leads, 'rejected');
    final recentCount = _countRecentLeads(leads, const Duration(hours: 24));
    final overdueCount = _countOverdueLeads(leads);
    final latestLead = leads.isEmpty ? null : leads.first;
    final qualificationRate =
        leads.isEmpty ? 0.0 : (qualifiedCount / leads.length) * 100;

    if (leads.isEmpty) {
      return ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildHeader(leads, recentCount, latestLead, syncedAt, isLiveSync),
          const SizedBox(height: 16),
          _buildEmptyState(isLiveSync: isLiveSync),
        ],
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildHeader(leads, recentCount, latestLead, syncedAt, isLiveSync),
        const SizedBox(height: 16),
        if (overdueCount > 0)
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.danger.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: AppColors.danger.withValues(alpha: 0.18),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: AppColors.danger.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.alarm_on_outlined,
                    color: AppColors.danger,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$overdueCount lead(s) nécessitent une relance rapide',
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          color: AppColors.text,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Ces leads n’ont pas encore été qualifiés ni clôturés après 24 heures. Priorisez leur traitement pour éviter une perte de conversion.',
                        style: TextStyle(
                          color: AppColors.muted,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        if (overdueCount > 0) const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border:
                Border.all(color: AppColors.primary.withValues(alpha: 0.08)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Vue dynamique',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _InsightTile(
                      label: 'Contactés',
                      value: '$contactedCount',
                      helper: 'relances en cours',
                      color: AppColors.navy,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _InsightTile(
                      label: 'Qualification',
                      value: '${qualificationRate.toStringAsFixed(0)}%',
                      helper: '$rejectedCount refusé(s)',
                      color: AppColors.success,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _StatusProgressBar(
                label: 'Nouveaux',
                count: newCount,
                total: leads.length,
                color: AppColors.primary,
              ),
              const SizedBox(height: 8),
              _StatusProgressBar(
                label: 'Contactés',
                count: contactedCount,
                total: leads.length,
                color: AppColors.navy,
              ),
              const SizedBox(height: 8),
              _StatusProgressBar(
                label: 'Qualifiés',
                count: qualifiedCount,
                total: leads.length,
                color: AppColors.success,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border:
                Border.all(color: AppColors.primary.withValues(alpha: 0.08)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Filtres',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 12),
              _buildStatusFilter(),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.sort_outlined,
                      color: AppColors.navy,
                      size: 18,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Liste triée automatiquement : urgences en retard, nouveaux leads, relances en cours, puis dossiers clôturés.',
                        style: TextStyle(
                          color: AppColors.muted,
                          height: 1.35,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        if (filteredLeads.isEmpty)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border:
                  Border.all(color: AppColors.primary.withValues(alpha: 0.08)),
            ),
            child: const Text(
              'Aucun lead ne correspond au filtre sélectionné.',
              style: TextStyle(color: AppColors.muted),
            ),
          )
        else
          ...prioritizedLeads.map(
            (lead) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: _statusColor(lead.status).withValues(alpha: 0.16),
                  ),
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
                              Text(
                                lead.fullName,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${lead.service} • ${lead.city}',
                                style: const TextStyle(color: AppColors.muted),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: _statusColor(lead.status)
                                .withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            _statusLabel(lead.status),
                            style: TextStyle(
                              color: _statusColor(lead.status),
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (lead.businessName != null &&
                        lead.businessName!.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Text(
                        lead.businessName!,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ],
                    const SizedBox(height: 10),
                    Text('Téléphone : ${lead.phone}'),
                    const SizedBox(height: 4),
                    Text(
                      'Source : ${lead.source} • ${_formatRelativeTime(lead.submittedAt)}',
                      style: const TextStyle(color: AppColors.muted),
                    ),
                    if (lead.note != null && lead.note!.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Text(lead.note!, style: const TextStyle(height: 1.4)),
                    ],
                    if (_isLeadOverdue(lead)) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.danger.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.timer_off_outlined,
                              color: AppColors.danger,
                              size: 18,
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Lead en attente depuis plus de 24h',
                                style: TextStyle(
                                  color: AppColors.danger,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 14),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        OutlinedButton.icon(
                          onPressed: () => _launchPhone(lead.phone),
                          icon: const Icon(Icons.phone_outlined),
                          label: const Text('Appeler'),
                        ),
                        OutlinedButton.icon(
                          onPressed: lead.status == 'contacted'
                              ? null
                              : () => _updateStatus(lead, 'contacted'),
                          icon: const Icon(Icons.phone_in_talk_outlined),
                          label: const Text('Marquer contacté'),
                        ),
                        OutlinedButton.icon(
                          onPressed: lead.status == 'qualified'
                              ? null
                              : () => _updateStatus(lead, 'qualified'),
                          icon: const Icon(Icons.verified_outlined),
                          label: const Text('Qualifier'),
                        ),
                        OutlinedButton.icon(
                          onPressed: lead.status == 'rejected'
                              ? null
                              : () => _updateStatus(lead, 'rejected'),
                          icon: const Icon(Icons.block_outlined),
                          label: const Text('Refuser'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Leads pros'),
        actions: [
          IconButton(
            tooltip: 'Retour BO',
            onPressed: () => context.go('/back-office'),
            icon: const Icon(Icons.dashboard_customize_outlined),
          ),
        ],
      ),
      body: FirebaseBootstrap.isReady
          ? StreamBuilder<DatabaseEvent>(
              stream:
                  FirebaseDatabase.instance.ref('professional_leads').onValue,
              builder: (context, snapshot) {
                final leads = ProLeadCaptureService.leadsFromSnapshot(
                  snapshot.data?.snapshot.value,
                );
                return _buildContent(
                  leads,
                  syncedAt: snapshot.hasData ? DateTime.now() : null,
                  isLiveSync: snapshot.hasData,
                );
              },
            )
          : _buildContent(const [], syncedAt: null, isLiveSync: false),
    );
  }

  Widget _buildHeader(
    List<ProLeadItem> leads,
    int recentCount,
    ProLeadItem? latestLead,
    DateTime? syncedAt,
    bool isLiveSync,
  ) {
    final newCount = leads.where((lead) => lead.status == 'new').length;
    final qualifiedCount = _countByStatus(leads, 'qualified');

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.navy, Color(0xFF154972), AppColors.primary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Leads professionnels',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Consultez les demandes entrantes des professionnels, qualifiez-les puis orientez-les vers le bon niveau d’abonnement.',
                      style: TextStyle(color: Colors.white70, height: 1.4),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.12),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(22),
                  child: Image.asset(
                    'assets/ligueyPro2.0_.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _LeadStatusPill(
                label: 'Live',
                value: '${leads.length} actifs',
                color: AppColors.primary,
              ),
              _LeadStatusPill(
                label: '24h',
                value: '$recentCount entrants',
                color: AppColors.success,
              ),
              if (latestLead != null)
                _LeadStatusPill(
                  label: 'Dernier lead',
                  value: _formatRelativeTime(latestLead.submittedAt),
                  color: Colors.white,
                  textColor: AppColors.navy,
                ),
              _LeadStatusPill(
                label: isLiveSync ? 'Synchro' : 'Mode',
                value: isLiveSync && syncedAt != null
                    ? _formatRelativeTime(syncedAt)
                    : 'hors ligne',
                color: isLiveSync ? AppColors.navy : AppColors.danger,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _LeadMetric(label: 'Total', value: '${leads.length}'),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _LeadMetric(label: 'Nouveaux', value: '$newCount'),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _LeadMetric(
                  label: 'Qualifiés',
                  value: '$qualifiedCount',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState({required bool isLiveSync}) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.08)),
      ),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.groups_2_outlined,
              color: AppColors.navy,
              size: 32,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Aucun lead professionnel pour le moment',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Text(
            isLiveSync
                ? 'La connexion Firebase est active, mais aucune soumission n’a encore été enregistrée dans professional_leads.'
                : 'Firebase n’est pas disponible. La vue n’affiche plus de données mockées.',
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.muted, height: 1.4),
          ),
        ],
      ),
    );
  }
}

class _LeadMetric extends StatelessWidget {
  const _LeadMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }
}

class _LeadStatusPill extends StatelessWidget {
  const _LeadStatusPill({
    required this.label,
    required this.value,
    required this.color,
    this.textColor = Colors.white,
  });

  final String label;
  final String value;
  final Color color;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color:
            textColor == Colors.white ? color.withValues(alpha: 0.18) : color,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        '$label • $value',
        style: TextStyle(color: textColor, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _InsightTile extends StatelessWidget {
  const _InsightTile({
    required this.label,
    required this.value,
    required this.helper,
    required this.color,
  });

  final String label;
  final String value;
  final String helper;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: AppColors.muted)),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(helper, style: const TextStyle(color: AppColors.muted)),
        ],
      ),
    );
  }
}

class _StatusProgressBar extends StatelessWidget {
  const _StatusProgressBar({
    required this.label,
    required this.count,
    required this.total,
    required this.color,
  });

  final String label;
  final int count;
  final int total;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final ratio = total == 0 ? 0.0 : count / total;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
            Text(
              '$count / $total',
              style: const TextStyle(color: AppColors.muted),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: ratio,
            minHeight: 9,
            backgroundColor: color.withValues(alpha: 0.12),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}
