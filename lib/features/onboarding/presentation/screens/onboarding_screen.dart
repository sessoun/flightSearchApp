import 'package:flightapp/features/onboarding/presentation/screens/onboarding_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../../core/animations/floating_animations.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  final _controller = PageController();
  late AnimationController _backgroundController;
  late AnimationController _heroController;
  int _currentPage = 0;

  final List<OnboardingData> pages = [
    OnboardingData(
      color: const Color(0xFF3A86FF),
      gradientColors: [const Color(0xFF3A86FF), const Color(0xFF6C5CE7)],
      title: 'Search Flights Instantly',
      subtitle: 'Find the best flight deals in seconds with our smart search.',
      icon: Icons.flight_takeoff,
      heroIcon: Icons.travel_explore,
    ),
    OnboardingData(
      color: const Color(0xFF9B5DE5),
      gradientColors: [const Color(0xFF9B5DE5), const Color(0xFFE056FD)],
      title: 'Compare Prices Easily',
      subtitle: 'Compare prices from multiple airlines to get the best deals.',
      icon: Icons.compare_arrows,
      heroIcon: Icons.monetization_on,
    ),
    OnboardingData(
      color: const Color(0xFFFB5607),
      gradientColors: [const Color(0xFFFB5607), const Color(0xFFFF8500)],
      title: 'Book with Confidence',
      subtitle: 'Secure your travel plans with our reliable booking process.',
      icon: Icons.verified_user,
      heroIcon: Icons.celebration,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _backgroundController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _heroController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _backgroundController.forward();
    _heroController.forward();
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _heroController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });

    // Reset and replay hero animation for new page
    _heroController.reset();
    _heroController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: pages[_currentPage].gradientColors,
          ),
        ),
        child: Stack(
          children: [
            // Floating particles background
            ...List.generate(10, (index) => _buildFloatingParticle(index)),

            // Main content
            PageView.builder(
              controller: _controller,
              onPageChanged: _onPageChanged,
              itemCount: pages.length,
              itemBuilder: (context, index) => OnboardingPage(
                data: pages[index],
                heroController: _heroController,
              ),
            ),

            // Bottom navigation
            Positioned(
              bottom: 40,
              left: 20,
              right: 20,
              child: Column(
                children: [
                  SmoothPageIndicator(
                    controller: _controller,
                    count: pages.length,
                    effect: const WormEffect(
                      dotHeight: 12,
                      dotWidth: 12,
                      activeDotColor: Colors.white,
                      dotColor: Colors.white38,
                      spacing: 16,
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_currentPage == pages.length - 1) {
                          context.go('/search');
                        } else {
                          _controller.nextPage(
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOutCubic,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: pages[_currentPage].color,
                        elevation: 8,
                        shadowColor: Colors.black26,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                      ),
                      child: Text(
                        _currentPage == pages.length - 1
                            ? 'Get Started'
                            : 'Next',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingParticle(int index) {
    final random = index * 0.1;
    return Positioned(
      left: (index % 5) * 80.0 + 20,
      top: (index ~/ 5) * 150.0 + 100,
      child: FloatingElement(
        duration: Duration(milliseconds: 2000 + (index * 100)),
        amplitude: 15.0 + (index % 3) * 5,
        child: Opacity(
          opacity: (0.1 + (index % 3) * 0.1).clamp(0.0, 1.0),
          child: Icon(
            Icons.circle,
            size: 8.0 + (index % 3) * 4,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
