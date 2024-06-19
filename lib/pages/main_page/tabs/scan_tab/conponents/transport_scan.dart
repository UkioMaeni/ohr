import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobx/mobx.dart';
import 'package:secure_kpp/db/sqllite.dart';
import 'package:secure_kpp/models/full_info.dart';
import 'package:secure_kpp/pages/main_page/store/transport_store.dart';
import 'package:secure_kpp/pages/main_page/tabs/scan_tab/conponents/scaning.dart';
import 'package:secure_kpp/pages/main_page/tabs/ruchnoi_tab/scaning_ruchnoi.dart';
import 'package:secure_kpp/pages/main_page/tabs/scan_tab/pages/check.dart';
import 'package:secure_kpp/storage/role_storeage.dart';

class ScanTransportPage extends StatefulWidget {
  final Function(String) toCheck;
  const ScanTransportPage({super.key,required this.toCheck});

  @override
  State<ScanTransportPage> createState() => _ScanTransportPageState();
}

class _ScanTransportPageState extends State<ScanTransportPage> {


 


  void showModal(int indexpeople){
    String people="";
    if(indexpeople==-2) people="Автомобиль";
    if(indexpeople==-1) people="Водитель";
    if(indexpeople>=0) people="${indexpeople+1} Пассажир";
    showDialog(
      context: context, 
      builder: (context) {
        return ScanSelf(currentPeople: people,);
      },
    );
  }

