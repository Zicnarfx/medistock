
import 'package:flutter/material.dart';
import '../app_colors.dart';
import '../models/medicine.dart';

class MedicineCard extends StatefulWidget {
  final Medicine medicine;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const MedicineCard({
    super.key,
    required this.medicine,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  State<MedicineCard> createState() => _MedicineCardState();
}

class _MedicineCardState extends State<MedicineCard> {
  bool isHovered = false;

  bool get isExpired =>
      widget.medicine.expirationDate.isBefore(DateTime.now());

  bool get isLowStock => widget.medicine.quantity <= 10;

  Color get statusColor {
    if (isExpired) return Colors.redAccent;
    if (isLowStock) return Colors.orangeAccent;
    return lightGreen;
  }

  String get statusText {
    if (isExpired) return 'Expired';
    if (isLowStock) return 'Low Stock';
    return 'Available';
  }

  @override
  Widget build(BuildContext context) {
    final medicine = widget.medicine;

    return MouseRegion(
      onEnter: (_) {
        setState(() => isHovered = true);
      },
      onExit: (_) {
        setState(() => isHovered = false);
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
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: primaryGreen.withValues(
                alpha: isHovered ? 0.25 : 0.10,
              ),
              blurRadius: isHovered ? 18 : 10,
              offset: Offset(0, isHovered ? 8 : 4),
            ),
          ],
        ),
        child: Card(
          color: cardGreen,
          elevation: 0,
          margin: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 7,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: BorderSide(
              color: primaryGreen.withValues(
                alpha: isHovered ? 0.8 : 0.4,
              ),
              width: isHovered ? 1.5 : 1,
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: widget.onTap,
            splashColor: lightGreen.withValues(alpha: 0.08),
            child: Padding(
              padding: const EdgeInsets.all(17),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Medicine name and status
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          medicine.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 11,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: statusColor.withValues(alpha: 0.5),
                          ),
                        ),
                        child: Text(
                          statusText,
                          style: TextStyle(
                            color: statusColor,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 9),

                  // Category
                  Row(
                    children: [
                      const Icon(
                        Icons.category_outlined,
                        color: lightGreen,
                        size: 17,
                      ),
                      const SizedBox(width: 7),
                      Expanded(
                        child: Text(
                          medicine.category,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  Divider(
                    color: lightGreen.withValues(alpha: 0.2),
                    height: 1,
                  ),

                  const SizedBox(height: 15),

                  // Stock and price
                  Row(
                    children: [
                      const Icon(
                        Icons.inventory_2_outlined,
                        size: 19,
                        color: lightGreen,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Stock: ${medicine.quantity} ${medicine.unit}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Icon(
                        Icons.payments_outlined,
                        size: 19,
                        color: lightGreen,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '₱${medicine.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: lightGreen,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 13),

                  // Expiration date
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_month_outlined,
                        size: 18,
                        color: isExpired
                            ? Colors.redAccent
                            : lightGreen,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Expires: ${medicine.expirationDate.day}/${medicine.expirationDate.month}/${medicine.expirationDate.year}',
                          style: TextStyle(
                            fontSize: 13,
                            color: isExpired
                                ? Colors.redAccent
                                : Colors.white70,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Divider(
                    color: lightGreen.withValues(alpha: 0.2),
                    height: 1,
                  ),

                  const SizedBox(height: 5),

                  // Edit and Delete buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (widget.onEdit != null)
                        TextButton.icon(
                          onPressed: widget.onEdit,
                          icon: const Icon(
                            Icons.edit_outlined,
                            size: 18,
                          ),
                          label: const Text('Edit'),
                          style: TextButton.styleFrom(
                            foregroundColor: lightGreen,
                          ),
                        ),

                      if (widget.onDelete != null)
                        TextButton.icon(
                          onPressed: widget.onDelete,
                          icon: const Icon(
                            Icons.delete_outline,
                            size: 18,
                          ),
                          label: const Text('Delete'),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.redAccent,
                          ),
                        ),
                    ],
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
