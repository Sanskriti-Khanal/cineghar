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
  int _selectedindex = 0;

  List<Widget> lstBottomScreen = [
    const HomeScreen(),
    const SalesScreen(),
    const LoyaltyScreen(),
    const ProfileScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard"),
        backgroundColor: const Color.fromARGB(255, 90, 32, 28),
      ),
              body:lstBottomScreen[_selectedindex],
              bottomNavigationBar: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                items: const[
                  BottomNavigationBarItem(icon: Icon(Icons.home),label: "Home"),
                  BottomNavigationBarItem(icon: Icon(Icons.shop),label: "Sales"),
                  BottomNavigationBarItem(icon: Icon(Icons.loyalty),label: "Loyalty"),
                  BottomNavigationBarItem(icon: Icon(Icons.person),label: "Profile"),
                ]),
    );
  }
}
