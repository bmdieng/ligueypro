import 'package:flutter_test/flutter_test.dart';
import 'package:ligueypro_2_0/core/services/professional_credit_service.dart';

void main() {
  test('credit balance increases by the pack size after validation', () {
    final nextBalance = ProfessionalCreditService.calculateUpdatedBalance(
      currentBalance: 4,
      offerLeads: 10,
    );

    expect(nextBalance, 14);
  });

  test('boost is active only when the timestamp is still in the future', () {
    final now = DateTime(2026, 10, 1, 12, 0, 0);

    expect(
      ProfessionalCreditService.isBoostActive(
        boostUntil: now.add(const Duration(days: 2)).millisecondsSinceEpoch,
        now: now,
      ),
      isTrue,
    );

    expect(
      ProfessionalCreditService.isBoostActive(
        boostUntil: now.subtract(const Duration(days: 1)).millisecondsSinceEpoch,
        now: now,
      ),
      isFalse,
    );
  });

  test('boost helper exposes a usable status label and remaining time', () {
    final now = DateTime(2026, 10, 1, 12, 0, 0);
    final futureBoost = now.add(const Duration(days: 3, hours: 4)).millisecondsSinceEpoch;

    final status = ProfessionalCreditService.formatBoostStatus(
      boostUntil: futureBoost,
      now: now,
    );

    expect(status, contains('Boost actif'));
    expect(status, contains('3j'));
  });
}
