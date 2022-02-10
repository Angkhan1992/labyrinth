import 'package:shared_preferences/shared_preferences.dart';
import 'package:labyrinth/utils/extension.dart';

class SharedProvider {
  final keyBioAuth = 'key_bio_auth';
  final keyBioEnable = 'key_bio_enable';
  final keyBioTime = 'key_bio_time';
  final keyEmail = 'key_email';
  final keyPass = 'key_pass';

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<bool?> isBioAuth() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getBool(keyBioAuth);
  }

  Future<void> removeBioAuth() async {
    final SharedPreferences prefs = await _prefs;
    await prefs.remove(keyBioAuth);
  }

  Future<void> setBioAuth(bool isAuth) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setBool(keyBioAuth, isAuth);
  }

  Future<bool> isBioEnabled() async {
    final SharedPreferences prefs = await _prefs;
    var res = prefs.getBool(keyBioEnable);
    if (res == null) {
      return true;
    } else {
      return res;
    }
  }

  Future<void> setBioEnabled(bool isEnabled) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setBool(keyBioEnable, isEnabled);
  }

  Future<DateTime> getBioTime() async {
    final SharedPreferences prefs = await _prefs;
    var time = prefs.getString(keyBioTime);
    if (time == null) return DateTime.now();
    return time.getFullDate;
  }

  Future setBioTime(DateTime time) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString(keyBioTime, time.getFullTime);
  }

  Future<String?> getEmail() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString(keyEmail);
  }

  Future setEmail(String email) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString(keyEmail, email);
  }

  Future<String?> getPass() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString(keyPass);
  }

  Future setPass(String pass) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString(keyPass, pass);
  }
}
