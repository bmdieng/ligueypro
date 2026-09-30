import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/network/firebase_bootstrap.dart';
import '../../../core/theme/app_colors.dart';
import '../../../l10n/generated/app_localizations.dart';

class CategoryAdminPage extends StatefulWidget {
  const CategoryAdminPage({super.key});

  @override
  State<CategoryAdminPage> createState() => _CategoryAdminPageState();
}

class _CategoryAdminPageState extends State<CategoryAdminPage> {
  final TextEditingController _labelController = TextEditingController();
  String _selectedIconKey = _categoryIconChoices.first.key;
  bool _isSubmitting = false;

  static const List<_CategoryIconChoice> _categoryIconChoices = [
    _CategoryIconChoice('plumbing', 'Plomberie', Icons.plumbing),
    _CategoryIconChoice('bolt', 'Électricité', Icons.bolt),
    _CategoryIconChoice(
      'cleaning_services',
      'Ménage',
      Icons.cleaning_services,
    ),
    _CategoryIconChoice('ac_unit', 'Climatisation', Icons.ac_unit),
    _CategoryIconChoice('grass', 'Jardinage', Icons.grass),
    _CategoryIconChoice('build', 'Bricolage', Icons.build),
    _CategoryIconChoice('directions_car', 'Transport', Icons.directions_car),
    _CategoryIconChoice('motorcycle', 'Livraison', Icons.motorcycle),
    _CategoryIconChoice('store', 'Commerce', Icons.store),
    _CategoryIconChoice('computer', 'Informatique', Icons.computer),
    _CategoryIconChoice('child_care', 'Nounou', Icons.child_care),
    _CategoryIconChoice('more_horiz', 'Autre', Icons.more_horiz),
  ];

