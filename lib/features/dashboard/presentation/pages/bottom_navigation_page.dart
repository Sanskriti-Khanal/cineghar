import 'package:flutter/material.dart';
import 'package:cineghar/features/dashboard/presentation/pages/home_page.dart';
import 'package:cineghar/features/dashboard/presentation/pages/sales_page.dart';
import 'package:cineghar/features/dashboard/presentation/pages/loyalty_page.dart';
import 'package:cineghar/features/dashboard/presentation/pages/profile_page.dart';

class BottomNavigationPage extends StatefulWidget {
  const BottomNavigationPage({super.key});

  @override
  State<BottomNavigationPage> createState() => _BottomNavigationPageState();
}

class _BottomNavigationPageState extends State<BottomNavigationPage> {
  int _selectedIndex = 0;

  final List<Widget> _bottomScreens = [
    const HomePage(),
    const SalesPage(),
    const LoyaltyPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final mediaQuery = MediaQuery.of(context);
    final bottomInset = mediaQuery.viewPadding.bottom;

    return Scaffold(
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
          height: 67, 
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _NavItem(
                icon: Icons.home_outlined,
                activeIcon: Icons.home,
                label: 'Home',
                isActive: _selectedIndex == 0,
                activeColor: primaryColor,
                onTap: () => _onNavTap(0),
              ),
              _NavItem(
                icon: Icons.percent_outlined,
                activeIcon: Icons.percent,
                label: 'Sale',
                isActive: _selectedIndex == 1,
                activeColor: primaryColor,
                onTap: () => _onNavTap(1),
              ),
              _NavItem(
                icon: Icons.local_offer_outlined,
                activeIcon: Icons.local_offer,
                label: 'Loyalty',
                isActive: _selectedIndex == 2,
                activeColor: primaryColor,
                onTap: () => _onNavTap(2),
              ),
              _NavItem(
                icon: Icons.person_outline,
                activeIcon: Icons.person,
                label: 'Profile',
                isActive: _selectedIndex == 3,
                activeColor: primaryColor,
                onTap: () => _onNavTap(3),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onNavTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isActive;
  final Color activeColor;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isActive,
    required this.activeColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color inactiveColor = const Color(0xFF4A4A4A);

    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive ? activeIcon : icon,
              size: 20,
              color: isActive ? activeColor : inactiveColor,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                color: isActive ? activeColor : inactiveColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

