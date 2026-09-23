import 'package:firebase_database/firebase_database.dart';

import '../network/firebase_bootstrap.dart';

class ProLeadDraft {
  const ProLeadDraft({
    required this.fullName,
    required this.phone,
    required this.service,
    required this.city,
    this.businessName,
    this.note,
  });

  final String fullName;
  final String phone;
  final String service;
  final String city;
  final String? businessName;
  final String? note;
}

class ProLeadItem {
  const ProLeadItem({
    required this.id,
    required this.fullName,
    required this.phone,
    required this.service,
    required this.city,
    required this.status,
    required this.submittedAt,
    required this.source,
    this.businessName,
    this.note,
  });

  final String id;
  final String fullName;
  final String phone;
  final String service;
  final String city;
  final String status;
  final DateTime submittedAt;
  final String source;
  final String? businessName;
  final String? note;
}

class ProLeadCaptureService {
  ProLeadCaptureService._();

  static List<ProLeadItem> leadsFromSnapshot(Object? snapshotValue) {
    final leads = <ProLeadItem>[];

    if (snapshotValue is Map) {
      for (final entry in snapshotValue.entries) {
        final value = entry.value;
        if (value is! Map) {
          continue;
        }

        final submittedAtValue = value['submittedAt'];
        final submittedAt = submittedAtValue is int
            ? DateTime.fromMillisecondsSinceEpoch(submittedAtValue)
            : DateTime.now();

        leads.add(
          ProLeadItem(
            id: value['id']?.toString() ?? entry.key.toString(),
            fullName: value['fullName']?.toString() ?? 'Professionnel',
            phone: value['phone']?.toString() ?? 'Non renseigné',
            service: value['service']?.toString() ?? 'Service',
            city: value['city']?.toString() ?? 'Ville non renseignée',
            status: value['status']?.toString() ?? 'new',
            submittedAt: submittedAt,
            source: value['source']?.toString() ?? 'web',
            businessName: value['businessName']?.toString(),
            note: value['note']?.toString(),
          ),
        );
      }
    }

    leads.sort((a, b) => b.submittedAt.compareTo(a.submittedAt));
    return leads;
  }

  static Future<String> submitLead(ProLeadDraft draft) async {
    final localId = 'pro_lead_${DateTime.now().millisecondsSinceEpoch}';

    if (!FirebaseBootstrap.isReady) {
      return localId;
    }

    final ref = FirebaseDatabase.instance.ref('professional_leads').push();
    await ref.set({
      'id': ref.key ?? localId,
      'fullName': draft.fullName,
      'phone': draft.phone,
      'service': draft.service,
      'city': draft.city,
      'businessName': draft.businessName,
      'note': draft.note,
      'status': 'new',
      'source': 'web_pro_page',
      'submittedAt': ServerValue.timestamp,
    });

    return ref.key ?? localId;
  }

  static Future<void> updateLeadStatus({
    required String leadId,
    required String status,
  }) async {
    if (!FirebaseBootstrap.isReady) {
      return;
    }

    await FirebaseDatabase.instance
        .ref('professional_leads/$leadId')
        .update({'status': status, 'updatedAt': ServerValue.timestamp});
  }
}
