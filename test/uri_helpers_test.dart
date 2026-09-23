import 'package:flutter_test/flutter_test.dart';
import 'package:ligueypro_2_0/core/utils/uri_helpers.dart';

void main() {
  test('safe decode should keep literal percent text intact', () {
    expect(safeDecodeUriComponent('100%'), '100%');
    expect(safeDecodeUriComponent('Plomberie%20%2F%20%C3%89lectricit%C3%A9'),
        'Plomberie / Électricité');
    expect(safeDecodeUriComponent('Recherche'), 'Recherche');
  });
}
