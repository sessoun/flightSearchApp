import 'package:flightapp/features/flight_search/presentation/screens/search_result_screen.dart';
import 'package:go_router/go_router.dart';
import '../animations/custom_page_transitions.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/flight_search/presentation/screens/flight_search_screen.dart';
import '../../features/favorites/presentation/screens/favorites_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => const OnboardingScreen()),
      GoRoute(
        path: '/search',
        builder: (context, state) => const FlightSearchScreen(),
      ),
      GoRoute(
        path: '/search/result',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const SearchResultScreen(),
          transitionsBuilder: CustomPageTransitions.slideTransitionBuilder,
          transitionDuration: const Duration(milliseconds: 600),
        ),
      ),
      GoRoute(
        path: '/favorites',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const FavoritesScreen(),
          transitionsBuilder: CustomPageTransitions.liquidTransitionBuilder,
          transitionDuration: const Duration(milliseconds: 700),
        ),
      ),
    ],
  );
}
