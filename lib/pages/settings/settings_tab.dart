import 'package:flutter/material.dart';
import 'package:flutter_app_info/flutter_app_info.dart';
import 'package:secure_kpp/db/sqllite.dart';
import 'package:secure_kpp/http/dataInfo.dart';
import 'package:secure_kpp/pages/full_settings/full_settings.dart';
import 'package:secure_kpp/pages/settings/components/modal_loading_settings.dart';
import 'package:secure_kpp/storage/data_info_storage.dart';
import 'package:secure_kpp/store/store.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsTab extends StatefulWidget {
  const SettingsTab({super.key});

  @override
  State<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {


  void syncData()async{
    showDialog(
      barrierDismissible: false,
      context: context, 
      builder: (context) {
        return ModalLoadingSettings(updateSyncInfo:updateSyncInfo);
      },
    );
    
  }

  String count="";
  String lastDate="";

  lastSync()async{
    count= dataInfoStorage.count??"N\\A";
    lastDate=dataInfoStorage.lastDate??"N\\A";
    setState(() {
      
    });
  }

  updateSyncInfo(String newCount,String date){
    setState(() {
      dataInfoStorage.count=newCount;
      dataInfoStorage.setLastDate(date);
      count=newCount;
      lastDate=date;
    });
  }

  @override
  void initState() {
    lastSync();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    
                    SizedBox(height: 24,),
                    Text(
                      "Настройки",
                      style: TextStyle(
                        fontFamily: "No__",
                        fontSize: 20,
                        fontWeight: FontWeight.w500
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("deviceId: ${appStore.deviceId??"Неизвестно"}"),
                          Text("КПП: ${appStore.kpp??"Неизвестно"}"),
                          SizedBox(height: 20,),
                          Text("Версия: ${AppInfo.of(context).package.version}"),
                          GestureDetector(
                            onTap: () async{
                              // await launchUrl(
                              //   Uri.parse("http://82.97.245.161:3005/downloadfile"),
                              //   mode: LaunchMode.externalApplication,
                              //   browserConfiguration:  BrowserConfiguration(showTitle: true)
                              // );
                              Navigator.push(context, MaterialPageRoute(builder: (context) => FullSettings(),));
                            },
                            child: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(10)
                              ),
                              child: Text("Открыть все настройки",style: TextStyle(color: Colors.white),),
                            ),
                          )
                        ],
                      ),
                    ),
                    
                    SizedBox(height: 80,),
                    syncButton(),
                    SizedBox(height: 24,),
                    syncInfo()
                  ],
                ),
            ),
    );
  }

  Widget syncInfo(){
    return Column(
      children: [
        Text(
          "Последняя синхронизация",
          style: TextStyle(
            fontFamily: "No__",
            fontSize: 16,
            fontWeight: FontWeight.w300,
          ),
        ),
        Text(
          lastDate,
          style: TextStyle(
            fontFamily: "No__",
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          "Всего данных",
          style: TextStyle(
            fontFamily: "No__",
            fontSize: 16,
            fontWeight: FontWeight.w300,
          ),
        ),
        Text(
          count,
          style: TextStyle(
            fontFamily: "No__",
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget syncButton(){
    return GestureDetector(
      onTap: syncData,
      child: Container(
        height: 56,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Color.fromRGBO(59, 130, 246, 1),
          borderRadius: BorderRadius.circular(12)
        ),
        child:Text(
                      "Синхронизировать данные",
                      style: TextStyle(
                        fontFamily: "No__",
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white
                      ),
                    ),
      ),
    );
  }

}