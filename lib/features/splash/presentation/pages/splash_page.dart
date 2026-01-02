import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cineghar/features/onboarding/presentation/pages/onboarding_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  final String _title = 'CineGhar';
  int _visibleChars = 0;
  Timer? _typingTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _controller.forward();

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _startTyping();
      }
    });

    Timer(const Duration(seconds: 3), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => const OnboardingPage(),
        ),
      );
    });
  }

  @override
  void dispose() {
    _typingTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;
    final logoSize = isTablet ? 130.0 : 90.0;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/background.png',
            fit: BoxFit.cover,
          ),
          Container(
            color: Colors.black.withOpacity(0.6),
          ),
          Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/logo.png',
                        width: logoSize,
                        height: logoSize,
                      ),
                      const SizedBox(width: 12),
                      SizedBox(
                        height: logoSize,
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            _title.substring(0, _visibleChars),
                            style: TextStyle(
                              fontSize: isTablet ? 48 : 34,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(0.8),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _startTyping() {
    _typingTimer?.cancel();
    _visibleChars = 0;

    _typingTimer = Timer.periodic(const Duration(milliseconds: 120), (timer) {
      if (_visibleChars >= _title.length) {
        timer.cancel();
        return;
      }
      setState(() {
        _visibleChars++;
      });
    });
  }
}

