import 'dart:math';
import 'package:flutter/material.dart';
import 'package:journey/widgets/apptheme.dart';

class SpaceBackground extends StatefulWidget {
  final Widget child;

  const SpaceBackground({Key? key, required this.child}) : super(key: key);

  @override
  State<SpaceBackground> createState() => _SpaceBackgroundState();
}

class _SpaceBackgroundState extends State<SpaceBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  List<StarData> stars = [];
  final int starCount = 150;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    // Generate random stars
    final random = Random();
    for (int i = 0; i < starCount; i++) {
      stars.add(StarData(
        x: random.nextDouble(),
        y: random.nextDouble(),
        size: random.nextDouble() * 2 + 0.5,
        opacity: random.nextDouble() * 0.7 + 0.3,
        twinkleSpeed: random.nextDouble() * 2 + 1,
      ));
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.spaceGradient,
        ),
        child: Stack(
          children: [
            // Stars layer
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return CustomPaint(
                  size: MediaQuery.of(context).size,
                  painter: StarfieldPainter(
                    stars: stars,
                    animationValue: _animationController.value,
                  ),
                );
              },
            ),
            // Nebula effects
            Opacity(
              opacity: 0.15,
              child: Image.network(
                'https://images.unsplash.com/photo-1534796636912-3b95b3ab5986?q=80&w=1000',
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                errorBuilder: (context, error, stackTrace) {
                  return const SizedBox();
                },
              ),
            ),
            // Content layer
            widget.child,
          ],
        ),
      ),
    );
  }
}

class StarData {
  final double x, y, size, opacity, twinkleSpeed;

  StarData({
    required this.x,
    required this.y,
    required this.size,
    required this.opacity,
    required this.twinkleSpeed,
  });
}

class StarfieldPainter extends CustomPainter {
  final List<StarData> stars;
  final double animationValue;

  StarfieldPainter({required this.stars, required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    for (var star in stars) {
      final twinkle = (sin((animationValue * 2 * pi * star.twinkleSpeed) +
                  (star.x + star.y) * 10) +
              1) /
          2;

      final paint = Paint()
        ..color =
            AppTheme.starWhite.withOpacity(star.opacity * (0.5 + twinkle * 0.5))
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
        Offset(star.x * size.width, star.y * size.height),
        star.size * (0.8 + twinkle * 0.4),
        paint,
      );

      // Add glow effect for some stars
      if (star.size > 1.5) {
        final glowPaint = Paint()
          ..color = AppTheme.galaxyBlue.withOpacity(0.2 * twinkle)
          ..style = PaintingStyle.fill
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

        canvas.drawCircle(
          Offset(star.x * size.width, star.y * size.height),
          star.size * 2.5,
          glowPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant StarfieldPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
