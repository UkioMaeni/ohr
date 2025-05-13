import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:secure_kpp/db/sqllite.dart';
import 'package:secure_kpp/http/dataInfo.dart';
import 'package:secure_kpp/models/full_info.dart';
import 'package:secure_kpp/storage/data_info_storage.dart';

class ModalLoadingSettings extends StatefulWidget {
  final Function(String,String) updateSyncInfo;
  const ModalLoadingSettings({super.key,required this.updateSyncInfo});

  @override
  State<ModalLoadingSettings> createState() => _ModalLoadingSettingsState();
}

class _ModalLoadingSettingsState extends State<ModalLoadingSettings> {

  String step="sendJurnal";
  

  bool isLoad=false;

  String error='';

  List<FullInfo>? info;
  int insertedToDb=0;


  sendJurnal()async{
    if(isLoad) return;

    try {
      isLoad=true;
      final addResult= await DataInfoHttp().addJurnalToServer();
      if(addResult!=null){
        dataBase.deleteJurnal();
        setState(() {
          step="completedJurnal";
        });
      }else{
        setState(() {
          step="errorJurnal";
        });
        
      }
    } catch (e) {
      
    } finally {
      isLoad=false;
    }
  }

  updateDB()async{
    if(isLoad) return;
    try {
      final result=await DataInfoHttp().getFullInfo();
      if(result!=null){
        Future.delayed(Duration(seconds: 1)).then((value) {
          setState(() {
            info=result;
            step="insertDB";
          });
        },);
        
      }else{
        setState(() {
            step="errorDB";
        });
      }
    } catch (e) {
      setState(() {
            step="errorDB";
        });
    } finally {
      isLoad=false;
    }
  } 


  toDbStep(){
    Future.delayed(Duration(seconds: 1)).then((value) {
      setState(() {
        step="loadDB";
      });
    },);
  }

  void loading()async{
    if(!isLoad){
      isLoad=true;
      final result=await DataInfoHttp().getFullInfo();
      if(result!=null){
        setState(() {
          info=result;
          step="insertDB";
        });
      }else{
        
        
      }
      isLoad=false;
    }
    
  }

  void insertDb()async{
    if(!isLoad){
      isLoad=true;
      await dataBase.insertFullInfo(info!,(){
      setState(() {
        insertedToDb=insertedToDb+1;
      });
    });
     await DataInfoStorage().setLastDate(DateTime.now().toString());
     await DataInfoStorage().setCount(info!.length.toString());
     widget.updateSyncInfo(info!.length.toString(),DateTime.now().toString());
    setState(() {

      step="succ";
    });
    isLoad=false;
    }
    
    
  }

  @override
  void initState() {
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String stepCounter="0";
    if(step=="sendJurnal") stepCounter="Загрузка данных(1/2)";
    if(step=="loadDB") stepCounter="Загрузка данных(2/2)";
    if(step=="insertDB") stepCounter="Загрузка данных(2/2)";
    if(step=="succ") stepCounter="Готово";
    if(step=="errorJurnal") stepCounter="Ошибка";
    if(step=="errorDB") stepCounter="Ошибка";
    if(step=="completedJurnal") stepCounter="Журнал отправлен";
    return  GestureDetector(
      onTap: () {
        
      },
      child: Container(
        alignment: Alignment.center,
        child: Container(
                height: 250,
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width-50,
                decoration: BoxDecoration(
                  color: Colors.white
                ),
                child: Column(
                  children: [
                    SizedBox(height: 20,),
                    Text(
                      stepCounter,
                      style: TextStyle(
                        fontSize: 22
                      ),
                    ),
                    Expanded(
                      child: Builder(
                        builder: (context) {
                          if(step=="loadDB"){
                            updateDB();
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 30),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  
                                  Text(
                                    "Скачивание базы",
                                    style: TextStyle(
                                      fontSize: 18
                                    ),
                                  ),
                                  SizedBox(
                                    width: 30,
                                    height: 30,
                                    child: Center(child: CircularProgressIndicator())
                                  )
                                ],
                              ),
                            );
                          }else if(step=="sendJurnal"){
                            sendJurnal();
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 30),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  
                                  Text(
                                    "Скачивание базы",
                                    style: TextStyle(
                                      fontSize: 18
                                    ),
                                  ),
                                  SizedBox(
                                    width: 30,
                                    height: 30,
                                    child: Center(child: CircularProgressIndicator())
                                  )
                                ],
                              ),
                            );
                          }else if(step=="errorDB"){
                            //insertDb();
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 30),
                              child:  Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  
                                  SizedBox(height: 20,),
                                  Expanded(
                                    child: Text(
                                      "Произошла ошибка при обновлении базы.\nБаза осталась в предыдущем виде",
                                      style: TextStyle(
                                        fontSize: 16
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(vertical: 10,horizontal: 30),
                                      decoration: BoxDecoration(
                                        color: Color.fromRGBO(59, 130, 246, 1),
                                        borderRadius: BorderRadius.circular(10)
                                      ),
                                      child: Text(
                                        "Закрыть",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20,)
                                ],
                              ),
                            );
                          }else if(step=="completedJurnal"){
                            toDbStep();
                            //insertDb();
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 30),
                              child:  Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  
                                Container(
                                  height: 80,
                                  width: 80,
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 97, 197, 100),
                                    borderRadius: BorderRadius.circular(80)
                                  ),
                                  alignment: Alignment.center,
                                  child: Icon(Icons.check,size: 40,color: Colors.white,),
                                )
                                ],
                              ),
                            );
                          }else if(step=="errorJurnal"){
                            //insertDb();
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 30),
                              child:  Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(height: 20,),
                                  Expanded(
                                    child: Text(
                                      "Произошла ошибка при отправке Журнала.\nЖурнал остался в неизменном виде",
                                      style: TextStyle(
                                        fontSize: 16
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(vertical: 10,horizontal: 30),
                                      decoration: BoxDecoration(
                                        color: Color.fromRGBO(59, 130, 246, 1),
                                        borderRadius: BorderRadius.circular(10)
                                      ),
                                      child: Text(
                                        "Закрыть",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20,)
                                ],
                              ),
                            );
                          }else if(step=="insertDB"){
                            insertDb();
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 30),
                              child:  Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  
                                  Text(
                                    "Обновление базы",
                                    style: TextStyle(
                                      fontSize: 18
                                    ),
                                  ),
                                  SizedBox(
                                    
                                    height: 30,
                                    child: Text(
                                      "${insertedToDb}/${info!.length}",
                                      style: TextStyle(
                                        fontSize: 18
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            );
                          }else if(step=="succ"){
                            
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 30),
                              child:  Column(
                                
                                children: [
                                  
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        "Обновлено!",
                                        style: TextStyle(
                                          fontSize: 18
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(vertical: 10,horizontal: 30),
                                      decoration: BoxDecoration(
                                        color: Color.fromRGBO(59, 130, 246, 1),
                                        borderRadius: BorderRadius.circular(10)
                                      ),
                                      child: Text(
                                        "Завершить",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20,)
                                ],
                              ),
                            );
                          }
                          return SizedBox.shrink();
                        }
                      ),
                    ),
                  ],
                ),
              
            ),
      ),
    );
  }
}