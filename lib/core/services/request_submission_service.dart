import 'package:firebase_database/firebase_database.dart';

import '../network/firebase_bootstrap.dart';
import 'app_preferences_service.dart';
import 'request_notification_service.dart';

class ServiceRequestDraft {
  const ServiceRequestDraft({
    required this.service,
    required this.urgency,
    required this.description,
    required this.location,
    required this.phone,
    required this.photoAttached,
  });

  final String service;
  final String urgency;
  final String description;
  final String location;
  final String phone;
  final bool photoAttached;
}

class RequestSubmissionService {
  RequestSubmissionService._();

  static Future<void> submitRequest({
    required ServiceRequestDraft draft,
  }) async {
    final localRequestId = 'request_${DateTime.now().millisecondsSinceEpoch}';
    final requestData = {
      'service': draft.service,
      'urgency': draft.urgency,
      'description': draft.description,
      'location': draft.location,
      'phone': draft.phone,
      'photoAttached': draft.photoAttached,
      'status': 'awaiting_offers',
      'offersStatus': 'open',
      'offersCount': 0,
      'clientPaymentMode': 'direct_to_professional',
      'createdAt': ServerValue.timestamp,
    };

    var requestId = localRequestId;

    if (FirebaseBootstrap.isReady) {
      final requestRef = FirebaseDatabase.instance.ref('requests').push();
      requestId = requestRef.key ?? localRequestId;
      await requestRef.set(requestData);
    }

    await AppPreferencesService.setRecentRequest(
      RecentRequestSummary(
        requestId: requestId,
        service: draft.service,
        urgency: draft.urgency,
        location: draft.location,
        status: 'awaiting_offers',
        createdAt: DateTime.now(),
        offersStatus: 'open',
        offersCount: 0,
      ),
    );

    await RequestNotificationService.sendRequestNotification(
      service: draft.service,
      urgency: draft.urgency,
      location: draft.location,
      phone: draft.phone,
    );
  }
}
