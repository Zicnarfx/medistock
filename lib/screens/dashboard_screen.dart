
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../app_colors.dart';
import '../models/medicine.dart';
import '../services/medicine_services.dart';

import 'login_screen.dart';
import 'medicine_list_screen.dart';
import 'reports_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  Future<void> _showLogoutDialog(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: darkGreen,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Row(
          children: [
            Icon(
              Icons.logout_rounded,
              color: lightGreen,
              size: 27,
            ),
            SizedBox(width: 10),
            Text(
              'Logout',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: const Text(
          'Are you sure you want to logout from your account?',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 14,
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: lightGreen,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryGreen,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text(
              'Logout',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await FirebaseAuth.instance.signOut();

      if (!context.mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        ),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final MedicineService service = MedicineService();

    return Scaffold(
      backgroundColor: backgroundGreen,

      // APP BAR
      appBar: AppBar(
        backgroundColor: darkGreen,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Row(
          children: [
            Icon(Icons.medication_rounded, size: 28),
            SizedBox(width: 10),
            Text(
              'MediStock',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            tooltip: 'Logout',
            onPressed: () => _showLogoutDialog(context),
          ),
          const SizedBox(width: 8),
        ],
      ),

      // DASHBOARD CONTENT
      body: StreamBuilder<List<Medicine>>(
        stream: service.getMedicines(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: primaryGreen,
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'Error loading medicines: ${snapshot.error}',
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            );
          }

          final medicines = snapshot.data ?? [];

          // RESPONSIVE SCREEN SETTINGS
          final isLandscape =
              MediaQuery.of(context).orientation ==
                  Orientation.landscape;

          final screenWidth = MediaQuery.of(context).size.width;

          final crossAxisCount = isLandscape ? 4 : 2;

          // INVENTORY STATISTICS
          final totalMedicines = medicines.length;

          final availableStock = medicines.fold<int>(
            0,
            (sum, medicine) => sum + medicine.quantity,
          );

          final lowStock = medicines.where(
            (medicine) => medicine.quantity <= 10,
          ).length;

          final expired = medicines.where(
            (medicine) => medicine.expirationDate.isBefore(
              DateTime.now(),
            ),
          ).length;

          final recentMedicines = medicines.take(5).toList();

          return ListView(
            padding: EdgeInsets.symmetric(
              horizontal: isLandscape ? 32 : 20,
              vertical: 20,
            ),
            children: [
              // WELCOME BANNER
              Container(
                padding: EdgeInsets.all(isLandscape ? 30 : 24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      darkGreen,
                      appBarGreen,
                      primaryGreen,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: darkGreen.withValues(alpha: 0.2),
                      blurRadius: 15,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.inventory_2_rounded,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'Welcome to MediStock!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Manage your medicine inventory easily '
                      'and keep track of your stocks.',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 9,
                      ),
                      decoration: BoxDecoration(
                        color: lightGreen,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        'INVENTORY MANAGEMENT',
                        style: TextStyle(
                          color: darkGreen,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // INVENTORY OVERVIEW
              const Row(
                children: [
                  Icon(
                    Icons.analytics_rounded,
                    color: darkGreen,
                    size: 25,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Inventory Overview',
                    style: TextStyle(
                      color: darkGreen,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 15),

              // RESPONSIVE STATISTICS GRID
              GridView.count(
                crossAxisCount: crossAxisCount,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: isLandscape ? 1.15 : 1.0,
                children: [
                  _StatCard(
                    title: 'Medicines',
                    value: totalMedicines.toString(),
                    icon: Icons.medication_rounded,
                    color: primaryGreen,
                  ),
                  _StatCard(
                    title: 'Total Stock',
                    value: availableStock.toString(),
                    icon: Icons.inventory_2_rounded,
                    color: appBarGreen,
                  ),
                  _StatCard(
                    title: 'Low Stock',
                    value: lowStock.toString(),
                    icon: Icons.warning_amber_rounded,
                    color: const Color(0xFFD97706),
                  ),
                  _StatCard(
                    title: 'Expired',
                    value: expired.toString(),
                    icon: Icons.event_busy_rounded,
                    color: const Color(0xFFDC2626),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // RECENT MEDICINES HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.history_rounded,
                        color: darkGreen,
                        size: 25,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Recent Medicines',
                        style: TextStyle(
                          color: darkGreen,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const MedicineListScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'View All',
                      style: TextStyle(
                        color: primaryGreen,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // RECENT MEDICINES LIST
              if (recentMedicines.isEmpty)
                Container(
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Column(
                    children: [
                      Icon(
                        Icons.medication_outlined,
                        color: lightGreen,
                        size: 45,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'No medicines available yet.',
                        style: TextStyle(
                          color: darkGreen,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                )
              else
                ...recentMedicines.map((medicine) {
                  final isExpired =
                      medicine.expirationDate.isBefore(
                    DateTime.now(),
                  );

                  return _HoverMedicineCard(
                    medicine: medicine,
                    isExpired: isExpired,
                  );
                }),

              const SizedBox(height: 20),

              // MANAGE MEDICINES BUTTON
              _HoverActionButton(
                label: 'Manage Medicines',
                icon: Icons.medication_rounded,
                filled: true,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const MedicineListScreen(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 12),

              // REPORTS BUTTON
              _HoverActionButton(
                label: 'Inventory Reports',
                icon: Icons.analytics_rounded,
                filled: false,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ReportsScreen(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 25),
            ],
          );
        },
      ),
    );
  }
}

// STATISTICS CARD WITH HOVER ANIMATION
class _StatCard extends StatefulWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  State<_StatCard> createState() => _StatCardState();
}

class _StatCardState extends State<_StatCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        transform: Matrix4.translationValues(
          0,
          isHovered ? -6 : 0,
          0,
        ),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(17),
          border: Border.all(
            color: isHovered
                ? primaryGreen
                : lightGreen.withValues(alpha: 0.4),
            width: isHovered ? 1.8 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: darkGreen.withValues(
                alpha: isHovered ? 0.16 : 0.05,
              ),
              blurRadius: isHovered ? 18 : 12,
              offset: Offset(0, isHovered ? 8 : 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: widget.color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                widget.icon,
                color: widget.color,
                size: 27,
              ),
            ),
            const SizedBox(height: 15),
            Text(
              widget.value,
              style: const TextStyle(
                color: darkGreen,
                fontSize: 27,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              widget.title,
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// RECENT MEDICINE CARD WITH HOVER ANIMATION
class _HoverMedicineCard extends StatefulWidget {
  final Medicine medicine;
  final bool isExpired;

  const _HoverMedicineCard({
    required this.medicine,
    required this.isExpired,
  });

  @override
  State<_HoverMedicineCard> createState() =>
      _HoverMedicineCardState();
}

class _HoverMedicineCardState
    extends State<_HoverMedicineCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final medicine = widget.medicine;

    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        transform: Matrix4.translationValues(
          0,
          isHovered ? -4 : 0,
          0,
        ),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isHovered
                ? primaryGreen
                : lightGreen.withValues(alpha: 0.4),
            width: isHovered ? 1.8 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: darkGreen.withValues(
                alpha: isHovered ? 0.12 : 0,
              ),
              blurRadius: isHovered ? 12 : 0,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          leading: Container(
            padding: const EdgeInsets.all(11),
            decoration: BoxDecoration(
              color: backgroundGreen,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.medication_rounded,
              color: primaryGreen,
              size: 27,
            ),
          ),
          title: Text(
            medicine.name,
            style: const TextStyle(
              color: darkGreen,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Text(
              medicine.category,
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 12,
              ),
            ),
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Qty: ${medicine.quantity}',
                style: const TextStyle(
                  color: darkGreen,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                widget.isExpired
                    ? 'Expired'
                    : medicine.quantity <= 10
                        ? 'Low Stock'
                        : 'Available',
                style: TextStyle(
                  color: widget.isExpired
                      ? Colors.red
                      : medicine.quantity <= 10
                          ? Colors.orange
                          : primaryGreen,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ACTION BUTTONS WITH HOVER ANIMATION
class _HoverActionButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final bool filled;
  final VoidCallback onPressed;

  const _HoverActionButton({
    required this.label,
    required this.icon,
    required this.filled,
    required this.onPressed,
  });

  @override
  State<_HoverActionButton> createState() =>
      _HoverActionButtonState();
}

class _HoverActionButtonState
    extends State<_HoverActionButton> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = widget.filled
        ? (isHovered ? primaryGreen : darkGreen)
        : (isHovered ? primaryGreen : Colors.transparent);

    final foregroundColor = widget.filled
        ? Colors.white
        : (isHovered ? Colors.white : darkGreen);

    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        transform: Matrix4.translationValues(
          0,
          isHovered ? -3 : 0,
          0,
        ),
        height: 55,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: primaryGreen,
            width: 1.5,
          ),
          boxShadow: [
            if (isHovered)
              BoxShadow(
                color: primaryGreen.withValues(alpha: 0.2),
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: widget.onPressed,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(widget.icon, color: foregroundColor),
                const SizedBox(width: 10),
                Text(
                  widget.label,
                  style: TextStyle(
                    color: foregroundColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
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