  void showInfo(InformarionAboutPeople info){
    
    showDialog(
      context: context, 
      builder: (context) {
        return InfoModalAboutPeople(info: info,);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return  Expanded(
                child: ListView(
                  children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Text(
                                "Автомобиль",
                                style: TextStyle(
                                  fontFamily: "No__",
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500
                                ),
                              ),
                              GestureDetector(
                                onTap: (){
                                  transportStore.currentPeople="Автомобиль";
                                  showModal(-2);
                                },
                                child: Container(
                                    width: 120,
                                    height: 120,
                                    decoration: BoxDecoration(
                                      color: Color.fromRGBO(168, 201, 255, 1),
                                      borderRadius: BorderRadius.circular(12)
                                    ),
                                    alignment: Alignment.center,
                                    child: SvgPicture.asset("assets/svg/filter_center_focus.svg",width: 100,height: 100,)
                                  ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                "Водитель",
                                style: TextStyle(
                                  fontFamily: "No__",
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500
                                ),
                              ),
                              Observer(
                                builder: (context) {
                                  final driver=transportStore.driverInfo;
                                  print(driver);
                                  return GestureDetector(
                                    onTap: (){
                                      if(driver==null){
                                        transportStore.currentPeople="Водитель";
                                        showModal(-1);
                                      }else{
                                        showInfo(driver);
                                      }
                                      
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Container(
                                          width: 150,
                                          height: 150,
                                          decoration: BoxDecoration(
                                            color: Color.fromRGBO(168, 201, 255, 1),
                                            
                                          ),
                                          alignment: Alignment.center,
                                          child: Builder(
                                            builder: (context) {
                                              if(driver==null){
                                                return SvgPicture.asset("assets/svg/filter_center_focus.svg",width: 100,height: 100,);
                                              }else if(driver!=null&&driver.error.isNotEmpty){
                                                return Container(
                                                  color: Colors.red,
                                                  alignment: Alignment.center,
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Expanded(
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                              Text(
                                                              "Есть ошибки",
                                                              style: TextStyle(
                                                                color: Colors.white
                                                              ),
                                                            ),
                                                            Icon(Icons.touch_app,color: Colors.white,),
                                                          ],
                                                        )
                                                      ),
                                                      
                                                       GestureDetector(
                                                        onTap: () {
                                                          transportStore.deleteDriver();
                                                        },
                                                         child: ColoredBox(
                                                          color: Colors.green,
                                                           child: Row(
                                                              children: [
                                                                Padding(
                                                                  padding: const EdgeInsets.all(8.0),
                                                                  child: Text(
                                                                    "Очистить",
                                                                    style: TextStyle(
                                                                      fontSize: 20,
                                                                      color: Colors.white
                                                                    ),
                                                                  ),
                                                                  
                                                                ),
                                                                Icon(Icons.close,color: Colors.white,)
                                                              ],
                                                            
                                                                                                               ),
                                                         ),
                                                       )
                                                    ],
                                                  ),
                                                );
                                      
                                              }else{
                                                return Container(
                                                  color: Colors.green,
                                                  alignment: Alignment.center,
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Expanded(
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                              Text(
                                                                  driver.fullInfo?.fullName??"Нет имени",
                                                                  style: TextStyle(
                                                                    fontFamily: "Inter",
                                                                    fontSize: 15,
                                                                    fontWeight: FontWeight.w800,
                                                                    color: Colors.white
                                                                  ),
                                                                ),
                                                            
                                                                Text(
                                                                  "Пропуск №\n"+(driver.documentNumber??"Нет данных"),
                                                                  textAlign: TextAlign.center,
                                                                  style: TextStyle(
                                                                    fontFamily: "Inter",
                                                                    fontSize: 15,
                                                                    fontWeight: FontWeight.w800,
                                                                    color: Colors.white
                                                                  ),
                                                                ),
                                                            Icon(Icons.touch_app,color: Colors.white,),
                                                          ],
                                                        )
                                                      ),
                                                      
                                                       GestureDetector(
                                                        onTap: () {
                                                          transportStore.deleteDriver();
                                                        },
                                                         child: ColoredBox(
                                                          color: Color.fromARGB(255, 40, 60, 170),
                                                           child: Row(
                                                              children: [
                                                                Padding(
                                                                  padding: const EdgeInsets.all(8.0),
                                                                  child: Text(
                                                                    "Очистить",
                                                                    style: TextStyle(
                                                                      fontSize: 20,
                                                                      color: Colors.white
                                                                    ),
                                                                  ),
                                                                  
                                                                ),
                                                                Icon(Icons.close,color: Colors.white,)
                                                              ],
                                                            
                                                                                                               ),
                                                         ),
                                                       )
                                                    ],
                                                  ),
                                                );
                                              }
                                              return SizedBox();
                                            }
                                          )
                                        ),
                                    ),
                                  );
                                }
                              ),
                            ],
                          ),
                        ],
                    ),
                    SizedBox(height: 20,),
                    
                    
                     Observer(
                       builder: (context) {
                        final peoples= transportStore.peopleInfo;
                        final passangerCount=peoples.length;
                        print(peoples.length);
                         return Stack(
                            children: [
                              SizedBox(height: ((passangerCount+1)/2).ceil()*150,),
                              for (var i=0;i<passangerCount+1;i++)
                              Positioned(
                                top: (i/2).floor()*150,
                                left: i%2==0?25:null,
                                right: i%2==1?25:null,
                                child: Builder(
                                  
                                  builder: (context) {
                                    if(i==passangerCount){
                                    return Column(
                                      children: [
                                        Text(
                                          "Добавить",
                                          style: TextStyle(
                                            fontFamily: "No__",
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            
                                            transportStore.addPeople();
                                          },
                                          child: Container(
                                            width: 120,
                                            height: 120,
                                            decoration: BoxDecoration(
                                              color: Color.fromRGBO(179, 190, 206, 1),
                                              borderRadius: BorderRadius.circular(12)
                                            ),
                                            alignment: Alignment.center,
                                            child: Icon(Icons.add,color: Colors.white,size: 70,)
                                          ),
                                        ),
                                      ],
                                    );
                                    }
                                    return Column(
                                      children: [
                                        Text(
                                          "${i+1} Пассажир",
                                          style: TextStyle(
                                            fontFamily: "No__",
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: ()=>showModal(i),
                                          child: Container(
                                                  width: 120,
                                                  height: 120,
                                                  decoration: BoxDecoration(
                                                    color: Color.fromRGBO(168, 201, 255, 1),
                                                    borderRadius: BorderRadius.circular(12)
                                                  ),
                                                  alignment: Alignment.center,
                                                  child: SvgPicture.asset("assets/svg/filter_center_focus.svg",width: 100,height: 100,)
                                                ),
                                        ),
                                      ],
                                    );
                                  }
                                ),
                              )
                            ],
                          );
                       }
                     ),
                      SizedBox(height: 40,)
                    

                  ],
                ),
              
            
          );
  }
  String variableScan="scan";
  Widget scanType(){
    return Container(
      height: 48,
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Color.fromRGBO(241, 241, 241, 1)
        )
      ),
      child: Row(
        children: [
          scanTypePunkt("Человек","scan"),
          scanTypePunkt("Транспорт","ruch")
        ],
      ),
    );
  }
  Widget scanTypePunkt(String title,String type){
    return  Expanded(
        child: GestureDetector(
          onTap: () {
            setState(() {
              variableScan=type;
            });
          },
          child: Container( 
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: type==variableScan?Color.fromRGBO(241, 241, 241, 1):Colors.white
            ),
            alignment: Alignment.center,
            child: Text(
                      title,
                      style: TextStyle(
                        fontFamily: "No__",
                        fontSize: 20,
                        fontWeight: FontWeight.w500
                      ),
                    ),
          ),
        ),
    );
  }
}



