import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/network/firebase_bootstrap.dart';
import '../../../core/theme/app_colors.dart';
import '../../../l10n/generated/app_localizations.dart';

class _RequestItem {
  const _RequestItem({
    required this.id,
    required this.service,
    required this.description,
    required this.urgency,
    required this.location,
    required this.phone,
    required this.status,
    required this.offersStatus,
    required this.offersCount,
    required this.createdAt,
    this.acceptedProfessionalId,
    this.acceptedProfessionalName,
    this.acceptedOfferPrice,
    this.acceptedOfferEta,
  });

  final String id;
  final String service;
  final String description;
  final String urgency;
  final String location;
  final String phone;
  final String status;
  final String offersStatus;
  final int offersCount;
  final DateTime createdAt;
  final String? acceptedProfessionalId;
  final String? acceptedProfessionalName;
  final String? acceptedOfferPrice;
  final String? acceptedOfferEta;
}

enum _RequestDateSort {
  newestFirst,
  oldestFirst,
}

class MyRequestsPage extends StatefulWidget {
  const MyRequestsPage({super.key});

  @override
  State<MyRequestsPage> createState() => _MyRequestsPageState();
}

class _MyRequestsPageState extends State<MyRequestsPage> {
  static const int _pageSize = 20;

  String? _selectedType;
  String? _selectedCategory;
  _RequestDateSort _dateSort = _RequestDateSort.newestFirst;
  int _visibleRequestCount = _pageSize;
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_handleScroll)
      ..dispose();
    super.dispose();
  }

  static const Map<String, int> _urgencyRank = {
    'Très urgent': 3,
    'Urgent': 2,
    'Standard': 1,
  };

  static List<_RequestItem> _requestsFromSnapshot(Object? snapshotValue) {
    final requests = <_RequestItem>[];

    void collectFrom(dynamic value, [String requestId = 'request']) {
      if (value is Map) {
        final service = value['service']?.toString() ?? 'Service';
        final urgency = value['urgency']?.toString() ?? 'Standard';
        final description =
            value['description']?.toString() ?? 'Demande en cours';
        final location = value['location']?.toString() ?? 'Dakar';
        final phone = value['phone']?.toString() ?? 'Téléphone non renseigné';
        final status = value['status']?.toString() ?? 'pending';
        final offersStatus = value['offersStatus']?.toString() ?? 'open';
        final offersCount = value['offersCount'] is num
            ? (value['offersCount'] as num).toInt()
            : 0;
        final acceptedProfessionalId =
            value['acceptedProfessionalId']?.toString();
        final acceptedProfessionalName =
            value['acceptedProfessionalName']?.toString();
        final acceptedOfferPrice = value['acceptedOfferPrice']?.toString();
        final acceptedOfferEta = value['acceptedOfferEta']?.toString();

        final createdAtValue = value['createdAt'];
        final createdAt = createdAtValue is int
            ? DateTime.fromMillisecondsSinceEpoch(createdAtValue)
            : DateTime.now();

        requests.add(
          _RequestItem(
            id: requestId,
            service: service,
            description: description,
            urgency: urgency,
            location: location,
            phone: phone,
            status: status,
            offersStatus: offersStatus,
            offersCount: offersCount,
            createdAt: createdAt,
            acceptedProfessionalId: acceptedProfessionalId,
            acceptedProfessionalName: acceptedProfessionalName,
            acceptedOfferPrice: acceptedOfferPrice,
            acceptedOfferEta: acceptedOfferEta,
          ),
        );
      }
    }

    if (snapshotValue is Map) {
      for (final entry in snapshotValue.entries) {
        collectFrom(entry.value, entry.key.toString());
      }
    }

    return requests;
  }

  static Color _urgencyColor(String urgency) {
    switch (urgency) {
      case 'Très urgent':
        return AppColors.danger;
      case 'Urgent':
        return AppColors.primary;
      default:
        return AppColors.success;
    }
  }

  static String _statusLabel(String status, AppLocalizations l10n) {
    switch (status) {
      case 'accepted':
        return l10n.requestsStatusAccepted;
      case 'awaiting_offers':
        return l10n.requestsStatusAwaitingOffers;
      case 'en_route':
        return l10n.requestsStatusEnRoute;
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

  static Color _statusColor(String status) {
    switch (status) {
      case 'accepted':
        return AppColors.primary;
      case 'awaiting_offers':
        return AppColors.navy;
      case 'en_route':
      case 'in_progress':
        return AppColors.navy;
      case 'completed':
        return AppColors.success;
      case 'cancelled':
        return AppColors.danger;
      default:
        return AppColors.muted;
    }
  }

  static double _statusProgress(String status) {
    switch (status) {
      case 'accepted':
        return 0.4;
      case 'awaiting_offers':
        return 0.25;
      case 'en_route':
        return 0.65;
      case 'in_progress':
        return 0.8;
      case 'completed':
        return 1;
      case 'cancelled':
        return 0;
      default:
        return 0.2;
    }
  }

  static String _offersStatusLabel(
    String offersStatus,
    AppLocalizations l10n,
  ) {
    switch (offersStatus) {
      case 'accepted':
        return l10n.requestsOffersAccepted;
      case 'closed':
        return l10n.requestsOffersClosed;
      default:
        return l10n.requestsOffersOpen;
    }
  }

  List<String> _typeOptions(
      List<_RequestItem> requests, AppLocalizations l10n) {
    final options = requests
        .map((request) => _statusLabel(request.status, l10n))
        .where((status) => status.trim().isNotEmpty)
        .toSet()
        .toList()
      ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

    return <String>[l10n.requestsAllTypes, ...options];
  }

  List<String> _categoryOptions(
    List<_RequestItem> requests,
    AppLocalizations l10n,
  ) {
    final options = requests
        .map((request) => request.service)
        .where((service) => service.trim().isNotEmpty)
        .toSet()
        .toList()
      ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

    return <String>[l10n.requestsAllCategories, ...options];
  }

  List<_RequestItem> _applyFilters(
    List<_RequestItem> requests,
    AppLocalizations l10n,
  ) {
    final filtered = requests.where((request) {
      final matchesType = _selectedType == l10n.requestsAllTypes ||
          _selectedType == null ||
          _statusLabel(request.status, l10n) == _selectedType;
      final matchesCategory = _selectedCategory == l10n.requestsAllCategories ||
          _selectedCategory == null ||
          request.service == _selectedCategory;
      return matchesType && matchesCategory;
    }).toList();

    filtered.sort(
      (a, b) => _dateSort == _RequestDateSort.newestFirst
          ? b.createdAt.compareTo(a.createdAt)
          : a.createdAt.compareTo(b.createdAt),
    );
    return filtered;
  }

  void _syncSelectedFilterValues(
    List<String> typeOptions,
    List<String> categoryOptions,
    AppLocalizations l10n,
  ) {
    if (_selectedType == null || !typeOptions.contains(_selectedType)) {
      _selectedType = l10n.requestsAllTypes;
    }
    if (_selectedCategory == null ||
        !categoryOptions.contains(_selectedCategory)) {
      _selectedCategory = l10n.requestsAllCategories;
    }
  }

  bool _canLoadMore(List<_RequestItem> requests) {
    return requests.length >= _visibleRequestCount;
  }

  void _handleScroll() {
    if (!_scrollController.hasClients) {
      return;
    }

    final position = _scrollController.position;
    if (position.pixels < position.maxScrollExtent - 240) {
      return;
    }

    if (_isLoadingMore) {
      return;
    }

    setState(() {
      _isLoadingMore = true;
      _visibleRequestCount += _pageSize;
    });
  }

  Query _requestsQuery() {
    return FirebaseDatabase.instance
        .ref('requests')
        .orderByChild('createdAt')
        .limitToLast(_visibleRequestCount);
  }

  Widget _buildFilters(
    AppLocalizations l10n,
    List<String> typeOptions,
    List<String> categoryOptions,
  ) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.requestsFilterTitle,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 14),
          DropdownButtonFormField<String>(
            initialValue: _selectedType,
            decoration: InputDecoration(
              labelText: l10n.requestsFilterTypeLabel,
              border: const OutlineInputBorder(),
            ),
            items: typeOptions
                .map(
                  (type) => DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  ),
                )
                .toList(),
            onChanged: (value) {
              if (value == null) {
                return;
              }
              setState(() => _selectedType = value);
            },
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            initialValue: _selectedCategory,
            decoration: InputDecoration(
              labelText: l10n.requestsFilterCategoryLabel,
              border: const OutlineInputBorder(),
            ),
            items: categoryOptions
                .map(
                  (category) => DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  ),
                )
                .toList(),
            onChanged: (value) {
              if (value == null) {
                return;
              }
              setState(() => _selectedCategory = value);
            },
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<_RequestDateSort>(
            initialValue: _dateSort,
            decoration: InputDecoration(
              labelText: l10n.requestsFilterDateLabel,
              border: const OutlineInputBorder(),
            ),
            items: [
              DropdownMenuItem<_RequestDateSort>(
                value: _RequestDateSort.newestFirst,
                child: Text(l10n.requestsSortNewest),
              ),
              DropdownMenuItem<_RequestDateSort>(
                value: _RequestDateSort.oldestFirst,
                child: Text(l10n.requestsSortOldest),
              ),
            ],
            onChanged: (value) {
              if (value == null) {
                return;
              }
              setState(() => _dateSort = value);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingMoreIndicator(
    AppLocalizations l10n, {
    required bool visible,
  }) {
    if (!visible) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(strokeWidth: 2.2),
          ),
          const SizedBox(width: 12),
          Text(
            l10n.requestsLoading,
            style: const TextStyle(
              color: AppColors.muted,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequestCard(
    BuildContext context,
    AppLocalizations l10n,
    _RequestItem request,
  ) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    request.service,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color:
                        _urgencyColor(request.urgency).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    request.urgency,
                    style: TextStyle(
                      color: _urgencyColor(request.urgency),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: _statusColor(request.status).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                _statusLabel(request.status, l10n),
                style: TextStyle(
                  color: _statusColor(request.status),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              request.description,
              style: const TextStyle(color: AppColors.muted, height: 1.45),
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                minHeight: 8,
                value: _statusProgress(request.status),
                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation<Color>(
                  _statusColor(request.status),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.location_on_outlined,
                    size: 18, color: AppColors.primary),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    request.location,
                    style: const TextStyle(color: AppColors.muted),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.phone_outlined,
                    size: 18, color: AppColors.primary),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    request.phone,
                    style: const TextStyle(color: AppColors.muted),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              l10n.requestsCreatedOn(
                DateFormat.yMd(l10n.localeName).format(request.createdAt),
              ),
              style: const TextStyle(fontSize: 12, color: AppColors.muted),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.requestsOffersCountSummary(
                _offersStatusLabel(request.offersStatus, l10n),
                request.offersCount,
              ),
              style: const TextStyle(
                color: AppColors.navy,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              l10n.requestsDirectPaymentAfterOffer,
              style: TextStyle(color: AppColors.muted),
            ),
            if (request.acceptedProfessionalName != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: AppColors.success.withValues(alpha: 0.18),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.requestsChosenProfessional,
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: AppColors.navy,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      request.acceptedProfessionalName!,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    if (request.acceptedOfferPrice != null)
                      Text(
                        l10n.requestsAcceptedPrice(
                          request.acceptedOfferPrice!,
                        ),
                        style: const TextStyle(color: AppColors.muted),
                      ),
                    if (request.acceptedOfferEta != null)
                      Text(
                        l10n.requestsConfirmedEta(
                          request.acceptedOfferEta!,
                        ),
                        style: const TextStyle(color: AppColors.muted),
                      ),
                    if (request.acceptedProfessionalId != null) ...[
                      const SizedBox(height: 10),
                      OutlinedButton.icon(
                        onPressed: () => context.push(
                          '/professional/${Uri.encodeComponent(request.acceptedProfessionalId!)}',
                        ),
                        icon: const Icon(Icons.person_search_outlined),
                        label: Text(l10n.requestsViewProfile),
                      ),
                    ],
                  ],
                ),
              ),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => context.push(
                      '/request-offers',
                      extra: {
                        'requestId': request.id,
                        'service': request.service,
                        'location': request.location,
                        'urgency': request.urgency,
                      },
                    ),
                    child: Text(l10n.requestsViewOffers),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: () => context.push('/request'),
                    style:
                        FilledButton.styleFrom(backgroundColor: AppColors.navy),
                    child: Text(l10n.homeNewRequest),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList(
    BuildContext context,
    List<_RequestItem> requests, {
    required bool isWaiting,
  }) {
    final l10n = AppLocalizations.of(context);
    if (_isLoadingMore && !isWaiting) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) {
          return;
        }
        setState(() => _isLoadingMore = false);
      });
    }

    final typeOptions = _typeOptions(requests, l10n);
    final categoryOptions = _categoryOptions(requests, l10n);
    _syncSelectedFilterValues(typeOptions, categoryOptions, l10n);

    final filteredRequests = _applyFilters(requests, l10n);
    final hasActiveFilters = _selectedType != l10n.requestsAllTypes ||
        _selectedCategory != l10n.requestsAllCategories;
    final canLoadMore = _canLoadMore(requests);

    if (requests.isEmpty) {
      return ListView(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        children: [
          _buildFilters(l10n, typeOptions, categoryOptions),
          const SizedBox(height: 16),
          _EmptyRequestsState(
            title: l10n.requestsEmptyTitle,
            message: l10n.requestsEmptyMessage,
          ),
          _buildLoadingMoreIndicator(l10n, visible: _isLoadingMore),
        ],
      );
    }

    if (filteredRequests.isEmpty) {
      return ListView(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        children: [
          _buildFilters(l10n, typeOptions, categoryOptions),
          const SizedBox(height: 16),
          _EmptyRequestsState(
            title: l10n.requestsNoFilterResultsTitle,
            message: hasActiveFilters
                ? l10n.requestsNoFilterResultsMessage
                : l10n.requestsNoRequestsAvailable,
          ),
          _buildLoadingMoreIndicator(l10n, visible: _isLoadingMore),
        ],
      );
    }

    return ListView.separated(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: filteredRequests.length + 1 + (canLoadMore ? 1 : 0),
      separatorBuilder: (_, index) =>
          index == 0 ? const SizedBox(height: 16) : const SizedBox(height: 12),
      itemBuilder: (context, index) {
        if (index == 0) {
          return _buildFilters(l10n, typeOptions, categoryOptions);
        }

        if (index == filteredRequests.length + 1) {
          return _buildLoadingMoreIndicator(l10n, visible: _isLoadingMore);
        }

        final request = filteredRequests[index - 1];
        return _buildRequestCard(context, l10n, request);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context).requestsMyTitle)),
      body: SafeArea(
        child: FirebaseBootstrap.isReady
            ? StreamBuilder<DatabaseEvent>(
                stream: _requestsQuery().onValue,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return _buildList(
                      context,
                      const [],
                      isWaiting:
                          snapshot.connectionState == ConnectionState.waiting,
                    );
                  }

                  final requests =
                      _requestsFromSnapshot(snapshot.data?.snapshot.value);
                  return _buildList(
                    context,
                    requests,
                    isWaiting:
                        snapshot.connectionState == ConnectionState.waiting,
                  );
                },
              )
            : _buildList(context, const [], isWaiting: false),
      ),
    );
  }
}

class _EmptyRequestsState extends StatelessWidget {
  const _EmptyRequestsState({
    required this.title,
    required this.message,
  });

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.navy.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.receipt_long_outlined,
              color: AppColors.navy,
              size: 30,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.muted, height: 1.5),
          ),
        ],
      ),
    );
  }
}
