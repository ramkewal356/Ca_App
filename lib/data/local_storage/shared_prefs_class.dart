import 'package:ca_app/utils/constanst/storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsClass {
  static final String _token = StorageConstants.token;
  static final String _role = StorageConstants.role;
  static final String _id = StorageConstants.id;

  Future<void> saveUser(String token, String role, int id) async {
    SharedPreferences share = await SharedPreferences.getInstance();
    await share.setString(_token, token);
    await share.setString(_role, role);
    await share.setInt(_id, id);

  }

  Future<String?> getToken() async {
    SharedPreferences share = await SharedPreferences.getInstance();
    return share.getString(_token);
  }
  Future<String?> getRole() async {
    SharedPreferences share = await SharedPreferences.getInstance();
    return share.getString(_role);
  }

  Future<int?> getUserId() async {
    SharedPreferences share = await SharedPreferences.getInstance();
    return share.getInt(_id);
  }

  Future<void> removeToken() async {
    SharedPreferences share = await SharedPreferences.getInstance();
    await share.remove(_token);
    await share.remove(_role);
    await share.remove(_id);

  }
}
