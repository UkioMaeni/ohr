import 'package:shared_preferences/shared_preferences.dart';

class RoleStorage{
   getRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
      String? refresh=  prefs.getString("role");
      refresh ??= "no";
      return  refresh;
  }
  Future<String> setRole(String role) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
      await  prefs.setString("role",role);
      return  role;
  }
  static String role="";
}

