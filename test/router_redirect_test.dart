import 'package:flutter_test/flutter_test.dart';
import 'package:ligueypro_2_0/app/router.dart';

void main() {
  test('protected back office routes stay accessible on web', () {
    expect(resolveWebRedirect('/back-office'), isNull);
    expect(resolveWebRedirect('/admin-offers'), isNull);
    expect(resolveWebRedirect('/admin-requests'), isNull);
  });

  test('public app and pro routes stay accessible on web', () {
    expect(resolveWebRedirect('/for-pros'), isNull);
    expect(resolveWebRedirect('/for-pros/apply'), isNull);
    expect(resolveWebRedirect('/pro-subscription'), isNull);
    expect(resolveWebRedirect('/app'), isNull);
  });

  test('unknown routes still redirect to the back office', () {
    expect(resolveWebRedirect('/unknown'), '/back-office');
  });
}
