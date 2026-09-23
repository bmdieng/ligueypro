import 'package:go_router/go_router.dart';
import '../features/home/presentation/home_page.dart';
import '../features/presentation/presentation_page.dart';
import '../features/services/presentation/service_search_page.dart';
import '../features/professionals/presentation/professional_page.dart';
import '../features/requests/presentation/request_page.dart';
import '../features/professionals/presentation/add_professional_page.dart';
import '../features/professionals/presentation/all_professionals_page.dart';
import '../features/profile/presentation/cgu_page.dart';
import '../features/profile/presentation/help_support_page.dart';
import '../features/profile/presentation/profile_page.dart';
import '../features/requests/presentation/my_requests_page.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (_, __) => const HomePage()),
    GoRoute(path: '/services/:category', builder: (_, state) =>
      ServiceSearchPage(category: state.pathParameters['category'] ?? 'Services')),
    GoRoute(path: '/professional/:id', builder: (_, state) =>
      ProfessionalPage(id: state.pathParameters['id'] ?? '')),
    GoRoute(path: '/request', builder: (_, __) => const RequestPage()),
    GoRoute(path: '/my-requests', builder: (_, __) => const MyRequestsPage()),
    GoRoute(path: '/help-support', builder: (_, __) => const HelpSupportPage()),
    GoRoute(path: '/cgu', builder: (_, __) => const CguPage()),
    GoRoute(path: '/add-professional', builder: (_, __) => const AddProfessionalPage()),
    GoRoute(path: '/all-professionals', builder: (_, __) => const AllProfessionalsPage()),
    GoRoute(path: '/presentation', builder: (_, __) => const PresentationPage()),
    GoRoute(path: '/profile', builder: (_, __) => const ProfilePage()),
  ],
);
