import 'package:shared_preferences/shared_preferences.dart';


class UserData {
  static String? upiId;
  
  static Future<void> saveUpiId(String upiId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('upi_id', upiId);
    UserData.upiId = upiId;
  }

  static Future<String?> loadUpiId() async {
    final prefs = await SharedPreferences.getInstance();
    upiId = prefs.getString('upi_id');
    return upiId;
  }

  static Future<void> clearUpiId() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('upi_id');
    upiId = null;
  }
}