class InfoModalAboutPeople extends StatefulWidget {
  final InformarionAboutPeople info;
  const InfoModalAboutPeople({super.key,required this.info});

  @override
  State<InfoModalAboutPeople> createState() => _InfoModalAboutPeopleState();
}

class _InfoModalAboutPeopleState extends State<InfoModalAboutPeople> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        height: MediaQuery.of(context).size.height-200,
        color: Colors.white,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(height: 40,),
            Container(
                height: 220,
                width: double.infinity,
                padding: EdgeInsets.only(left: 40,top: 40),
                decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color:widget.info.error.length==0?Color.fromRGBO(6, 203, 73, 1):Color.fromRGBO(241, 45, 45, 1)
                ),
                child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.info.fullInfo?.fullName??"Нет имени",
                style: TextStyle(
                  fontFamily: "Inter",
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Colors.white
                ),
              ),
              SizedBox(height: 12,),
              Container(
                height: 1,
                width: 222,
                color: Color.fromRGBO(213, 213, 213, 0.6),
              ),
              SizedBox(height: 12,),
              Text(
                "Пропуск № "+(widget.info.documentNumber??"Нет данных"),
                style: TextStyle(
                  fontFamily: "Inter",
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Colors.white
                ),
              ),
              SizedBox(height: 12,),
              Container(
                height: 1,
                width: 222,
                color: Color.fromRGBO(213, 213, 213, 0.6),
              ),
              SizedBox(height: 12,),
              Text(
                widget.info.fullInfo?.organization??"Нет организации",
                style: TextStyle(
                  fontFamily: "Inter",
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Colors.white
                ),
              ),
             
            ],
                ),
              ),
              SizedBox(height: 40,),
              for(var element in widget.info.error)
              Container(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    element,
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 22
                    ),
                  )
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child:actionButton("Скрыть",Colors.green,(){
                    Navigator.pop(context);
                  }),
                )
              ),
              SizedBox(height: 40,)
          ],
        ),
      )
    );
  }
}


class ScanSelf extends StatefulWidget {
  final String currentPeople;
  const ScanSelf({super.key,required this.currentPeople});

  @override
  State<ScanSelf> createState() => _ScanSelfState();
}

class _ScanSelfState extends State<ScanSelf> {


  String numberPass="";

  void toCheck(String number){
    numberPass=number;
    setState(() {
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12)
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            
            SizedBox(height: 20,),
            Observer(
              builder: (context) {
                return Text(
                  transportStore.currentPeople,
                  style: TextStyle(
                    fontFamily: "No__",
                    fontSize: 22,
                    fontWeight: FontWeight.w500
                  ),
                );
              }
            ),
            SizedBox(height: 40,),
           numberPass.isEmpty?Scaning(toCheck: toCheck):CheckPageInTransport(documentNumber: numberPass, toScan: (){
            setState(() {
              numberPass='';
            });
           }),
          ],
        ),
      ),
    );
  }
}



class CheckPageInTransport extends StatefulWidget {
  final Function() toScan; 
  final String documentNumber;
  const CheckPageInTransport({super.key,required this.documentNumber,required this.toScan});

  @override
  State<CheckPageInTransport> createState() => _CheckPageInTransportState();
}

class _CheckPageInTransportState extends State<CheckPageInTransport> {


    bool finding=true;