  Future<void> _createCategory() async {
    final l10n = AppLocalizations.of(context);
    final label = _labelController.text.trim();
    if (label.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.categoryAdminLabelRequired)),
      );
      return;
    }

    if (!FirebaseBootstrap.isReady) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.categoryAdminFirebaseUnavailable)),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final snapshot =
          await FirebaseDatabase.instance.ref('home/categories').get();
      final nextOrder = _nextOrderFromSnapshot(snapshot.value);
      final ref = FirebaseDatabase.instance.ref('home/categories').push();
      await ref.set({
        'id': ref.key,
        'label': label,
        'icon': _selectedIconKey,
        'order': nextOrder,
        'createdAt': ServerValue.timestamp,
      });

      if (!mounted) {
        return;
      }

      _labelController.clear();
      setState(() {
        _selectedIconKey = _categoryIconChoices.first.key;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.categoryAdminCreated)),
      );
    } catch (_) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.categoryAdminCreateFailed)),
      );
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  int _nextOrderFromSnapshot(Object? snapshotValue) {
    final categories = _categoriesFromSnapshot(snapshotValue);
    if (categories.isEmpty) {
      return 0;
    }
    final maxOrder = categories
        .map((category) => category.order)
        .reduce((left, right) => left > right ? left : right);
    return maxOrder + 1;
  }

  Future<void> _deleteCategory(String id) async {
    if (!FirebaseBootstrap.isReady) {
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context).categoryAdminDeleteTitle),
        content: Text(AppLocalizations.of(context).categoryAdminDeleteBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(AppLocalizations.of(context).boCommonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(backgroundColor: AppColors.danger),
            child: Text(AppLocalizations.of(context).boCommonDelete),
          ),
        ],
      ),
    );

    if (confirmed != true) {
      return;
    }

    try {
      await FirebaseDatabase.instance.ref('home/categories/$id').remove();
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(AppLocalizations.of(context).categoryAdminDeleted)),
      );
    } catch (_) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text(AppLocalizations.of(context).categoryAdminDeleteFailed)),
      );
    }
  }

  Future<void> _updateCategory({
    required String id,
    required String label,
    required String iconKey,
  }) async {
    final trimmedLabel = label.trim();
    if (trimmedLabel.isEmpty || !FirebaseBootstrap.isReady) {
      return;
    }

    try {
      await FirebaseDatabase.instance.ref('home/categories/$id').update({
        'label': trimmedLabel,
        'icon': iconKey,
        'updatedAt': ServerValue.timestamp,
      });

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(AppLocalizations.of(context).categoryAdminUpdated)),
      );
    } catch (_) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text(AppLocalizations.of(context).categoryAdminUpdateFailed)),
      );
    }
  }

  Future<void> _reorderCategory(
    List<_CategoryItem> categories,
    int index,
    int direction,
  ) async {
    if (!FirebaseBootstrap.isReady) {
      return;
    }

    final targetIndex = index + direction;
    if (targetIndex < 0 || targetIndex >= categories.length) {
      return;
    }

    final current = categories[index];
    final target = categories[targetIndex];

    try {
      await FirebaseDatabase.instance.ref().update({
        'home/categories/${current.id}/order': target.order,
        'home/categories/${target.id}/order': current.order,
        'home/categories/${current.id}/updatedAt': ServerValue.timestamp,
        'home/categories/${target.id}/updatedAt': ServerValue.timestamp,
      });
    } catch (_) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text(AppLocalizations.of(context).categoryAdminReorderFailed)),
      );
    }
  }

  Future<void> _showEditCategoryDialog(_CategoryItem category) async {
    final labelController = TextEditingController(text: category.label);
    var selectedIconKey = category.iconKey;
    var isSaving = false;

    await showDialog<void>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(AppLocalizations.of(context).categoryAdminEditTitle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: labelController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context).categoryAdminLabel,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: selectedIconKey,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context).categoryAdminIcon,
                  border: const OutlineInputBorder(),
                ),
                items: _categoryIconChoices
                    .map(
                      (choice) => DropdownMenuItem(
                        value: choice.key,
                        child: Row(
                          children: [
                            Icon(choice.icon, color: AppColors.navy),
                            const SizedBox(width: 10),
                            Text(choice.label),
                          ],
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setDialogState(() => selectedIconKey = value);
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: isSaving ? null : () => Navigator.of(context).pop(),
              child: Text(AppLocalizations.of(context).boCommonCancel),
            ),
            FilledButton(
              onPressed: isSaving
                  ? null
                  : () async {
                      final nextLabel = labelController.text.trim();
                      if (nextLabel.isEmpty) {
                        return;
                      }

                      setDialogState(() => isSaving = true);
                      await _updateCategory(
                        id: category.id,
                        label: nextLabel,
                        iconKey: selectedIconKey,
                      );
                      if (context.mounted) {
                        Navigator.of(context).pop();
                      }
                    },
              child: Text(
                isSaving
                    ? AppLocalizations.of(context).boCommonSaving
                    : AppLocalizations.of(context).boCommonSave,
              ),
            ),
          ],
        ),
      ),
    );

    labelController.dispose();
  }

  List<_CategoryItem> _categoriesFromSnapshot(Object? snapshotValue) {
    final categories = <_CategoryItem>[];
    var fallbackOrder = 0;

    if (snapshotValue is Map) {
      for (final entry in snapshotValue.entries) {
        final value = entry.value;
        if (value is! Map) {
          continue;
        }

        final label = value['label']?.toString();
        if (label == null || label.trim().isEmpty) {
          continue;
        }

        categories.add(
          _CategoryItem(
            id: entry.key.toString(),
            label: label,
            iconKey: value['icon']?.toString() ?? 'more_horiz',
            order: _parseOrder(value['order'], fallbackOrder),
          ),
        );
        fallbackOrder++;
      }
    }

    categories.sort((a, b) {
      final aIsOther = a.label.trim().toLowerCase() == 'autres';
      final bIsOther = b.label.trim().toLowerCase() == 'autres';

      if (aIsOther != bIsOther) {
        return aIsOther ? 1 : -1;
      }

      if (a.order != b.order) {
        return a.order.compareTo(b.order);
      }
      return a.label.toLowerCase().compareTo(b.label.toLowerCase());
    });
    return categories;
  }

  int _parseOrder(Object? value, int fallback) {
    if (value is num) {
      return value.toInt();
    }
    if (value is String) {
      return int.tryParse(value) ?? fallback;
    }
    return fallback;
  }

  IconData _iconFromKey(String key) {
    for (final choice in _categoryIconChoices) {
      if (choice.key == key) {
        return choice.icon;
      }
    }
    return Icons.more_horiz;
  }

  @override
  void dispose() {
    _labelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(l10n.categoryAdminTitle),
        actions: [
          IconButton(
            tooltip: l10n.boCommonBackToBo,
            onPressed: () => context.go('/back-office'),
            icon: const Icon(Icons.dashboard_customize_outlined),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
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
                Text(
                  l10n.categoryAdminHeroTitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.categoryAdminHeroBody,
                  style: const TextStyle(color: Colors.white70, height: 1.4),
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
                Text(
                  l10n.categoryAdminAddTitle,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: _labelController,
                  decoration: InputDecoration(
                    labelText: l10n.categoryAdminLabel,
                    hintText: l10n.categoryAdminLabelHint,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: _selectedIconKey,
                  decoration: InputDecoration(
                    labelText: l10n.categoryAdminIcon,
                    border: const OutlineInputBorder(),
                  ),
                  items: _categoryIconChoices
                      .map(
                        (choice) => DropdownMenuItem(
                          value: choice.key,
                          child: Row(
                            children: [
                              Icon(choice.icon, color: AppColors.navy),
                              const SizedBox(width: 10),
                              Text(choice.label),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _selectedIconKey = value);
                    }
                  },
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: _isSubmitting ? null : _createCategory,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.navy,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    icon: _isSubmitting
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.add_circle_outline),
                    label: Text(
                      _isSubmitting
                          ? l10n.categoryAdminAdding
                          : l10n.categoryAdminAddAction,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          if (!FirebaseBootstrap.isReady)
            _buildOfflineState()
          else
            StreamBuilder<DatabaseEvent>(
              stream: FirebaseDatabase.instance.ref('home/categories').onValue,
              builder: (context, snapshot) {
                final categories = _categoriesFromSnapshot(
                  snapshot.data?.snapshot.value,
                );

                if (categories.isEmpty) {
                  return _buildEmptyState();
                }

                return Column(
                  children: [
                    for (var index = 0; index < categories.length; index++)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AppColors.primary.withValues(alpha: 0.08),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 46,
                                height: 46,
                                decoration: BoxDecoration(
                                  color: AppColors.navy.withValues(alpha: 0.08),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Icon(
                                  _iconFromKey(categories[index].iconKey),
                                  color: AppColors.navy,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      categories[index].label,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      l10n.categoryAdminPositionIcon(
                                        index + 1,
                                        categories[index].iconKey,
                                      ),
                                      style: const TextStyle(
                                        color: AppColors.muted,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                tooltip: l10n.boCommonMoveUp,
                                onPressed: index == 0
                                    ? null
                                    : () => _reorderCategory(
                                          categories,
                                          index,
                                          -1,
                                        ),
                                icon: const Icon(Icons.keyboard_arrow_up),
                              ),
                              IconButton(
                                tooltip: l10n.boCommonMoveDown,
                                onPressed: index == categories.length - 1
                                    ? null
                                    : () => _reorderCategory(
                                          categories,
                                          index,
                                          1,
                                        ),
                                icon: const Icon(Icons.keyboard_arrow_down),
                              ),
                              IconButton(
                                tooltip: l10n.boCommonEdit,
                                onPressed: () => _showEditCategoryDialog(
                                  categories[index],
                                ),
                                icon: const Icon(
                                  Icons.edit_outlined,
                                  color: AppColors.navy,
                                ),
                              ),
                              IconButton(
                                tooltip: l10n.boCommonDelete,
                                onPressed: () =>
                                    _deleteCategory(categories[index].id),
                                icon: const Icon(
                                  Icons.delete_outline,
                                  color: AppColors.danger,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.08)),
      ),
      child: Column(
        children: [
          const Icon(Icons.category_outlined,
              size: 42, color: AppColors.primary),
          const SizedBox(height: 12),
          Text(
            AppLocalizations.of(context).categoryAdminEmptyTitle,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context).categoryAdminEmptyBody,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.muted, height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget _buildOfflineState() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.08)),
      ),
      child: Column(
        children: [
          const Icon(Icons.cloud_off_outlined,
              size: 42, color: AppColors.danger),
          const SizedBox(height: 12),
          Text(
            AppLocalizations.of(context).categoryAdminOfflineTitle,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context).categoryAdminOfflineBody,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.muted, height: 1.4),
          ),
        ],
      ),
    );
  }
}

class _CategoryItem {
  const _CategoryItem({
    required this.id,
    required this.label,
    required this.iconKey,
    required this.order,
  });

  final String id;
  final String label;
  final String iconKey;
  final int order;
}

class _CategoryIconChoice {
  const _CategoryIconChoice(this.key, this.label, this.icon);

  final String key;
  final String label;
  final IconData icon;
}
