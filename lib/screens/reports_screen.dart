
import 'package:flutter/material.dart';

import '../app_colors.dart';
import '../models/medicine.dart';
import '../services/medicine_services.dart';

class ReportsScreen extends StatelessWidget {
  ReportsScreen({super.key});

  final MedicineService service = MedicineService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundGreen,
      appBar: AppBar(
        backgroundColor: appBarGreen,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Inventory Reports',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: StreamBuilder<List<Medicine>>(
        stream: service.getMedicines(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text(
                'Error loading reports.',
                style: TextStyle(color: Colors.red),
              ),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(
                color: primaryGreen,
              ),
            );
          }

          final medicines = snapshot.data!;
          final now = DateTime.now();
          final soon = now.add(const Duration(days: 30));

          // Inventory Calculations
          final totalStock = medicines.fold<int>(
            0,
            (sum, m) => sum + m.quantity,
          );

          final totalValue = medicines.fold<double>(
            0,
            (sum, m) => sum + (m.quantity * m.price),
          );

          final lowStock = medicines
              .where((m) => m.quantity <= 10)
              .toList();

          final expired = medicines
              .where((m) => m.expirationDate.isBefore(now))
              .toList();

          final expiringSoon = medicines
              .where(
                (m) =>
                    !m.expirationDate.isBefore(now) &&
                    !m.expirationDate.isAfter(soon),
              )
              .toList();

          final Map<String, int> categories = {};

          for (final medicine in medicines) {
            categories[medicine.category] =
                (categories[medicine.category] ?? 0) + 1;
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Report Header
              Container(
                padding: const EdgeInsets.all(23),
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
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: darkGreen.withValues(alpha: 0.2),
                      blurRadius: 12,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.analytics_outlined,
                      color: lightGreen,
                      size: 45,
                    ),
                    SizedBox(height: 14),
                    Text(
                      'Inventory Summary',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Monitor your medicine inventory.',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Inventory Statistics
              const Text(
                'Inventory Overview',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: darkGreen,
                ),
              ),

              const SizedBox(height: 13),

              reportCard(
                title: 'Total Inventory Value',
                value: '₱${totalValue.toStringAsFixed(2)}',
                icon: Icons.payments_outlined,
              ),

              reportCard(
                title: 'Total Stock Quantity',
                value: '$totalStock units',
                icon: Icons.inventory_2_outlined,
              ),

              reportCard(
                title: 'Total Medicine Types',
                value: '${medicines.length}',
                icon: Icons.medication_outlined,
              ),

              const SizedBox(height: 25),

              // Stock Alerts
              const Text(
                'Stock Alerts',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: darkGreen,
                ),
              ),

              const SizedBox(height: 13),

              alertCard(
                title: 'Low Stock',
                count: lowStock.length,
                color: Colors.orangeAccent,
                icon: Icons.warning_amber_rounded,
              ),

              alertCard(
                title: 'Expired Medicines',
                count: expired.length,
                color: Colors.redAccent,
                icon: Icons.event_busy_outlined,
              ),

              alertCard(
                title: 'Expiring Within 30 Days',
                count: expiringSoon.length,
                color: Colors.deepOrangeAccent,
                icon: Icons.calendar_month_outlined,
              ),

              const SizedBox(height: 25),

              // Category Summary
              const Text(
                'Category Summary',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: darkGreen,
                ),
              ),

              const SizedBox(height: 13),

              if (categories.isEmpty)
                Card(
                  color: darkGreen,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      'No categories available.',
                      style: TextStyle(color: Colors.white70),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),

              ...categories.entries.map(
                (entry) => Card(
                  color: darkGreen,
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                    side: BorderSide(
                      color: primaryGreen.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(15),
                    clipBehavior: Clip.antiAlias,
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 5,
                      ),
                      leading: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: primaryGreen.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.category_outlined,
                          color: lightGreen,
                        ),
                      ),
                      title: Text(
                        entry.key,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      trailing: Text(
                        '${entry.value} medicines',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: lightGreen,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Note
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: primaryGreen.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: primaryGreen.withValues(alpha: 0.3),
                  ),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: primaryGreen,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Note: Inventory value is calculated using '
                        'quantity multiplied by unit price.',
                        style: TextStyle(
                          color: darkGreen,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
            ],
          );
        },
      ),
    );
  }

  // Inventory Report Card
  Widget reportCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Card(
      color: darkGreen,
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: primaryGreen.withValues(alpha: 0.3),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: ListTile(
          contentPadding: const EdgeInsets.all(16),
          leading: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: primaryGreen.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(
              icon,
              color: lightGreen,
              size: 26,
            ),
          ),
          title: Text(
            title,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 13,
            ),
          ),
          subtitle: Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: lightGreen,
            ),
          ),
        ),
      ),
    );
  }

  // Stock Alert Card
  Widget alertCard({
    required String title,
    required int count,
    required Color color,
    required IconData icon,
  }) {
    return Card(
      color: darkGreen,
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(
          color: color.withValues(alpha: 0.25),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(15),
        clipBehavior: Clip.antiAlias,
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 5,
          ),
          leading: Icon(
            icon,
            color: color,
            size: 28,
          ),
          title: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          trailing: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '$count',
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
