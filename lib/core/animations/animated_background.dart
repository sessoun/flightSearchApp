import 'package:flutter/material.dart';

class AnimatedBackground extends StatefulWidget {
  final Widget child;
  final Color color;
  final Duration duration;
  final List<Color>? gradientColors;
  final bool useGradient;

  const AnimatedBackground({
    super.key,
    required this.child,
    required this.color,
    this.duration = const Duration(milliseconds: 800),
    this.gradientColors,
    this.useGradient = false,
  });

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;
  late Animation<double> _waveAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);

    _waveAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );

    _colorAnimation = ColorTween(
      begin: Colors.transparent,
      end: widget.color,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.forward();
  }

  @override
  void didUpdateWidget(AnimatedBackground oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.color != widget.color) {
      _colorAnimation = ColorTween(
        begin: oldWidget.color,
        end: widget.color,
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          decoration: widget.useGradient && widget.gradientColors != null
              ? BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: widget.gradientColors!,
                    stops: [0.0, _waveAnimation.value, 1.0],
                  ),
                )
              : BoxDecoration(color: _colorAnimation.value ?? widget.color),
          child: widget.child,
        );
      },
    );
  }
}

class MorphingBackground extends StatefulWidget {
  final Widget child;
  final List<Color> colors;
  final Duration duration;
  final Curve curve;

  const MorphingBackground({
    super.key,
    required this.child,
    required this.colors,
    this.duration = const Duration(seconds: 3),
    this.curve = Curves.easeInOut,
  });

  @override
  State<MorphingBackground> createState() => _MorphingBackgroundState();
}

class _MorphingBackgroundState extends State<MorphingBackground>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  int _currentColorIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);

    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: widget.curve));

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _currentColorIndex = (_currentColorIndex + 1) % widget.colors.length;
        });
        _controller.reset();
        _controller.forward();
      }
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final nextColorIndex = (_currentColorIndex + 1) % widget.colors.length;
        return Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.center,
              radius: 1.0 + _animation.value,
              colors: [
                Color.lerp(
                  widget.colors[_currentColorIndex],
                  widget.colors[nextColorIndex],
                  _animation.value,
                )!,
                widget.colors[_currentColorIndex],
              ],
            ),
          ),
          child: widget.child,
        );
      },
    );
  }
}
