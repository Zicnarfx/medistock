
import 'package:flutter/material.dart';

import '../app_colors.dart';
import '../models/medicine.dart';
import '../services/medicine_services.dart';

class MedicineFormScreen extends StatefulWidget {
  final Medicine? medicine;

  const MedicineFormScreen({
    super.key,
    this.medicine,
  });

  @override
  State<MedicineFormScreen> createState() =>
      _MedicineFormScreenState();
}

class _MedicineFormScreenState extends State<MedicineFormScreen> {
  final formKey = GlobalKey<FormState>();
  final MedicineService service = MedicineService();

  late TextEditingController nameController;
  late TextEditingController dosageController;
  late TextEditingController quantityController;
  late TextEditingController priceController;
  late TextEditingController supplierController;
  late TextEditingController descriptionController;

  String category = 'Antibiotic';
  String unit = 'pcs';

  DateTime expirationDate =
      DateTime.now().add(const Duration(days: 365));

  bool isSaving = false;

  bool get isEditing => widget.medicine != null;

  @override
  void initState() {
    super.initState();

    final medicine = widget.medicine;

    nameController =
        TextEditingController(text: medicine?.name ?? '');

    dosageController =
        TextEditingController(text: medicine?.dosage ?? '');

    quantityController = TextEditingController(
      text: medicine?.quantity.toString() ?? '',
    );

    priceController = TextEditingController(
      text: medicine?.price.toString() ?? '',
    );

    supplierController =
        TextEditingController(text: medicine?.supplier ?? '');

    descriptionController =
        TextEditingController(text: medicine?.description ?? '');

    if (medicine != null) {
      category = medicine.category;
      unit = medicine.unit;
      expirationDate = medicine.expirationDate;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    dosageController.dispose();
    quantityController.dispose();
    priceController.dispose();
    supplierController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

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
        title: Text(
          isEditing ? 'Edit Medicine' : 'Add Medicine',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Form(
        key: formKey,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 850,
            ),
            child: ListView(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                20,
                horizontalPadding,
                30,
              ),
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(22),
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
                        blurRadius: 12,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(13),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Icon(
                          Icons.medication,
                          color: lightGreen,
                          size: 38,
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isEditing
                                  ? 'Update Medicine'
                                  : 'Medicine Information',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            const Text(
                              'Enter the medicine details below.',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                sectionTitle(
                  'Basic Information',
                  Icons.info_outline,
                ),

                const SizedBox(height: 15),

                field(
                  controller: nameController,
                  label: 'Medicine Name',
                  icon: Icons.medication,
                  required: true,
                ),

                dropdownField(
                  label: 'Category',
                  icon: Icons.category_outlined,
                  value: category,
                  items: const [
                    'Analgesic',
                    'Antibiotic',
                    'Antihistamine',
                    'Vitamins',
                    'Skin Care',
                    'Digestive',
                    'Other',
                  ],
                  onChanged: (value) {
                    setState(() => category = value);
                  },
                ),

                field(
                  controller: dosageController,
                  label: 'Dosage (e.g. 500mg)',
                  icon: Icons.science_outlined,
                ),

                dropdownField(
                  label: 'Unit',
                  icon: Icons.inventory_2_outlined,
                  value: unit,
                  items: const [
                    'pcs',
                    'box',
                    'bottle',
                    'pack',
                    'capsule',
                  ],
                  onChanged: (value) {
                    setState(() => unit = value);
                  },
                ),

                const SizedBox(height: 12),

                sectionTitle(
                  'Stock and Pricing',
                  Icons.inventory_outlined,
                ),

                const SizedBox(height: 15),

                field(
                  controller: quantityController,
                  label: 'Quantity',
                  icon: Icons.numbers,
                  required: true,
                  number: true,
                  allowDecimal: false,
                ),

                field(
                  controller: priceController,
                  label: 'Price (₱)',
                  icon: Icons.payments_outlined,
                  number: true,
                  allowDecimal: true,
                ),

                const SizedBox(height: 10),

                sectionTitle(
                  'Expiration Information',
                  Icons.calendar_month_outlined,
                ),

                const SizedBox(height: 15),

                // Expiration Date
                Container(
                  decoration: BoxDecoration(
                    color: darkGreen,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: primaryGreen.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(14),
                    clipBehavior: Clip.antiAlias,
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 5,
                      ),
                      leading: const Icon(
                        Icons.calendar_month,
                        color: lightGreen,
                        size: 25,
                      ),
                      title: const Text(
                        'Expiration Date',
                        style: TextStyle(
                          color: lightGreen,
                          fontSize: 12,
                        ),
                      ),
                      subtitle: Text(
                        '${expirationDate.day}/'
                        '${expirationDate.month}/'
                        '${expirationDate.year}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                      trailing: const Icon(
                        Icons.edit_calendar,
                        color: lightGreen,
                      ),
                      onTap: selectExpirationDate,
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                sectionTitle(
                  'Additional Information',
                  Icons.description_outlined,
                ),

                const SizedBox(height: 15),

                field(
                  controller: supplierController,
                  label: 'Supplier',
                  icon: Icons.business_outlined,
                ),

                field(
                  controller: descriptionController,
                  label: 'Description',
                  icon: Icons.notes,
                  maxLines: 3,
                ),

                const SizedBox(height: 20),

                // Save Button
                SizedBox(
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed:
                        isSaving ? null : showConfirmationDialog,
                    icon: isSaving
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(Icons.save_outlined),
                    label: Text(
                      isSaving
                          ? 'Saving...'
                          : isEditing
                              ? 'Update Medicine'
                              : 'Save Medicine',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryGreen,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor:
                          primaryGreen.withValues(alpha: 0.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 3,
                    ),
                  ),
                ),

                const SizedBox(height: 15),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Section Heading
  Widget sectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          color: primaryGreen,
          size: 21,
        ),
        const SizedBox(width: 9),
        Text(
          title,
          style: const TextStyle(
            color: darkGreen,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  // Reusable TextField
  Widget field({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool required = false,
    bool number = false,
    bool allowDecimal = true,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: number
            ? TextInputType.numberWithOptions(
                decimal: allowDecimal,
              )
            : TextInputType.text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
        ),
        cursorColor: lightGreen,
        validator: (value) {
          final text = value?.trim() ?? '';

          if (required && text.isEmpty) {
            return 'This field is required.';
          }

          if (label == 'Quantity' && text.isNotEmpty) {
            final quantity = int.tryParse(text);

            if (quantity == null || quantity < 0) {
              return 'Enter a valid non-negative whole number.';
            }
          }

          if (label == 'Price (₱)' && text.isNotEmpty) {
            final price = double.tryParse(text);

            if (price == null ||
                !price.isFinite ||
                price < 0) {
              return 'Enter a valid non-negative price.';
            }
          }

          return null;
        },
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(
            color: lightGreen,
            fontSize: 13,
          ),
          prefixIcon: Icon(
            icon,
            color: lightGreen,
          ),
          errorStyle: const TextStyle(
            color: Colors.redAccent,
          ),
          filled: true,
          fillColor: darkGreen,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 17,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(
              color: primaryGreen.withValues(alpha: 0.5),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
              color: lightGreen,
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
              color: Colors.redAccent,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
              color: Colors.redAccent,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }

  // Reusable Dropdown
  Widget dropdownField({
    required String label,
    required IconData icon,
    required String value,
    required List<String> items,
    required ValueChanged<String> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: DropdownButtonFormField<String>(
        initialValue: value,
        dropdownColor: darkGreen,
        iconEnabledColor: lightGreen,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(
            color: lightGreen,
            fontSize: 13,
          ),
          prefixIcon: Icon(
            icon,
            color: lightGreen,
          ),
          filled: true,
          fillColor: darkGreen,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 15,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(
              color: primaryGreen.withValues(alpha: 0.5),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
              color: lightGreen,
              width: 2,
            ),
          ),
        ),
        items: items.map((item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(
              item,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          );
        }).toList(),
        onChanged: (newValue) {
          if (newValue != null) {
            onChanged(newValue);
          }
        },
      ),
    );
  }

  // Expiration Date Picker
  Future<void> selectExpirationDate() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: expirationDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: primaryGreen,
              onPrimary: Colors.white,
              surface: darkGreen,
              onSurface: Colors.white,
            ),
            dialogTheme: const DialogThemeData(
              backgroundColor: darkGreen,
            ),
          ),
          child: child!,
        );
      },
    );

    if (selected != null && mounted) {
      setState(() {
        expirationDate = selected;
      });
    }
  }

