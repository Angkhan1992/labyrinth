import 'package:shared_preferences/shared_preferences.dart';
import 'package:labyrinth/utils/extension.dart';

class SharedProvider {
  final keyBioAuth = 'key_bio_auth';
  final keyBioEnable = 'key_bio_enable';
  final keyBioTime = 'key_bio_time';
  final keyEmail = 'key_email';
  final keyPass = 'key_pass';
  final keySettingTile = 'key_setting_tile';
  final keyBackColor = 'key_back_color';
  final keyHoverColor = 'key_hover_color';
  final keyNotiUnread = 'key_noti_unread';
  final keyBlogUnread = 'key_blog_unread';

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

  Future<String> getSettingTile() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString(keySettingTile) ?? '0,0';
  }

  Future setSettingTile(String value) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString(keySettingTile, value);
  }

  Future<int> getBackColor() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getInt(keyBackColor) ?? 0;
  }

  Future setBlackColor(int value) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setInt(keyBackColor, value);
  }

  Future<int> getHoverColor() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getInt(keyHoverColor) ?? 0;
  }

  Future setHoverColor(int value) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setInt(keyHoverColor, value);
  }

  Future<int> getNotiUnread() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getInt(keyNotiUnread) ?? 0;
  }

  Future setNotiUnread(int value) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setInt(keyNotiUnread, value);
  }

  Future<int> getBlogUnread() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getInt(keyBlogUnread) ?? 0;
  }

  Future setBlogUnread(int value) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setInt(keyBlogUnread, value);
  }
}
