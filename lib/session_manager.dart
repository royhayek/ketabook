import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  // user information
  final String userId = "id";
  final String theme = "theme";
  final String firstTime = "firstTime";
  final String language = "language";

  // check if it is first time
  Future<bool> checkFirstTime() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getBool(this.firstTime) ?? null;
  }

  // Set that the app is launched for the first time
  Future<void> setFirstTime(bool firstTime) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(this.firstTime, firstTime);
  }

  // Get the saved theme
  Future<String> getLanguage() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(this.language) ?? null;
  }

  // Save the user id
  Future<void> setLanguage(String id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(this.language, id);
  }

  // Get the saved user id
  Future<String> getUserId() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(this.userId) ?? null;
  }

  Future<void> setUserId(String id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(this.userId, id);
  }

  Future<void> clearUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(userId);
  }
}
