
import 'package:flutter/material.dart';
import '../app_colors.dart';
import '../models/medicine.dart';
import '../services/medicine_services.dart';
import 'medicine_form_screen.dart';

class MedicineDetailsScreen extends StatelessWidget {
  final Medicine medicine;

  const MedicineDetailsScreen({
    super.key,
    required this.medicine,
  });

  @override
  Widget build(BuildContext context) {
    final expired =
        medicine.expirationDate.isBefore(DateTime.now());

    final lowStock = medicine.quantity <= 10;

    final status = expired
        ? 'Expired'
        : lowStock
            ? 'Low Stock'
            : 'Available';

    final statusColor = expired
        ? Colors.redAccent
        : lowStock
            ? Colors.orangeAccent
            : lightGreen;

    return Scaffold(
      backgroundColor: backgroundGreen,
      appBar: AppBar(
        backgroundColor: appBarGreen,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Medicine Details',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Edit Medicine',
            onPressed: () => openEditScreen(context),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          // Medicine Header
          Container(
            padding: const EdgeInsets.all(25),
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
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: lightGreen.withValues(alpha: 0.5),
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.medication_outlined,
                    color: lightGreen,
                    size: 45,
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  medicine.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  medicine.dosage,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 18),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: statusColor),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 25),

          const Text(
            'Medicine Information',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: darkGreen,
            ),
          ),

          const SizedBox(height: 14),

          detailCard(
            icon: Icons.category_outlined,
            title: 'Category',
            value: medicine.category,
          ),

          detailCard(
            icon: Icons.inventory_2_outlined,
            title: 'Quantity',
            value: '${medicine.quantity} ${medicine.unit}',
          ),

          detailCard(
            icon: Icons.payments_outlined,
            title: 'Price',
            value: '₱${medicine.price.toStringAsFixed(2)}',
          ),

          detailCard(
            icon: Icons.calendar_month_outlined,
            title: 'Expiration Date',
            value: '${medicine.expirationDate.day}/'
                '${medicine.expirationDate.month}/'
                '${medicine.expirationDate.year}',
            valueColor: expired ? Colors.redAccent : lightGreen,
          ),

          detailCard(
            icon: Icons.business_outlined,
            title: 'Supplier',
            value: medicine.supplier.isEmpty
                ? 'Not specified'
                : medicine.supplier,
          ),

          detailCard(
            icon: Icons.description_outlined,
            title: 'Description',
            value: medicine.description.isEmpty
                ? 'No description'
                : medicine.description,
          ),

          const SizedBox(height: 22),

          // Edit Button
          SizedBox(
            height: 54,
            child: ElevatedButton.icon(
              onPressed: () => openEditScreen(context),
              icon: const Icon(Icons.edit_outlined),
              label: const Text(
                'Edit Medicine',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryGreen,
                foregroundColor: Colors.white,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Delete Button
          SizedBox(
            height: 54,
            child: ElevatedButton.icon(
              onPressed: () => deleteMedicine(context),
              icon: const Icon(Icons.delete_outline),
              label: const Text(
                'Delete Medicine',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: darkGreen,
                foregroundColor: lightGreen,
                elevation: 3,
                side: const BorderSide(
                  color: primaryGreen,
                  width: 1.5,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // Open Edit Screen
  void openEditScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MedicineFormScreen(
          medicine: medicine,
        ),
      ),
    );
  }

  // Medicine Information Card
  // Uses Row and Column instead of ListTile.
  Widget detailCard({
    required IconData icon,
    required String title,
    required String value,
    Color? valueColor,
  }) {
    return Card(
      color: darkGreen,
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 11),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(
          color: primaryGreen.withValues(alpha: 0.3),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: primaryGreen.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: lightGreen,
                size: 23,
              ),
            ),

            const SizedBox(width: 15),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    value,
                    style: TextStyle(
                      color: valueColor ?? Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Delete Medicine
  Future<void> deleteMedicine(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: darkGreen,
        elevation: 12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
          side: BorderSide(
            color: primaryGreen.withValues(alpha: 0.6),
            width: 1.5,
          ),
        ),
        icon: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: primaryGreen.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.delete_outline_rounded,
            color: lightGreen,
            size: 38,
          ),
        ),
        title: const Text(
          'Delete Medicine?',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 21,
          ),
        ),
        content: Text(
          'Are you sure you want to delete ${medicine.name}? '
          'This action cannot be undone.',
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
            height: 1.5,
          ),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        actions: [
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: lightGreen,
              side: const BorderSide(color: primaryGreen),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () =>
                Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          const SizedBox(width: 8),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryGreen,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () =>
                Navigator.pop(dialogContext, true),
            icon: const Icon(Icons.delete_outline, size: 18),
            label: const Text(
              'Delete',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      await MedicineService().deleteMedicine(medicine.id);

      if (!context.mounted) return;

      // Success Popup
      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) => AlertDialog(
          backgroundColor: darkGreen,
          elevation: 12,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
            side: BorderSide(
              color: primaryGreen.withValues(alpha: 0.6),
              width: 1.5,
            ),
          ),
          icon: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: primaryGreen.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle_outline_rounded,
              color: lightGreen,
              size: 45,
            ),
          ),
          title: const Text(
            'Successfully Deleted!',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          content: const Text(
            'The medicine has been successfully removed from your inventory.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
              height: 1.5,
            ),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          actions: [
            SizedBox(
              width: 120,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryGreen,
                  foregroundColor: Colors.white,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () =>
                    Navigator.pop(dialogContext),
                child: const Text(
                  'OK',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      );

      if (context.mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (!context.mounted) return;

      // Error Popup
      await showDialog<void>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          backgroundColor: darkGreen,
          elevation: 12,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
            side: const BorderSide(
              color: Colors.redAccent,
              width: 1.5,
            ),
          ),
          icon: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.redAccent.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.error_outline_rounded,
              color: Colors.redAccent,
              size: 45,
            ),
          ),
          title: const Text(
            'Delete Failed',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          content: const Text(
            'Unable to delete the medicine. Please check your connection and try again.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
              height: 1.5,
            ),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          actions: [
            SizedBox(
              width: 120,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryGreen,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () =>
                    Navigator.pop(dialogContext),
                child: const Text('OK'),
              ),
            ),
          ],
        ),
      );
    }
  }
}
