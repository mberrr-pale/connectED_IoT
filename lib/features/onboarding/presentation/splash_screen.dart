import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../app/main_navigation.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../services/profile_storage.dart';
import 'onboarding_screen.dart';
import '../../../app/teacher_navigation.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _reduceMotion = false;
  bool _started = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_started) return;
    _started = true;

    _reduceMotion = MediaQuery.of(context).disableAnimations;

    if (!_reduceMotion) {
      _controller.repeat();
    }

    _startSplash();
  }

  Future<void> _startSplash() async {
    await Future<void>.delayed(const Duration(milliseconds: 2600));

    if (!mounted) return;

    final teacherProfile = await ProfileStorage.loadTeacher();
    final studentProfile = await ProfileStorage.load();

    if (!mounted) return;

    final Widget destination;

    if (teacherProfile != null) {
      destination = const TeacherNavigation();
    } else if (studentProfile != null) {
      destination = const MainNavigation();
    } else {
      destination = const OnboardingScreen();
    }

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, animation, secondaryAnimation) => destination,
        transitionDuration: const Duration(milliseconds: 300),
        transitionsBuilder: (_, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 190,
                  height: 190,
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      final value = _reduceMotion ? 0.0 : _controller.value;

                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          CustomPaint(
                            size: const Size(190, 190),
                            painter: _NetworkPainter(
                              progress: value,
                              color: AppColors.primary,
                              reduceMotion: _reduceMotion,
                            ),
                          ),
                          Transform.scale(
                            scale: _reduceMotion
                                ? 1.0
                                : 1.0 + 0.035 * math.sin(value * 2 * math.pi),
                            child: Container(
                              width: 88,
                              height: 88,
                              decoration: BoxDecoration(
                                color: AppColors.primaryLight,
                                borderRadius: BorderRadius.circular(26),
                                border: Border.all(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.15,
                                  ),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primary.withValues(
                                      alpha: 0.12,
                                    ),
                                    blurRadius: 24,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.sensors_rounded,
                                color: AppColors.primary,
                                size: 48,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  AppConstants.appName,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 29,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.3,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  AppConstants.appTagline,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.6,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: 180,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        return LinearProgressIndicator(
                          minHeight: 5,
                          value: _reduceMotion ? 0.35 : null,
                          backgroundColor: AppColors.primaryLight,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            AppColors.primary,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  'Menghubungkan pengetahuan...',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NetworkPainter extends CustomPainter {
  final double progress;
  final Color color;
  final bool reduceMotion;

  const _NetworkPainter({
    required this.progress,
    required this.color,
    required this.reduceMotion,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // Gelombang koneksi.
    for (int i = 0; i < 3; i++) {
      final phase = reduceMotion ? 0.45 : (progress + i / 3) % 1.0;

      final radius = 52.0 + phase * 35.0;

      paint.color = color.withValues(
        alpha: reduceMotion ? 0.12 : (1 - phase) * 0.28,
      );

      canvas.drawCircle(center, radius, paint);
    }

    // Titik jaringan dan garis koneksi.
    final nodes = <Offset>[
      Offset(center.dx, 10),
      Offset(size.width - 14, center.dy - 28),
      Offset(size.width - 18, center.dy + 35),
      Offset(center.dx, size.height - 10),
      Offset(14, center.dy + 30),
      Offset(18, center.dy - 35),
    ];

    final linePaint = Paint()
      ..color = color.withValues(alpha: 0.20)
      ..strokeWidth = 1.3;

    for (final node in nodes) {
      canvas.drawLine(center, node, linePaint);
    }

    final dotPaint = Paint()..style = PaintingStyle.fill;

    for (int i = 0; i < nodes.length; i++) {
      final node = nodes[i];

      final phase = reduceMotion ? 0.5 : (progress + i / nodes.length) % 1.0;

      dotPaint.color = color.withValues(alpha: 0.45 + phase * 0.55);

      canvas.drawCircle(node, 3.5, dotPaint);
      canvas.drawCircle(
        node,
        6,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1
          ..color = color.withValues(alpha: 0.15),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _NetworkPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.reduceMotion != reduceMotion ||
        oldDelegate.color != color;
  }
}
