import 'package:flutter/material.dart';
import 'package:cineghar/features/onboarding/presentation/pages/onboarding_page_three.dart';
import 'package:cineghar/features/welcome/presentation/pages/welcome_page.dart';

class OnboardingPageTwo extends StatelessWidget {
  const OnboardingPageTwo({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;
    final horizontalPadding = isTablet ? 48.0 : 24.0;
    final verticalPadding = isTablet ? 24.0 : 16.0;
    final titleFontSize = isTablet ? 48.0 : size.width * 0.075;
    final subtitleFontSize = isTablet ? 20.0 : size.width * 0.037;
    final buttonFontSize = isTablet ? 20.0 : size.width * 0.045;
    final skipFontSize = isTablet ? 18.0 : size.width * 0.04;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/onboarding2.png',
            fit: BoxFit.cover,
          ),
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromARGB(200, 0, 0, 0),
                  Color.fromARGB(220, 0, 0, 0),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: verticalPadding,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const WelcomePage(),
                            ),
                          );
                        },
                        child: Text(
                          'Skip',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: skipFontSize,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * 0.04),
                  Text(
                    'Book Tickets\nEffortlessly',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                  ),
                  SizedBox(height: size.height * 0.02),
                  Text(
                    'Choose seats, timings, and\ntheatres in seconds.',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.85),
                      fontSize: subtitleFontSize,
                      height: 1.4,
                    ),
                  ),
                  const Spacer(),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _PageDot(isActive: false),
                          const SizedBox(width: 8),
                          _PageDot(isActive: true),
                          const SizedBox(width: 8),
                          _PageDot(isActive: false),
                        ],
                      ),
                      SizedBox(height: size.height * 0.025),
                      SizedBox(
                        width: double.infinity,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const OnboardingPageThree(),
                              ),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              vertical: isTablet ? 18 : 16,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(40),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'Next',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: buttonFontSize,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: size.height * 0.02),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PageDot extends StatelessWidget {
  final bool isActive;

  const _PageDot({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      height: 8,
      width: isActive ? 18 : 8,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.white.withOpacity(0.4),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}

