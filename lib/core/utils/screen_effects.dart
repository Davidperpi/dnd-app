import 'dart:math' as math;

import 'package:flutter/material.dart';

class ScreenEffects {
  static void showSlash(BuildContext context, Color color) {
    final OverlayState overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    const Duration duration = Duration(milliseconds: 400);

    overlayEntry = OverlayEntry(
      builder: (BuildContext context) => _SlashAnimation(
        color: color,
        duration: duration,
        onFinished: () => overlayEntry.remove(),
      ),
    );

    overlay.insert(overlayEntry);
  }

  static void showMagicBlast(BuildContext context, Color color) {
    final OverlayState overlay = Overlay.of(context);

    late OverlayEntry overlayEntry;
    const Duration duration = Duration(milliseconds: 600);

    overlayEntry = OverlayEntry(
      builder: (BuildContext context) => _MagicBlastAnimation(
        color: color,
        duration: duration,
        onFinished: () => overlayEntry.remove(),
      ),
    );

    overlay.insert(overlayEntry);
  }
}

class _SlashAnimation extends StatefulWidget {
  final Color color;
  final Duration duration;
  final VoidCallback onFinished;

  const _SlashAnimation({
    required this.color,
    required this.duration,
    required this.onFinished,
  });

  @override
  State<_SlashAnimation> createState() => _SlashAnimationState();
}

class _SlashAnimationState extends State<_SlashAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;

  final double _angle = (math.Random().nextBool() ? 1 : -1) * (math.pi / 4);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);

    // The slash grows quickly.
    _scaleAnim = Tween<double>(
      begin: 0.0,
      end: 1.5,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutExpo));

    // And fades out at the end.
    _fadeAnim = Tween<double>(begin: 0.8, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.5, 1.0)),
    );

    _controller.forward().whenComplete(widget.onFinished);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      // Important: Allow user interaction with the UI below.
      child: AnimatedBuilder(
        animation: _controller,
        builder: (BuildContext context, Widget? child) {
          return Opacity(
            opacity: _fadeAnim.value,
            child: Center(
              child: Transform.rotate(
                angle: _angle,
                child: Transform.scale(
                  scaleX: _scaleAnim.value * 2.0, // Horizontally elongated
                  scaleY: _scaleAnim.value * 0.1, // Vertically thin
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: 100,
                    decoration: BoxDecoration(
                      color: widget.color,
                      borderRadius: BorderRadius.circular(100), // Rounded edges
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: widget.color.withOpacity(0.8),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _MagicBlastAnimation extends StatefulWidget {
  final Color color;
  final Duration duration;
  final VoidCallback onFinished;

  const _MagicBlastAnimation({
    required this.color,
    required this.duration,
    required this.onFinished,
  });

  @override
  State<_MagicBlastAnimation> createState() => _MagicBlastAnimationState();
}

class _MagicBlastAnimationState extends State<_MagicBlastAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;
  late Animation<double> _opacityAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);

    // Grows from 0 to 4 times its size.
    _scaleAnim = Tween<double>(
      begin: 0.0,
      end: 4.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutQuad));

    // Fades out gradually.
    _opacityAnim = Tween<double>(begin: 0.6, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.2, 1.0)),
    );

    _controller.forward().whenComplete(widget.onFinished);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (BuildContext context, Widget? child) {
          return Opacity(
            opacity: _opacityAnim.value,
            child: Center(
              child: Transform.scale(
                scale: _scaleAnim.value,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    // Radial gradient to simulate pure energy.
                    gradient: RadialGradient(
                      colors: <Color>[
                        widget.color.withOpacity(0.0), // Transparent center
                        widget.color.withOpacity(0.5), // Main body
                        widget.color.withOpacity(0.0), // Diffuse edge
                      ],
                      stops: const <double>[0.2, 0.6, 1.0],
                    ),
                  ),
                  // Magic icon in the center that also grows and fades.
                  child: Center(
                    child: Icon(
                      Icons.auto_fix_high,
                      color: widget.color,
                      size: 40,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
