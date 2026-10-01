import 'package:flutter_test/flutter_test.dart';
import 'package:ligueypro_2_0/core/services/app_preferences_service.dart';
import 'package:ligueypro_2_0/core/services/pro_subscription_service.dart';
import 'package:ligueypro_2_0/core/services/professional_admin_service.dart';

void main() {
  test('pro subscription plans use realistic, accessible Senegal pricing', () {
    expect(ProSubscriptionService.plans.length, 4);
    expect(ProSubscriptionService.plans[0].id, 'starter');
    expect(ProSubscriptionService.plans[0].priceFcfa, 5000);
    expect(ProSubscriptionService.plans[0].leadsPerMonth, 10);

    expect(ProSubscriptionService.plans[1].id, 'plus');
    expect(ProSubscriptionService.plans[1].priceFcfa, 12000);
    expect(ProSubscriptionService.plans[1].leadsPerMonth, 25);

    expect(ProSubscriptionService.plans[2].id, 'premium');
    expect(ProSubscriptionService.plans[2].priceFcfa, 25000);
    expect(ProSubscriptionService.plans[2].leadsPerMonth, 60);

    expect(ProSubscriptionService.plans[3].id, 'boost');
    expect(ProSubscriptionService.plans[3].priceFcfa, 3000);
    expect(ProSubscriptionService.plans[3].leadsPerMonth, 7);
  });

  test('plans can be hydrated from a back-office offers payload', () {
    final payload = {
      'offers': {
        'starter': {
          'id': 'starter',
          'name': 'Starter',
          'priceFcfa': 5000,
          'leadsPerMonth': 10,
          'billingLabel': '/mois',
          'paymentMethod': 'Orange Money',
          'features': ['Profil visible', '10 demandes'],
        },
        'pro': {
          'id': 'pro',
          'name': 'Pro',
          'priceFcfa': 15000,
          'leadsPerMonth': 30,
          'billingLabel': '/mois',
          'paymentMethod': 'Wave',
          'features': ['30 demandes', 'Mise en avant'],
        },
      },
    };

    final plans = ProSubscriptionService.plansFromRoot(payload);
    expect(plans.length, 2);
    expect(plans.first.id, 'starter');
    expect(plans.last.name, 'Pro');
    expect(plans.last.paymentMethod, 'Wave');
  });

  test('connected non-pro professionals are explicitly identified', () {
    final summary = CurrentProfessionalSummary(
      professionalId: 'p-1',
      name: 'Jean',
      phone: '+221771234567',
      service: 'Plombier',
      planLabel: 'none',
      isSubscribed: false,
    );

    expect(summary.isPro, isFalse);
    expect(summary.isSubscribed, isFalse);
    expect(summary.toJson()['isSubscribed'], isFalse);

    final restored = CurrentProfessionalSummary.fromJson(summary.toJson());
    expect(restored.isPro, isFalse);
    expect(restored.planLabel, 'none');
  });

  test('active pro status includes all flags used by the app and BO', () {
    final state = ProfessionalAdminService.buildSubscriptionState(
      subscribed: true,
      subscriptionPlan: 'premium',
      creditBalance: 60,
    );

    expect(state['subscribed'], isTrue);
    expect(state['subscriptionPlan'], 'premium');
    expect(state['canReceiveRequests'], isTrue);
    expect(state['canSendOffers'], isTrue);
    expect(state['creditBalance'], 60);

    final inactiveState = ProfessionalAdminService.buildSubscriptionState(
      subscribed: false,
      subscriptionPlan: 'starter',
      creditBalance: 0,
    );

    expect(inactiveState['subscribed'], isFalse);
    expect(inactiveState['subscriptionPlan'], 'none');
    expect(inactiveState['canReceiveRequests'], isFalse);
    expect(inactiveState['canSendOffers'], isFalse);
  });

  test('payment deep links target the selected wallet app for Orange Money and Wave', () {
    final orangeLink = ProSubscriptionService.buildPaymentDeepLink(
      paymentMethod: 'Orange Money',
      amountFcfa: 12000,
      professionalName: 'Jean',
    );
    final waveLink = ProSubscriptionService.buildPaymentDeepLink(
      paymentMethod: 'Wave',
      amountFcfa: 12000,
      professionalName: 'Jean',
    );

    expect(orangeLink.scheme, 'orange-money');
    expect(orangeLink.queryParameters['amount'], '12000');
    expect(waveLink.scheme, 'wave');
    expect(waveLink.queryParameters['amount'], '12000');
  });

  test('non-pro publication is blocked until thresholds are met and can be configured', () {
    final defaultSettings = PublicationSettings.defaultSettings;
    expect(defaultSettings.minCompletedJobs, 3);
    expect(defaultSettings.minReviewsCount, 2);
    expect(defaultSettings.minRatingAverage, 4.0);

    final weakProfile = {
      'subscribed': false,
      'verified': true,
      'completedJobs': 1,
      'reviewsCount': 1,
      'ratingAverage': 3.8,
    };
    expect(
      ProfessionalAdminService.isProfessionalEligibleForPublicDirectory(
        weakProfile,
        settings: defaultSettings,
      ),
      isFalse,
    );

    final strongProfile = {
      'subscribed': false,
      'verified': true,
      'completedJobs': 5,
      'reviewsCount': 3,
      'ratingAverage': 4.5,
    };
    expect(
      ProfessionalAdminService.isProfessionalEligibleForPublicDirectory(
        strongProfile,
        settings: defaultSettings,
      ),
      isTrue,
    );

    final customSettings = defaultSettings.copyWith(
      minCompletedJobs: 10,
      minReviewsCount: 5,
      minRatingAverage: 4.8,
    );
    expect(
      ProfessionalAdminService.isProfessionalEligibleForPublicDirectory(
        strongProfile,
        settings: customSettings,
      ),
      isFalse,
    );
  });
}
