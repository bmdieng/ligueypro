import 'package:flutter_test/flutter_test.dart';
import 'package:ligueypro_2_0/core/services/professional_admin_service.dart';

void main() {
  test(
      'serviceOptionsFromCategories keeps configured services sorted and unique',
      () {
    final root = {
      'home': {
        'categories': {
          'cat_2': {'label': 'Électricien', 'order': 2},
          'cat_1': {'label': 'Plombier', 'order': 1},
          'cat_3': {'label': 'Plombier', 'order': 3},
          'cat_4': {'label': 'Jardinage', 'order': 0},
        }
      }
    };

    final home = root['home'] as Map?;
    final categories = home?['categories'];

    expect(
      ProfessionalAdminService.serviceOptionsFromCategories(categories),
      ['Jardinage', 'Plombier', 'Électricien'],
    );
  });

  test('serviceOptionsFromCategories handles list-based category payloads', () {
    final categories = [
      null,
      {'label': 'Plombier', 'icon': 'plumbing', 'order': 1},
      {'label': 'Électricien', 'icon': 'bolt', 'order': 2},
      {'label': 'Ménage', 'icon': 'cleaning_services', 'order': 3},
      {'label': 'Plombier', 'icon': 'plumbing', 'order': 4},
    ];

    expect(
      ProfessionalAdminService.serviceOptionsFromCategories(categories),
      ['Plombier', 'Électricien', 'Ménage'],
    );
  });
}
