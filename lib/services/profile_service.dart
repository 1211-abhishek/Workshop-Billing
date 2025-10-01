import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/business_profile.dart';

class ProfileService {
  static const _key = 'business_profile';

  Future<void> saveProfile(BusinessProfile profile) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = jsonEncode(profile.toJson());
      await prefs.setString(_key, jsonString);
    } catch (e) {
      debugPrint('Failed to save profile: $e');
      // Depending on the app's needs, you might want to rethrow
      // or show a notification to the user.
    }
  }

  Future<BusinessProfile?> loadProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_key);
      if (jsonString != null) {
        final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
        return BusinessProfile.fromJson(jsonMap);
      }
    } catch (e) {
      // This catch block handles errors like PlatformExceptions when the
      // plugin fails to communicate with the native side.
      // We will just log the error and return null to prevent the UI from hanging.
      debugPrint('Failed to load profile: $e');
      return null;
    }
    return null;
  }
}
