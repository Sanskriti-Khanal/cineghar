import 'package:cineghar/screens/bottom_screen/home_screen.dart';
import 'package:cineghar/screens/bottom_screen/loyalty_screen.dart';
import 'package:cineghar/screens/bottom_screen/profile_screen.dart';
import 'package:cineghar/screens/bottom_screen/sales_screen.dart';
import 'package:flutter/material.dart';

class BottomNavigationScreen extends StatefulWidget {
  const BottomNavigationScreen({super.key});

  @override
  State<BottomNavigationScreen> createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen> {
  int _selectedIndex = 0;

  final List<Widget> _bottomScreens = [
    const HomeScreen(),
    const SalesScreen(),
    const LoyaltyScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final mediaQuery = MediaQuery.of(context);
    final bottomInset = mediaQuery.viewPadding.bottom;

    return Scaffold(
      appBar: AppBar(title: const Text("Dashboard")),
      body: _bottomScreens[_selectedIndex],
      backgroundColor: Colors.white,
      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(
          16,
          0,
          16,
          (bottomInset > 0 ? bottomInset : 8) + 4,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(24),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                backgroundColor: Colors.transparent,
                elevation: 0,
                selectedItemColor: primaryColor,
                unselectedItemColor: Colors.grey[700],
                selectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 11,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 11,
                ),
                iconSize: 22,
                currentIndex: _selectedIndex,
                onTap: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home_outlined),
                    activeIcon: Icon(Icons.home),
                    label: "Home",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.percent_outlined),
                    activeIcon: Icon(Icons.percent),
                    label: "Sale",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.local_offer_outlined),
                    activeIcon: Icon(Icons.local_offer),
                    label: "Loyalty",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person_outline),
                    activeIcon: Icon(Icons.person),
                    label: "Profile",
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
