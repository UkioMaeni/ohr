import 'package:shared_preferences/shared_preferences.dart';

class DataInfoStorage{
   getCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
      String? refresh=  prefs.getString("count");
      refresh ??= "N/A";
      return  refresh;
  }
  getLastDate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
      String? refresh=  prefs.getString("date");
      refresh ??= "N/A";
      return  refresh;
  }
  setCount(String role) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
      await  prefs.setString("count",role);
      return  role;
  }
  setLastDate(String role) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
      await  prefs.setString("date",role);
      return  role;
  }
}

