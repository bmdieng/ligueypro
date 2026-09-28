import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/network/firebase_bootstrap.dart';
import '../../../core/theme/app_colors.dart';

class _NotificationItem {
  const _NotificationItem({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
    required this.type,
    required this.category,
    this.service,
    this.urgency,
    this.location,
    this.phone,
  });

  final String id;
  final String title;
  final String body;
  final DateTime createdAt;
  final String type;
  final String category;
  final String? service;
  final String? urgency;
  final String? location;
  final String? phone;
}

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  static List<_NotificationItem> _notificationsFromSnapshot(
      Object? snapshotValue) {
    final notifications = <_NotificationItem>[];

    if (snapshotValue is! Map) {
      return notifications;
    }

    for (final entry in snapshotValue.entries) {
      final value = entry.value;
      if (value is! Map) {
        continue;
      }

      notifications.add(
        _NotificationItem(
          id: entry.key.toString(),
          title: value['title']?.toString() ?? 'Nouvelle demande',
          body: value['body']?.toString() ?? 'Une demande a ete soumise.',
          createdAt: _parseDateTime(value['createdAt']),
          type: _resolveType(value),
          category: _resolveCategory(value),
          service: value['service']?.toString(),
          urgency: value['urgency']?.toString(),
          location: value['location']?.toString(),
          phone: value['phone']?.toString(),
        ),
      );
    }

    notifications.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return notifications;
  }

  static String _resolveType(Map value) {
    final rawType = value['type']?.toString().trim();
    if (rawType != null && rawType.isNotEmpty) {
      return rawType;
    }

    final title = value['title']?.toString().trim();
    if (title != null && title.isNotEmpty) {
      return title;
    }

    return 'Nouvelle demande';
  }

  static String _resolveCategory(Map value) {
    final rawCategory = value['category']?.toString().trim();
    if (rawCategory != null && rawCategory.isNotEmpty) {
      return rawCategory;
    }

    final service = value['service']?.toString().trim();
    if (service != null && service.isNotEmpty) {
      return service;
    }

    return 'Non classee';
  }

  static DateTime _parseDateTime(Object? value) {
    if (value is int) {
      return DateTime.fromMillisecondsSinceEpoch(value);
    }

    if (value is num) {
      return DateTime.fromMillisecondsSinceEpoch(value.toInt());
    }

    if (value is String) {
      final parsedMilliseconds = int.tryParse(value);
      if (parsedMilliseconds != null) {
        return DateTime.fromMillisecondsSinceEpoch(parsedMilliseconds);
      }

      final parsedDate = DateTime.tryParse(value);
      if (parsedDate != null) {
        return parsedDate;
      }
    }

    return DateTime.now();
  }

  static String _formatDateTime(DateTime value) {
    final day = value.day.toString().padLeft(2, '0');
    final month = value.month.toString().padLeft(2, '0');
    final year = value.year.toString();
    final hour = value.hour.toString().padLeft(2, '0');
    final minute = value.minute.toString().padLeft(2, '0');
    return '$day/$month/$year a $hour:$minute';
  }

  static Color _urgencyColor(String? urgency) {
    switch (urgency) {
      case 'Tres urgent':
      case 'Très urgent':
        return AppColors.danger;
      case 'Urgent':
        return AppColors.primary;
      default:
        return AppColors.navy;
    }
  }

  static Widget _buildHeader(BuildContext context, int count) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.navy, Color(0xFF1C5A8B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: Colors.white24,
                child: Icon(
                  Icons.notifications_active_outlined,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Text(
            'Notifications',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            count == 0
                ? 'Aucune alerte pour le moment.'
                : '$count notification${count > 1 ? 's' : ''} disponible${count > 1 ? 's' : ''}.',
            style: const TextStyle(color: Colors.white70, height: 1.35),
          ),
          const SizedBox(height: 14),
          OutlinedButton.icon(
            onPressed: () => context.push('/settings'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: const BorderSide(color: Colors.white30),
            ),
            icon: const Icon(Icons.tune),
            label: const Text('Regler les autorisations'),
          ),
        ],
      ),
    );
  }

  static Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.navy.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.notifications_none_outlined,
                size: 34,
                color: AppColors.navy,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Aucune notification a afficher',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            const Text(
              'Les nouvelles demandes et alertes importantes apparaitront ici en temps reel.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.muted, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildNotificationCard(_NotificationItem item) {
    final metadata = <String>[
      if (item.type.isNotEmpty) item.type,
      if (item.category.isNotEmpty) item.category,
      if (item.service != null && item.service!.isNotEmpty) item.service!,
      if (item.location != null && item.location!.isNotEmpty) item.location!,
      if (item.phone != null && item.phone!.isNotEmpty) item.phone!,
    ];

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: AppColors.primary.withValues(alpha: 0.08)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.navy.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.notifications_active_outlined,
                    color: AppColors.navy,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formatDateTime(item.createdAt),
                        style: const TextStyle(
                          color: AppColors.muted,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                if (item.urgency != null && item.urgency!.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color:
                          _urgencyColor(item.urgency!).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      item.urgency!,
                      style: TextStyle(
                        color: _urgencyColor(item.urgency!),
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              item.body,
              style: const TextStyle(
                color: AppColors.text,
                height: 1.45,
              ),
            ),
            if (metadata.isNotEmpty) ...[
              const SizedBox(height: 14),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: metadata
                    .map(
                      (value) => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          value,
                          style: const TextStyle(
                            color: AppColors.muted,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  static Widget _buildBody() {
    if (!FirebaseBootstrap.isReady) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Les notifications ne sont pas disponibles tant que Firebase n\'est pas initialise.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.muted, height: 1.5),
          ),
        ),
      );
    }

    return StreamBuilder<DatabaseEvent>(
      stream: FirebaseDatabase.instance.ref('notifications').onValue,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                'Impossible de charger les notifications pour le moment.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.red.shade700, height: 1.5),
              ),
            ),
          );
        }

        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final notifications =
            _notificationsFromSnapshot(snapshot.data?.snapshot.value);

        return Column(
          children: [
            _buildHeader(context, notifications.length),
            Expanded(
              child: notifications.isEmpty
                  ? _buildEmptyState()
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                      itemCount: notifications.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (_, index) =>
                          _buildNotificationCard(notifications[index]),
                    ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: SafeArea(child: _buildBody()),
    );
  }
}
