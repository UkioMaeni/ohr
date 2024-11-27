import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:secure_kpp/db/sqllite.dart';
import 'package:secure_kpp/pages/main_page/main_page.dart';
import 'package:secure_kpp/pages/start_page/kpp_auth.dart';
import 'package:secure_kpp/pages/start_page/variable_kpp.dart';
import 'package:secure_kpp/storage/data_info_storage.dart';
import 'package:secure_kpp/storage/role_storeage.dart';
import 'package:secure_kpp/store/store.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {


  void toKppPage(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => VariableKppPage(),));
  }



  bool loading=true;

   checkRole()async{
    await dataBase.getPath();
    //await dataBase.dropDatabase();
    await dataBase.createDB();
    await dataBase.checkJurnal();
    await dataInfoStorage.getCount();
    await dataInfoStorage.getLastDate();
    String role=await RoleStorage().getRole();
    try {
      String? deviceId = await PlatformDeviceId.getDeviceId;
      print(deviceId);
      appStore.deviceId=deviceId;
    } catch (e) {
      
    }
    int kpp=0;
    if(role.contains("kpp")){
      RoleStorage.role="kpp";
      int parsedKpp=int.parse(role.split("_")[1]);
      kpp=parsedKpp;
      
      print(kpp);
      appStore.kpp=kpp.toString();
      
     return Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MainPage(),),(route) => false,);
    }else{
      await Future.delayed(Duration(seconds: 2));
      setState(() {
        loading=false;
      });
    }
  }

  @override
  void initState() {
    checkRole();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                SizedBox(height: 24,),
                SizedBox(height: 35,),
                Align(
                  alignment: Alignment.center,
                  child: Image.asset("assets/png/start.png")
                ),
               
              ],
            ),
            loading
            ?Padding(padding: EdgeInsets.only(bottom: 100), child: CircularProgressIndicator())
            :Column(
              children: [
                  button("Выбрать КПП",toKppPage),
                  SizedBox(height: 40,),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget button(String title, Function() onClick){
    return GestureDetector(
      onTap: onClick,
      child: SizedBox(
        height: 58,
        width: double.infinity,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Color.fromRGBO(59, 130, 246, 1),
            borderRadius: BorderRadius.circular(12)
          ),
          child: Align(
            alignment: Alignment.center,
            child: Text(
                title,
                style: TextStyle(
                  fontFamily: "No__",
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white
                ),
              ),
          ),
        ),
      ),
    );
  }
}