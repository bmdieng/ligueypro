import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import '../features/home/presentation/home_page.dart';
import '../features/presentation/presentation_landing_page.dart';
import '../features/presentation/presentation_page.dart';
import '../features/services/presentation/service_search_page.dart';
import '../features/professionals/presentation/professional_page.dart';
import '../features/requests/presentation/request_page.dart';
import '../features/professionals/presentation/add_professional_page.dart';
import '../features/professionals/presentation/all_professionals_page.dart';
import '../features/professionals/presentation/back_office_access_page.dart';
import '../features/professionals/presentation/category_admin_page.dart';
import '../features/professionals/presentation/back_office_dashboard_page.dart';
import '../features/professionals/presentation/professionals_admin_page.dart';
import '../features/professionals/presentation/pro_leads_page.dart';
import '../features/professionals/presentation/pro_marketing_page.dart';
import '../features/professionals/presentation/pro_lead_capture_page.dart';
import '../features/professionals/presentation/pro_leads_admin_page.dart';
import '../features/professionals/presentation/pro_sent_offers_page.dart';
import '../features/professionals/presentation/pro_subscription_page.dart';
import '../features/profile/presentation/app_settings_page.dart';
import '../features/profile/presentation/cgu_page.dart';
import '../features/profile/presentation/help_support_page.dart';
import '../features/profile/presentation/profile_page.dart';
import '../features/requests/presentation/my_requests_page.dart';
import '../features/requests/presentation/request_offers_page.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (_, __) =>
          kIsWeb ? const PresentationLandingPage() : const HomePage(),
    ),
    GoRoute(path: '/app', builder: (_, __) => const HomePage()),
    GoRoute(
        path: '/services/:category',
        builder: (_, state) => ServiceSearchPage(
            category: state.pathParameters['category'] ?? 'Services')),
    GoRoute(
        path: '/professional/:id',
        builder: (_, state) =>
            ProfessionalPage(id: state.pathParameters['id'] ?? '')),
    GoRoute(path: '/request', builder: (_, __) => const RequestPage()),
    GoRoute(path: '/my-requests', builder: (_, __) => const MyRequestsPage()),
    GoRoute(
      path: '/request-offers',
      builder: (_, state) {
        final extra = state.extra;
        if (extra is! Map) {
          return const MyRequestsPage();
        }
        final requestId = extra['requestId']?.toString();
        if (requestId == null || requestId.isEmpty) {
          return const MyRequestsPage();
        }
        return RequestOffersPage(
          requestId: requestId,
          service: extra['service']?.toString() ?? 'Service',
          location: extra['location']?.toString() ?? 'Dakar',
          urgency: extra['urgency']?.toString() ?? 'Standard',
        );
      },
    ),
    GoRoute(path: '/settings', builder: (_, __) => const AppSettingsPage()),
    GoRoute(path: '/help-support', builder: (_, __) => const HelpSupportPage()),
    GoRoute(path: '/cgu', builder: (_, __) => const CguPage()),
    GoRoute(
        path: '/add-professional',
        builder: (_, __) => const AddProfessionalPage()),
    GoRoute(
        path: '/all-professionals',
        builder: (_, __) => const AllProfessionalsPage()),
    GoRoute(
        path: '/pro-subscription',
        builder: (_, __) => const ProSubscriptionPage()),
    GoRoute(path: '/for-pros', builder: (_, __) => const ProMarketingPage()),
    GoRoute(
        path: '/for-pros/apply',
        builder: (_, __) => const ProLeadCapturePage()),
    GoRoute(
      path: '/admin-pro-leads',
      builder: (_, __) => const SecureBackOfficeRoute(
        targetRoute: '/admin-pro-leads',
        title: 'Accès sécurisé aux leads pros',
        child: ProLeadsAdminPage(),
      ),
    ),
    GoRoute(
      path: '/admin-categories',
      builder: (_, __) => const SecureBackOfficeRoute(
        targetRoute: '/admin-categories',
        title: 'Accès sécurisé aux catégories',
        child: CategoryAdminPage(),
      ),
    ),
    GoRoute(
      path: '/admin-professionals',
      builder: (_, __) => const SecureBackOfficeRoute(
        targetRoute: '/admin-professionals',
        title: 'Accès sécurisé aux professionnels',
        child: ProfessionalsAdminPage(),
      ),
    ),
    GoRoute(
      path: '/back-office',
      builder: (_, __) => const SecureBackOfficeRoute(
        targetRoute: '/back-office',
        title: 'Back-office sécurisé',
        child: BackOfficeDashboardPage(),
      ),
    ),
    GoRoute(
      path: '/pro-leads',
      builder: (_, __) => const SecureBackOfficeRoute(
        targetRoute: '/pro-leads',
        title: 'Accès sécurisé aux demandes',
        child: ProLeadsPage(),
      ),
    ),
    GoRoute(
      path: '/pro-sent-offers',
      builder: (_, __) => const SecureBackOfficeRoute(
        targetRoute: '/pro-sent-offers',
        title: 'Accès sécurisé aux offres',
        child: ProSentOffersPage(),
      ),
    ),
    GoRoute(
        path: '/presentation', builder: (_, __) => const PresentationPage()),
    GoRoute(path: '/profile', builder: (_, __) => const ProfilePage()),
  ],
);
