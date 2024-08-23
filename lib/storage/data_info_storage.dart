import 'package:secure_kpp/db/sqllite.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataInfoStorage{

   getCount() async {
    count=(await dataBase.checkCount()).toString();
  }
  getLastDate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
      String? refresh=  prefs.getString("date");
      refresh ??= "N/A";
      lastDate=refresh;
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
  removeLastDate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
      await  prefs.remove("date");
      
  }
  String? count;
  String? lastDate;

}

DataInfoStorage dataInfoStorage = DataInfoStorage();