import 'package:flutter_test/flutter_test.dart';
import 'package:ligueypro_2_0/app/router.dart';

void main() {
  test('web app opens on the secure back office by default', () {
    expect(defaultWebInitialLocation, '/back-office');
  });

  test('mobile app opens on the main app home by default', () {
    expect(defaultMobileInitialLocation, '/app');
  });
}
