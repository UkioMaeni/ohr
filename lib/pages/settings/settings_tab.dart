import 'package:flutter/material.dart';
import 'package:secure_kpp/db/sqllite.dart';
import 'package:secure_kpp/http/dataInfo.dart';
import 'package:secure_kpp/pages/settings/components/modal_loading_settings.dart';
import 'package:secure_kpp/storage/data_info_storage.dart';

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
    count= await DataInfoStorage().getCount();
    lastDate=await DataInfoStorage().getLastDate();
    setState(() {
      
    });
  }

  updateSyncInfo(String newCount,String date){
    setState(() {
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
                    SizedBox(height: 120,),
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