  // Confirmation Popup
  Future<void> showConfirmationDialog() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: darkGreen,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          icon: const Icon(
            Icons.help_outline_rounded,
            color: lightGreen,
            size: 55,
          ),
          title: const Text(
            'Confirm Action',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            isEditing
                ? 'Are you sure you want to update this medicine?'
                : 'Are you sure you want to add this medicine?',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
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
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: Text(
                isEditing ? 'Yes, Update' : 'Add',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed == true && mounted) {
      await saveMedicine();
    }
  }

  // Success Popup
  Future<void> showSuccessDialog(String medicineName) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: darkGreen,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          icon: Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: primaryGreen.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle_outline,
              color: lightGreen,
              size: 55,
            ),
          ),
          title: Text(
            isEditing
                ? 'Medicine Updated!'
                : 'Medicine Added!',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 21,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            isEditing
                ? '$medicineName has been updated successfully!'
                : '$medicineName has been added successfully!',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            SizedBox(
              width: 120,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryGreen,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(dialogContext);
                },
                child: const Text(
                  'OK',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // Error Popup
  Future<void> showErrorDialog(String message) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: darkGreen,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          icon: const Icon(
            Icons.error_outline,
            color: Colors.redAccent,
            size: 55,
          ),
          title: const Text(
            'Save Failed',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white70,
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

  // Save or Update Medicine
  Future<void> saveMedicine() async {
    if (isSaving) return;

    setState(() => isSaving = true);

    try {
      final medicine = Medicine(
        id: widget.medicine?.id ?? '',
        name: nameController.text.trim(),
        category: category,
        dosage: dosageController.text.trim(),
        unit: unit,
        quantity: int.parse(quantityController.text.trim()),
        price: double.tryParse(priceController.text.trim()) ?? 0,
        expirationDate: expirationDate,
        supplier: supplierController.text.trim(),
        description: descriptionController.text.trim(),
      );

      if (isEditing) {
        await service.updateMedicine(medicine);
      } else {
        await service.addMedicine(medicine);
      }

      if (!mounted) return;

      setState(() => isSaving = false);

      // Show success popup
      await showSuccessDialog(medicine.name);

      if (!mounted) return;

      // Return to Medicine List
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      setState(() => isSaving = false);

      await showErrorDialog(
        'Unable to save medicine. Please try again.\n$e',
      );
    }
  }
}
