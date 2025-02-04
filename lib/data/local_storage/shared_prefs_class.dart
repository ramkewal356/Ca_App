import 'package:ca_app/utils/constanst/storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsClass {
  static final String _token = StorageConstants.token;
  Future<void> saveToken(String token) async {
    SharedPreferences share = await SharedPreferences.getInstance();
    await share.setString(_token, token);
  }

  Future<String?> getToken() async {
    SharedPreferences share = await SharedPreferences.getInstance();
    return share.getString(_token);
  }

  Future<void> removeToken() async {
    SharedPreferences share = await SharedPreferences.getInstance();
    await share.remove(_token);
  }
}
