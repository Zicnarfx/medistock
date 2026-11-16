
import 'package:flutter/material.dart';

import '../app_colors.dart';
import 'dashboard_screen.dart';
import 'medicine_list_screen.dart';
import 'reports_screen.dart';
import 'account_settings_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() =>
      _MainNavigationScreenState();
}

class _MainNavigationScreenState
    extends State<MainNavigationScreen> {

  int selectedIndex = 0;

  final List<Widget> screens = [
    const DashboardScreen(),
    const MedicineListScreen(),
    ReportsScreen(),
    const AccountSettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundGreen,

      // MAIN SCREEN
      body: IndexedStack(
        index: selectedIndex,
        children: screens,
      ),

      // BOTTOM NAVIGATION BAR
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: darkGreen,
          boxShadow: [
            BoxShadow(
              color: darkGreen.withValues(alpha: 0.25),
              blurRadius: 15,
              offset: const Offset(0, -3),
            ),
          ],
          border: const Border(
            top: BorderSide(
              color: primaryGreen,
              width: 1,
            ),
          ),
        ),

        child: NavigationBarTheme(
          data: NavigationBarThemeData(
            backgroundColor: darkGreen,

            indicatorColor: primaryGreen.withValues(alpha: 0.3),

            elevation: 0,

            labelTextStyle:
                WidgetStateProperty.resolveWith<TextStyle>(
              (states) {
                if (states.contains(WidgetState.selected)) {
                  return const TextStyle(
                    color: lightGreen,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  );
                }

                return const TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                );
              },
            ),

            iconTheme:
                WidgetStateProperty.resolveWith<IconThemeData>(
              (states) {
                if (states.contains(WidgetState.selected)) {
                  return const IconThemeData(
                    color: lightGreen,
                    size: 25,
                  );
                }

                return const IconThemeData(
                  color: Colors.white70,
                  size: 23,
                );
              },
            ),
          ),

          child: NavigationBar(
            height: 72,
            selectedIndex: selectedIndex,

            onDestinationSelected: (index) {
              setState(() {
                selectedIndex = index;
              });
            },

            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.dashboard_outlined),
                selectedIcon: Icon(Icons.dashboard_rounded),
                label: 'Dashboard',
              ),

              NavigationDestination(
                icon: Icon(Icons.medication_outlined),
                selectedIcon: Icon(Icons.medication),
                label: 'Medicines',
              ),

              NavigationDestination(
                icon: Icon(Icons.analytics_outlined),
                selectedIcon: Icon(Icons.analytics),
                label: 'Reports',
              ),

              NavigationDestination(
                icon: Icon(Icons.person_outline),
                selectedIcon: Icon(Icons.person),
                label: 'Account',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
