import "package:hive_flutter/hive_flutter.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:x_obese/src/screens/info_collector/model/user_info_model.dart";

class UserDB {
  static Box? _userDBBox;
  static SharedPreferences? _preferences;

  static Future<void> init() async {
    await Hive.initFlutter();
    _userDBBox = await Hive.openBox("user");
    _preferences = await SharedPreferences.getInstance();
  }

  static Future<void> deleteUserData() async {
    await Hive.box("user").deleteFromDisk();
    await init();
  }

  static UserInfoModel? userAllInfo() {
    String? info = _userDBBox!.get("info", defaultValue: null);
    if (info == null) return null;
    return UserInfoModel.fromJson(_userDBBox!.get("info"));
  }

  static Future<void> saveUserAllInfo(UserInfoModel info) async {
    await _userDBBox!.put("info", info.toJson());
  }

  static String? accessToken() {
    return _preferences!.getString("access_token");
  }

  static String? refreshToken() {
    return _preferences!.getString("refresh_token");
  }

  static Future<void> saveAccessToken(String accessToken) async {
    await _preferences!.setString("access_token", accessToken);
  }

  static Future<void> saveRefreshToken(String refreshToken) async {
    await _preferences!.setString("refresh_token", refreshToken);
  }
}
