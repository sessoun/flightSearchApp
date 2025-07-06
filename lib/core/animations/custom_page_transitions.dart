import 'package:flutter/material.dart';

class CustomPageTransitions {
  // Slide transition with color morphing
  static Widget slideTransitionBuilder(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    const begin = Offset(1.0, 0.0);
    const end = Offset.zero;
    const curve = Curves.easeInOutCubic;

    var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

    return SlideTransition(position: animation.drive(tween), child: child);
  }

  // Scale transition with fade
  static Widget scaleTransitionBuilder(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return ScaleTransition(
      scale: Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(parent: animation, curve: Curves.elasticOut)),
      child: FadeTransition(opacity: animation, child: child),
    );
  }

  // Custom morphing transition
  static Widget morphTransitionBuilder(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(animation.value * 0.1)
            ..scale(0.8 + (animation.value * 0.2)),
          child: Opacity(
            opacity: animation.value.clamp(0.0, 1.0),
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  // Circular reveal transition
  static Widget circularRevealTransitionBuilder(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return ClipOval(
          clipper: CircularRevealClipper(
            fraction: animation.value,
            centerAlignment: Alignment.center,
          ),
          child: child,
        );
      },
      child: child,
    );
  }

  // Liquid-like morphing transition
  static Widget liquidTransitionBuilder(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return ClipPath(
          clipper: LiquidClipper(animationValue: animation.value),
          child: child,
        );
      },
      child: child,
    );
  }
}

// Custom clipper for circular reveal
class CircularRevealClipper extends CustomClipper<Rect> {
  final double fraction;
  final Alignment centerAlignment;

  CircularRevealClipper({
    required this.fraction,
    this.centerAlignment = Alignment.center,
  });

  @override
  Rect getClip(Size size) {
    final center = centerAlignment.alongSize(size);
    final minSize = size.shortestSide;
    final radius = minSize * fraction;

    return Rect.fromCircle(center: center, radius: radius);
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return true;
  }
}

// Custom clipper for liquid effect
class LiquidClipper extends CustomClipper<Path> {
  final double animationValue;

  LiquidClipper({required this.animationValue});

  @override
  Path getClip(Size size) {
    final path = Path();
    final waveHeight = 20.0;
    final waveLength = size.width / 4;

    path.moveTo(0, 0);
    path.lineTo(0, size.height * animationValue - waveHeight);

    for (double i = 0; i <= size.width; i += waveLength) {
      path.quadraticBezierTo(
        i + waveLength / 2,
        size.height * animationValue + waveHeight,
        i + waveLength,
        size.height * animationValue - waveHeight,
      );
    }

    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
