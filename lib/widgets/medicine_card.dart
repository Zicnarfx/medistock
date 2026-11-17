
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
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),

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

            child: LayoutBuilder(
              builder: (context, constraints) {

                // Automatically adjust spacing for smaller grid cards.
                final compact = constraints.maxHeight.isFinite &&
                    constraints.maxHeight < 280;

                final padding = compact ? 10.0 : 17.0;
                final smallGap = compact ? 5.0 : 9.0;
                final sectionGap = compact ? 8.0 : 15.0;

                return Padding(
                  padding: EdgeInsets.all(padding),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,

                    children: [

                      // MEDICINE NAME AND STATUS
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              medicine.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: compact ? 15 : 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),

                          SizedBox(width: compact ? 4 : 8),

                          Flexible(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: compact ? 6 : 11,
                                vertical: compact ? 4 : 6,
                              ),
                              decoration: BoxDecoration(
                                color: statusColor.withValues(
                                  alpha: 0.15,
                                ),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: statusColor.withValues(
                                    alpha: 0.5,
                                  ),
                                ),
                              ),
                              child: Text(
                                statusText,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: statusColor,
                                  fontSize: compact ? 9 : 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: smallGap),

                      // CATEGORY
                      Row(
                        children: [
                          Icon(
                            Icons.category_outlined,
                            color: lightGreen,
                            size: compact ? 14 : 17,
                          ),
                          const SizedBox(width: 7),

                          Expanded(
                            child: Text(
                              medicine.category,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: compact ? 11 : 13,
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: sectionGap),

                      Divider(
                        color: lightGreen.withValues(alpha: 0.2),
                        height: 1,
                      ),

                      SizedBox(height: compact ? 8 : 15),

                      // STOCK AND PRICE
                      Row(
                        children: [
                          Icon(
                            Icons.inventory_2_outlined,
                            size: compact ? 16 : 19,
                            color: lightGreen,
                          ),

                          const SizedBox(width: 6),

                          Expanded(
                            child: Text(
                              'Stock: ${medicine.quantity} ${medicine.unit}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: compact ? 11 : 13,
                              ),
                            ),
                          ),

                          Icon(
                            Icons.payments_outlined,
                            size: compact ? 16 : 19,
                            color: lightGreen,
                          ),

                          const SizedBox(width: 5),

                          Flexible(
                            child: Text(
                              '₱${medicine.price.toStringAsFixed(2)}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: lightGreen,
                                fontSize: compact ? 11 : 14,
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: compact ? 7 : 13),

                      // EXPIRATION DATE
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_month_outlined,
                            size: compact ? 15 : 18,
                            color: isExpired
                                ? Colors.redAccent
                                : lightGreen,
                          ),

                          const SizedBox(width: 7),

                          Expanded(
                            child: Text(
                              'Expires: ${medicine.expirationDate.day}/${medicine.expirationDate.month}/${medicine.expirationDate.year}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: compact ? 11 : 13,
                                color: isExpired
                                    ? Colors.redAccent
                                    : Colors.white70,
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: compact ? 6 : 12),

                      Divider(
                        color: lightGreen.withValues(alpha: 0.2),
                        height: 1,
                      ),

                      SizedBox(height: compact ? 2 : 5),

                      // EDIT AND DELETE BUTTONS
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [

                          if (widget.onEdit != null)
                            TextButton.icon(
                              onPressed: widget.onEdit,
                              icon: Icon(
                                Icons.edit_outlined,
                                size: compact ? 15 : 18,
                              ),
                              label: Text(
                                'Edit',
                                style: TextStyle(
                                  fontSize: compact ? 11 : 14,
                                ),
                              ),
                              style: TextButton.styleFrom(
                                foregroundColor: lightGreen,
                                padding: EdgeInsets.symmetric(
                                  horizontal: compact ? 5 : 10,
                                  vertical: compact ? 2 : 8,
                                ),
                                minimumSize: Size(
                                  0,
                                  compact ? 30 : 40,
                                ),
                                tapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                visualDensity: compact
                                    ? VisualDensity.compact
                                    : VisualDensity.standard,
                              ),
                            ),

                          if (widget.onDelete != null)
                            TextButton.icon(
                              onPressed: widget.onDelete,
                              icon: Icon(
                                Icons.delete_outline,
                                size: compact ? 15 : 18,
                              ),
                              label: Text(
                                'Delete',
                                style: TextStyle(
                                  fontSize: compact ? 11 : 14,
                                ),
                              ),
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.redAccent,
                                padding: EdgeInsets.symmetric(
                                  horizontal: compact ? 5 : 10,
                                  vertical: compact ? 2 : 8,
                                ),
                                minimumSize: Size(
                                  0,
                                  compact ? 30 : 40,
                                ),
                                tapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                visualDensity: compact
                                    ? VisualDensity.compact
                                    : VisualDensity.standard,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
