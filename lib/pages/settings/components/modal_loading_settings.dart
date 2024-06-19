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

  String step="loading";
  

  bool isLoad=false;

  String error='';

  List<FullInfo> info=[];
  int insertedToDb=0;
  void loading()async{
    if(!isLoad){
      isLoad=true;
      final result=await DataInfoHttp().getFullInfo();
      if(result!=null){
        setState(() {
          info=result;
          step="insertDB";
        });
      }
      isLoad=false;
    }
    
  }

  void insertDb()async{
    if(!isLoad){
      isLoad=true;
      await dataBase.insertFullInfo(info,(){
      setState(() {
        insertedToDb=insertedToDb+1;
      });
    });
     await DataInfoStorage().setLastDate(DateTime.now().toString());
     await DataInfoStorage().setCount(info.length.toString());
     widget.updateSyncInfo(info.length.toString(),DateTime.now().toString());
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
    if(step=="loading") stepCounter="1";
    if(step=="insertDB") stepCounter="2";
    return  GestureDetector(
      onTap: () {
        
      },
      child: Container(
        alignment: Alignment.center,
        child: Container(
                height: 140,
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width-50,
                decoration: BoxDecoration(
                  color: Colors.white
                ),
                child: Column(
                  children: [
                    SizedBox(height: 20,),
                    Text(
                      step=="succ"?"Готово":"Загрузка данных(${stepCounter}/2)",
                      style: TextStyle(
                        fontSize: 22
                      ),
                    ),
                    Expanded(
                      child: Builder(
                        builder: (context) {
                          if(step=="loading"){
                            loading();
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
                                      "${insertedToDb}/${info.length}",
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
                                  
                                  Text(
                                    "Обновлено ",
                                    style: TextStyle(
                                      fontSize: 18
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
                                  )
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