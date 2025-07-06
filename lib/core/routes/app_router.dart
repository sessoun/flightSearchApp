import 'package:flightapp/features/flight_search/presentation/screens/search_result_screen.dart';
import 'package:go_router/go_router.dart';
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
        builder: (context, state) => const SearchResultScreen(),
      ),
      GoRoute(
        path: '/favorites',
        builder: (context, state) => const FavoritesScreen(),
      ),
    ],
  );
}