  List<String> errors=[];
  bool requiredAction=false;
  FullInfo? info;
  String role="";
  void findDocument()async{
    String _role=await RoleStorage().getRole();
    role=_role;
    final result= await dataBase.search(widget.documentNumber);
    if(result!=null){
      setState(() {
        info=result;
      });
    }else{
      errors.add("Пропуск не найден");      
    }
    setState(() {
      finding=false;
    });
  }
  @override
  void initState() {
    findDocument();
    super.initState();
  }


  void addPeople(){
    final infoForUpdate= InformarionAboutPeople(documentNumber: widget.documentNumber)
      ..fullInfo=info
      ..error=errors;
    
    transportStore.updatePeople(infoForUpdate);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 24,),
                
                      Expanded(
                        child: Builder(
                          builder: (context) {
                            if(finding){
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }else{
                              return Column(
                                children: [
                                  SizedBox(height: 60,),
                                  personInfo(),
                                  SizedBox(height: 32,),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Builder(
                                        builder: (context) {
                                          if(errors.isNotEmpty){
                                            return Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                for(var element in errors)
                                                Container(
                                                  child: Align(
                                                    alignment: Alignment.centerLeft,
                                                    child: Text(
                                                      element,
                                                      style: TextStyle(
                                                        color: Colors.red,
                                                        fontSize: 22
                                                      ),
                                                    )
                                                  ),
                                                )
                                              ],
                                            );
                                          }
                                          return SizedBox();
                                        },
                                      ),
                                      SizedBox(height: 40,),
                                      actionButton("Добавить в список",Color.fromRGBO(59, 130, 246, 1),addPeople),
                                      SizedBox(height: 40,),
                                      actionButton("Отмена",Colors.green,(){
                                        Navigator.pop(context);
                                      })
                                    ],
                                  )
                                  
                                ],
                              );
                            }
                          },
                        ),
                      )
                    ],
                    
                  ),
      ),
    );
  }


 Widget actionButton(String title,Color color,Function() action){
    return GestureDetector(
      onTap: action, 
      child: Container(
        height: 56,
        alignment: Alignment.center,
        width: double.infinity,
        decoration: BoxDecoration(
          color:color,
          borderRadius: BorderRadius.circular(12)
        ),
        child: Text(
            title,
            style: TextStyle(
              fontFamily: "Inter",
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.white
            ),
          ),
      ),
    );
  }
   Widget itemInfo(String title, String? data){
    print(data);
    return Container(
      alignment: Alignment.centerLeft,
      child: Text(
              title+": "+(data??"-"),
              style: TextStyle(
                fontFamily: "Inter",
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.black
              ),
            ),
    );
  }
  Widget personInfo(){
  return Container(
    height: 220,
    width: double.infinity,
    padding: EdgeInsets.only(left: 40,top: 40),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      color: errors.length==0?Color.fromRGBO(6, 203, 73, 1):Color.fromRGBO(241, 45, 45, 1)
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          info?.fullName??"Нет имени",
          style: TextStyle(
            fontFamily: "Inter",
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: Colors.white
          ),
        ),
        SizedBox(height: 12,),
        Container(
          height: 1,
          width: 222,
          color: Color.fromRGBO(213, 213, 213, 0.6),
        ),
        SizedBox(height: 12,),
        Text(
          "Пропуск № "+widget.documentNumber,
          style: TextStyle(
            fontFamily: "Inter",
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: Colors.white
          ),
        ),
        SizedBox(height: 12,),
        Container(
          height: 1,
          width: 222,
          color: Color.fromRGBO(213, 213, 213, 0.6),
        ),
        SizedBox(height: 12,),
        Text(
          info?.organization??"Нет организации",
          style: TextStyle(
            fontFamily: "Inter",
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: Colors.white
          ),
        ),

      ],
    ),
  );
}
}


Widget actionButton(String title,Color color,Function() action){
    return GestureDetector(
      onTap: action, 
      child: Container(
        height: 56,
        alignment: Alignment.center,
        width: double.infinity,
        decoration: BoxDecoration(
          color:color,
          borderRadius: BorderRadius.circular(12)
        ),
        child: Text(
            title,
            style: TextStyle(
              fontFamily: "Inter",
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.white
            ),
          ),
      ),
    );
  }