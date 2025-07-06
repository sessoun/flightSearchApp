import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();

  final List<_OnboardingData> pages = [
    _OnboardingData(
      color: Color(0xFF3A86FF),
      title: 'Search Flights Instantly',
      subtitle: 'Find the best flight deals in seconds.',
      imageAsset:
          'https://images.unsplash.com/photo-1436491865332-7a61a109cc05?w=400&h=400&fit=crop&crop=center',
    ),
    _OnboardingData(
      color: Color(0xFF9B5DE5),
      title: 'Compare Prices Easily',
      subtitle: 'Find the best deals on flights from multiple airlines.',
      imageAsset:
          'https://images.unsplash.com/photo-1488646953014-85cb44e25828?w=400&h=400&fit=crop&crop=center',
    ),
    _OnboardingData(
      color: Color(0xFFFB5607),
      title: 'Book with Confidence',
      subtitle: 'Secure your travel plans with our reliable booking process.',
      imageAsset:
          'https://images.unsplash.com/photo-1474302770737-173ee21bab63?w=400&h=400&fit=crop&crop=center',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: pages.length,
            itemBuilder: (context, index) =>
                _OnboardingPage(data: pages[index]),
          ),
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
                    dotHeight: 10,
                    dotWidth: 10,
                    activeDotColor: Colors.white,
                    dotColor: Colors.white54,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_controller.page == pages.length - 1) {
                        context.go('/search');
                      } else {
                        _controller.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    child: Text(
                      _controller.hasClients &&
                              _controller.page == pages.length - 1
                          ? 'Get Started'
                          : 'Next',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingData {
  final Color color;
  final String title;
  final String subtitle;
  final String imageAsset;

  _OnboardingData({
    required this.color,
    required this.title,
    required this.subtitle,
    required this.imageAsset,
  });
}

class _OnboardingPage extends StatelessWidget {
  final _OnboardingData data;

  const _OnboardingPage({required this.data});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      color: data.color,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Image.network(data.imageAsset, fit: BoxFit.contain),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                data.title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                data.subtitle,
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(color: Colors.white70),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
