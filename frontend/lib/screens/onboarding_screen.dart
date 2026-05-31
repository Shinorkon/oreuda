import 'dart:async';
import 'package:flutter/material.dart';
import '../constants/colors.dart';
import 'auth_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  late AnimationController _scanController;
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late AnimationController _glowController;

  int _textIndex = 0;
  final List<String> _systemTexts = [
    'The System has selected you.',
    'Your potential has been measured.',
    'The path to power awaits.',
  ];

  bool _showRank = false;
  bool _showOreuda = false;
  bool _showButton = false;

  @override
  void initState() {
    super.initState();
    _scanController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _startSequence();
  }

  void _startSequence() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _fadeController.forward();

    for (int i = 0; i < _systemTexts.length; i++) {
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        setState(() => _textIndex = i + 1);
      }
    }

    await Future.delayed(const Duration(seconds: 1));
    if (mounted) setState(() => _showRank = true);
    _scaleController.forward();

    await Future.delayed(const Duration(seconds: 1));
    if (mounted) setState(() => _showOreuda = true);

    await Future.delayed(const Duration(seconds: 1));
    if (mounted) setState(() => _showButton = true);
  }

  @override
  void dispose() {
    _scanController.dispose();
    _fadeController.dispose();
    _scaleController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: Stack(
        children: [
          // Scan rings
          Center(
            child: AnimatedBuilder(
              animation: _scanController,
              builder: (context, child) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    for (int i = 0; i < 3; i++)
                      Container(
                        width: 120 + i * 40.0,
                        height: 120 + i * 40.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.holoCyan.withAlpha(
                              ((0.3 - (i * 0.1) + (_scanController.value * 0.2)) * 255).round(),
                            ),
                            width: 1,
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),

          // Silhouette
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 60),
                Container(
                  width: 70,
                  height: 100,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.holoCyan.withAlpha((0.3 * 255).round()),
                        Colors.transparent,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(35),
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // Typewriter text
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  child: Text(
                    _textIndex < _systemTexts.length
                        ? _systemTexts[_textIndex]
                        : '',
                    key: ValueKey(_textIndex),
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.systemSilver,
                      letterSpacing: 0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: 30),

                // Rank badge
                AnimatedOpacity(
                  opacity: _showRank ? 1 : 0,
                  duration: const Duration(milliseconds: 600),
                  child: ScaleTransition(
                    scale: _scaleController,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.hpCrimson.withAlpha((0.15 * 255).round()),
                        border: Border.all(
                          color: AppColors.hpCrimson.withAlpha((0.5 * 255).round()),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'E-RANK',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          color: AppColors.hpCrimson,
                          letterSpacing: 6,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // OREUDA text
                AnimatedOpacity(
                  opacity: _showOreuda ? 1 : 0,
                  duration: const Duration(milliseconds: 800),
                  child: AnimatedBuilder(
                    animation: _glowController,
                    builder: (context, child) {
                      return Text(
                        'OREUDA',
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.w900,
                          color: AppColors.holoCyan,
                          letterSpacing: 10,
                          shadows: [
                            Shadow(
                              color: AppColors.holoCyan.withAlpha(
                                ((0.3 + _glowController.value * 0.4) * 255).round(),
                              ),
                              blurRadius: 20 + _glowController.value * 20,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 60),

                // Enter button
                AnimatedOpacity(
                  opacity: _showButton ? 1 : 0,
                  duration: const Duration(milliseconds: 600),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => const AuthScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.holoCyan,
                      foregroundColor: AppColors.black,
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'ENTER THE SYSTEM',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 2,
                      ),
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
