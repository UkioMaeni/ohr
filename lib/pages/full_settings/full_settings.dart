import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_info/flutter_app_info.dart';
import 'package:secure_kpp/db/sqllite.dart';
import 'package:secure_kpp/store/store.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:android_package_installer/android_package_installer.dart';
class FullSettings extends StatefulWidget {
  const FullSettings({super.key});

  @override
  State<FullSettings> createState() => _FullSettingsState();
}

class _FullSettingsState extends State<FullSettings> {


  bool isDownload=false;

  int total=1;
  int count = 0;

  String error="";
  void download()async{
    if(isDownload) return;
    setState(() {
        isDownload=true;
        error="";
      });
     var status = await Permission.requestInstallPackages.request();
     if(status!=PermissionStatus.granted){
      setState(() {error="Нет разрешения";});
      return;
     }
      try {
        final directory = await getApplicationDocumentsDirectory();
      print(directory.path);
      File file = File('${directory.path.replaceFirst("/app_flutter", "")}/update.apk');
      print(await file.exists());
      if(await file.exists()){
        await file.delete();
      }
       int major= AppInfo.of(context).package.version.major;
       int minor= AppInfo.of(context).package.version.minor;
       int patch= AppInfo.of(context).package.version.patch;
       String version = "$major.$minor.$patch";
       print(version);
       
        final response= await Dio().get(

        "http://82.97.245.161:3005/downloadfile?version=$version",
        options: Options(
          responseType: ResponseType.bytes
        ),
        onReceiveProgress: (count, total) {
          setState(() {
            this.total=total;
            this.count=count;
          });
          print(count);
          print(total);
        },
      );
      print(response.data);
      await file.writeAsBytes(response.data);
      int? statusCode = await AndroidPackageInstaller.installApk(apkFilePath: file.path);
      if (statusCode != null) {
        print(statusCode);
        PackageInstallerStatus installationStatus = PackageInstallerStatus.byCode(statusCode);
        print(installationStatus.name);
      }
      } catch (e) {
        if(e is DioException){
         DioException dioError = e as DioException;
          if(dioError.response?.statusCode==400){
            setState(() {
              error="Актуальная версия уже установлена";
            });
          }
        }else{
          setState(() {
            error="Непредвиденая ошибка, повторите попытку";
          });
        }
        
      }
    setState(() {isDownload=false;});
  }

  double get width => MediaQuery.of(context).size.width;
  double get progress => count.toDouble()/total.toDouble();

  int? jurnalCount;
  getJurnalCount()async{
   jurnalCount= await dataBase.checkJurnalCount(); 
   setState(() {
     
   });
  }
  @override
  void initState() {
    getJurnalCount();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: Colors.white,
      ),
      body: PopScope(
        canPop: !isDownload,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  if(isDownload) return;
                  Navigator.pop(context);
                },
                child: Container(
                  height: 70,
                  alignment: Alignment.centerLeft,
                  color: Color.fromARGB(255, 255, 255, 255),
                  child: Icon(Icons.arrow_back),
                ),
              ),
              SizedBox(height: 20,),
              Text("deviceId: ${appStore.deviceId??"Неизвестно"}",style: TextStyle(fontSize: 18)),
              Text("КПП: ${appStore.kpp??"Неизвестно"}",style: TextStyle(fontSize: 18)),
              Row(
                children: [
                  Text("Всего записей в журнале:",style: TextStyle(fontSize: 18)),
                  SizedBox(width: 20,),
                  jurnalCount==null?SizedBox(width: 10,height: 10, child: CircularProgressIndicator()):Text(jurnalCount.toString(),style: TextStyle(fontSize: 18)),
                ],
              ),
              SizedBox(height: 20,),
              Text("Версия: ${AppInfo.of(context).package.version}",style: TextStyle(fontSize: 18)),
              GestureDetector(
                onTap: download,
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10)
                  ),
                 height: 50,
                  alignment: Alignment.center,
                  child: 
                    !isDownload
                      ?Text("Обновить версию",style: TextStyle(color: Colors.white,fontSize: 20),)
                      :SizedBox(width: 20,height: 20, child: CircularProgressIndicator(color: Colors.white,)),
                ),
              ),
              SizedBox(height: 30,),
              if(error.isNotEmpty)
              Text(
                    error,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 18
                    ),
                  ),
              if(isDownload)
              Column(
                children: [
                  Text(
                    "Загрузка файла",
                    textAlign: TextAlign.center,
                  ),
                  Container(
                    alignment: Alignment.center,
                    height: 30,
                    width: width-48,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 133, 186, 228),
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: Builder(
                      builder: (context) {
                      
                        double progressNormalized = (progress*1000).toInt().toDouble()/10;
                        return Stack(
                          alignment: Alignment.center,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                
                                height: 30,
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(10)
                                ),
                                
                                width: (width-48)*(progress),
                              ),
                            ),
                            Text(
                              "$progressNormalized%",
                              textAlign: TextAlign.center,
                            ),
                            
                          ],
                        );
                      }
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}