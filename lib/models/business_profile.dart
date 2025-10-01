import 'package:flutter/foundation.dart';

@immutable
class BusinessProfile {
  final String name;
  final String address;
  final String phone;
  final String email;

  const BusinessProfile({
    required this.name,
    required this.address,
    required this.phone,
    required this.email,
  });

  factory BusinessProfile.fromJson(Map<String, dynamic> json) {
    try {
      return BusinessProfile(
        name: json['name'] as String,
        address: json['address'] as String,
        phone: json['phone'] as String,
        email: json['email'] as String,
      );
    } catch (e) {
      debugPrint('Error parsing BusinessProfile from JSON: $e');
      throw const FormatException('Invalid BusinessProfile format');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'address': address,
      'phone': phone,
      'email': email,
    };
  }
}
