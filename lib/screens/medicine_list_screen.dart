
import 'package:flutter/material.dart';
import '../app_colors.dart';
import '../models/medicine.dart';
import '../services/medicine_services.dart';
import '../widgets/medicine_card.dart';
import 'medicine_details_screen.dart';
import 'medicine_form_screen.dart';

class MedicineListScreen extends StatefulWidget {
  const MedicineListScreen({super.key});

  @override
  State<MedicineListScreen> createState() =>
      _MedicineListScreenState();
}

class _MedicineListScreenState extends State<MedicineListScreen> {
  final MedicineService service = MedicineService();

  final TextEditingController searchController =
      TextEditingController();

  String searchQuery = '';

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void openAddMedicine() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MedicineFormScreen(),
      ),
    );
  }

  void openMedicineDetails(Medicine medicine) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MedicineDetailsScreen(
          medicine: medicine,
        ),
      ),
    );
  }

  void openEditMedicine(Medicine medicine) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MedicineFormScreen(
          medicine: medicine,
        ),
      ),
    );
  }

  // Themed popup dialog
  Future<void> showMessageDialog({
    required String title,
    required String message,
    required IconData icon,
    required Color iconColor,
  }) async {
    await showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: darkGreen,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          icon: Icon(
            icon,
            color: iconColor,
            size: 55,
          ),
          title: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryGreen,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteMedicine(Medicine medicine) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: darkGreen,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          icon: const Icon(
            Icons.delete_outline,
            color: Colors.redAccent,
            size: 50,
          ),
          title: const Text(
            'Delete Medicine?',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Are you sure you want to delete ${medicine.name}?',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white70,
            ),
          ),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: lightGreen),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirm != true) return;

    try {
      await service.deleteMedicine(medicine.id);

      if (!mounted) return;

      await showMessageDialog(
        title: 'Deleted Successfully!',
        message: '${medicine.name} has been deleted.',
        icon: Icons.check_circle_outline,
        iconColor: lightGreen,
      );
    } catch (e) {
      if (!mounted) return;

      await showMessageDialog(
        title: 'Delete Failed',
        message: 'Unable to delete medicine. Please try again.\n$e',
        icon: Icons.error_outline,
        iconColor: Colors.redAccent,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    final horizontalPadding = screenWidth >= 900
        ? 32.0
        : screenWidth >= 600
            ? 24.0
            : 16.0;

    return Scaffold(
      backgroundColor: backgroundGreen,

      appBar: AppBar(
        backgroundColor: darkGreen,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Row(
          children: [
            Icon(
              Icons.medication,
              color: lightGreen,
            ),
            SizedBox(width: 10),
            Text(
              'Medicines',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),

      body: Column(
        children: [
          // Search field
          Padding(
            padding: EdgeInsets.fromLTRB(
              horizontalPadding,
              20,
              horizontalPadding,
              12,
            ),
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase().trim();
                });
              },
              decoration: InputDecoration(
                hintText: 'Search medicine or category...',
                hintStyle: const TextStyle(
                  color: Colors.white60,
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  color: lightGreen,
                ),
                suffixIcon: searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(
                          Icons.clear,
                          color: lightGreen,
                        ),
                        onPressed: () {
                          searchController.clear();
                          setState(() {
                            searchQuery = '';
                          });
                        },
                      )
                    : null,
                filled: true,
                fillColor: darkGreen,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 18,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(
                    color: primaryGreen.withValues(alpha: 0.5),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(
                    color: lightGreen,
                    width: 2,
                  ),
                ),
              ),
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),

          // Medicine list
          Expanded(
            child: StreamBuilder<List<Medicine>>(
              stream: service.getMedicines(),
              builder: (context, snapshot) {
                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
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
                        'Error loading medicines:\n${snapshot.error}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    ),
                  );
                }

                final medicines = snapshot.data ?? [];

                final filteredMedicines =
                    medicines.where((medicine) {
                  return medicine.name
                          .toLowerCase()
                          .contains(searchQuery) ||
                      medicine.category
                          .toLowerCase()
                          .contains(searchQuery);
                }).toList();

                if (filteredMedicines.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.medication_outlined,
                          size: 75,
                          color: darkGreen.withValues(alpha: 0.35),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          searchQuery.isEmpty
                              ? 'No medicines available'
                              : 'No medicines found',
                          style: const TextStyle(
                            color: darkGreen,
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Add a medicine to get started.',
                          style: TextStyle(
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                // Responsive layout:
                // Desktop: grid
                // Mobile: list
                final useGrid = screenWidth >= 700;

                if (useGrid) {
                  final crossAxisCount = screenWidth >= 1100
                      ? 3
                      : 2;

                  return GridView.builder(
                    padding: EdgeInsets.fromLTRB(
                      horizontalPadding,
                      8,
                      horizontalPadding,
                      100,
                    ),
                    itemCount: filteredMedicines.length,
                    gridDelegate:
                        SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio:
                          isLandscape ? 1.8 : 1.35,
                    ),
                    itemBuilder: (context, index) {
                      final medicine =
                          filteredMedicines[index];

                      return _HoverMedicineItem(
                        child: MedicineCard(
                          medicine: medicine,
                          onTap: () {
                            openMedicineDetails(medicine);
                          },
                          onEdit: () {
                            openEditMedicine(medicine);
                          },
                          onDelete: () {
                            deleteMedicine(medicine);
                          },
                        ),
                      );
                    },
                  );
                }

                return ListView.builder(
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    8,
                    horizontalPadding,
                    100,
                  ),
                  itemCount: filteredMedicines.length,
                  itemBuilder: (context, index) {
                    final medicine = filteredMedicines[index];

                    return _HoverMedicineItem(
                      child: MedicineCard(
                        medicine: medicine,
                        onTap: () {
                          openMedicineDetails(medicine);
                        },
                        onEdit: () {
                          openEditMedicine(medicine);
                        },
                        onDelete: () {
                          deleteMedicine(medicine);
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: openAddMedicine,
        backgroundColor: primaryGreen,
        foregroundColor: Colors.white,
        elevation: 5,
        icon: const Icon(Icons.add),
        label: const Text(
          'Add Medicine',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

// Hover animation for desktop and web
class _HoverMedicineItem extends StatefulWidget {
  final Widget child;

  const _HoverMedicineItem({
    required this.child,
  });

  @override
  State<_HoverMedicineItem> createState() =>
      _HoverMedicineItemState();
}

class _HoverMedicineItemState
    extends State<_HoverMedicineItem> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          isHovered = true;
        });
      },
      onExit: (_) {
        setState(() {
          isHovered = false;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        transform: Matrix4.translationValues(
          0,
          isHovered ? -4 : 0,
          0,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: isHovered
              ? [
                  BoxShadow(
                    color: primaryGreen.withValues(alpha: 0.2),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ]
              : [],
        ),
        child: widget.child,
      ),
    );
  }
}
