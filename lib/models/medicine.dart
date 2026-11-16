
import 'package:cloud_firestore/cloud_firestore.dart';

class Medicine {
  final String id;
  final String name;
  final String category;
  final String dosage;
  final String unit;
  final int quantity;
  final double price;
  final DateTime expirationDate;
  final String supplier;
  final String description;

  Medicine({
    this.id = '',
    required this.name,
    required this.category,
    required this.dosage,
    required this.unit,
    required this.quantity,
    required this.price,
    required this.expirationDate,
    required this.supplier,
    required this.description,
  });

  factory Medicine.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data()!;

    return Medicine(
      id: doc.id,
      name: data['name'] ?? '',
      category: data['category'] ?? '',
      dosage: data['dosage'] ?? '',
      unit: data['unit'] ?? 'pcs',
      quantity: data['quantity'] ?? 0,
      price: (data['price'] ?? 0).toDouble(),
      expirationDate:
          (data['expirationDate'] as Timestamp).toDate(),
      supplier: data['supplier'] ?? '',
      description: data['description'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'category': category,
      'dosage': dosage,
      'unit': unit,
      'quantity': quantity,
      'price': price,
      'expirationDate':
          Timestamp.fromDate(expirationDate),
      'supplier': supplier,
      'description': description,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
}
