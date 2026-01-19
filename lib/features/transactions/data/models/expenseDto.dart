import 'dart:convert';

class ExpenseDto {
  final String? externalId;
  final String amount;
  final String? userId; // Optional, as it's passed in the Header mainly
  final String merchant;
  final String currency;
  final DateTime createdAt;

  ExpenseDto({
    this.externalId,
    required this.amount,
    this.userId,
    required this.merchant,
    required this.currency,
    required this.createdAt,
  });

  // Convert the object to a Map (JSON) to send to the API
  Map<String, dynamic> toJson() {
    return {
      'external_id': externalId,
      'amount': amount,
      'user_id': userId,
      'merchant': merchant,
      'currency': currency,
      // Java Timestamp handles ISO-8601 strings automatically via Jackson
      'created_at': createdAt.toIso8601String(),
    };
  }

  // Factory constructor to create an object from JSON (for reading responses later)
  factory ExpenseDto.fromJson(Map<String, dynamic> json) {
    return ExpenseDto(
      externalId: json['external_id'],
      amount: json['amount'],
      userId: json['user_id'],
      merchant: json['merchant'],
      currency: json['currency'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}