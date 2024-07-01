import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:mobx/mobx.dart';
import 'package:secure_kpp/db/sqllite.dart';
import 'package:secure_kpp/models/full_info.dart';
import 'package:secure_kpp/models/jurnal.dart';
import 'package:secure_kpp/pages/main_page/store/transport_store.dart';
import 'package:secure_kpp/pages/main_page/tabs/scan_tab/conponents/scaning.dart';
import 'package:secure_kpp/pages/main_page/tabs/ruchnoi_tab/scaning_ruchnoi.dart';
import 'package:secure_kpp/pages/main_page/tabs/scan_tab/pages/check.dart';
import 'package:secure_kpp/storage/role_storeage.dart';
import 'package:secure_kpp/store/store.dart';

class ScanTransportPage extends StatefulWidget {
  final Function(String) toCheck;
  const ScanTransportPage({super.key,required this.toCheck});

  @override
  State<ScanTransportPage> createState() => _ScanTransportPageState();
}

class _ScanTransportPageState extends State<ScanTransportPage> {


 final TextEditingController _controller =TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void showModal(){

    showDialog(
      context: context, 
      builder: (context) {
        return ScanSelf(currentPeople: "",);
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
bool requiredAction=false;
  @override
  Widget build(BuildContext context) {



    return  Expanded(
                child: Observer(
                  builder: (context) {
                    bool isErrors=false;
                    final carInfo=transportStore.carInfo;
                    if(carInfo!=null&& carInfo.error.isNotEmpty){
                      isErrors=true;
                    }
                    final driverInfo=transportStore.driverInfo;
                    
                    if(driverInfo!=null&& driverInfo.error.isNotEmpty){
                      print("Есть ошибка");
                      isErrors=true;
                    }
                    final peopleInfo=transportStore.peopleInfo;
                    peopleInfo.forEach((element){
                      if(element!=null&& element.error.isNotEmpty){
                        isErrors=true;
                      }
                    });
                    return ListView(
                      children: [
                         Column(
                          
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Автомобиль",
                                    style: TextStyle(
                                      fontFamily: "No__",
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 80,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.black,
                                      width: 2
                                    )
                                  ),
                                  child: Row(
                                          children: [
                                            SizedBox(
                                              width: 80,
                                              height: 80,
                                              child: Icon(Icons.car_repair,size: 40)
                                            ),
                                            Expanded(
                                              child: Observer(
                                                builder: (context) {
                                                  if(transportStore.carInfo==null){
                                                    return GestureDetector(
                                                      onTap: () {
                                                        transportStore.currentPeople="Автомобиль";
                                                        showModal();
                                                      },
                                                      child: Container(
                                                        margin: EdgeInsets.symmetric(vertical: 5),
                                                        alignment: Alignment.center,
                                                        decoration: BoxDecoration(
                                                          color: Color.fromRGBO(168, 201, 255, 1),
                                                          borderRadius: BorderRadius.circular(12)
                                                        ),
                                                        child: Text(
                                                            "Сканировать",
                                                            style: TextStyle(
                                                              fontFamily: "No__",
                                                              fontSize: 20,
                                                              fontWeight: FontWeight.w500
                                                            ),
                                                          ),
                                                      ),
                                                    );
                                                  }
                                                  return Container(
                                                        margin: EdgeInsets.symmetric(vertical: 5),
                                                        alignment: Alignment.center,
                                                        decoration: BoxDecoration(
                                                          color: Colors.green,
                                                          borderRadius: BorderRadius.circular(12)
                                                        ),
                                                        child: Text(
                                                            transportStore.carInfo!.documentNumber,
                                                            style: TextStyle(
                                                              fontFamily: "No__",
                                                              fontSize: 20,
                                                              fontWeight: FontWeight.w500
                                                            ),
                                                          ),
                                                      );
                                                },
                                              )
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                transportStore.carInfo=null;
                                                setState(() {
                                                  
                                                });
                                              },
                                              child: SizedBox(
                                                width: 80,
                                                height: 80,
                                                child: Icon(Icons.close,color: const Color.fromARGB(255, 196, 62, 53),size: 40,),
                                              ),
                                            ),
                                            
                                          ],
                                        ),
                                )
                              ],
                            ),
                          if(transportStore.carInfo!=null)
                          Container(
                            height: 80,
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black,
                                  width: 2
                                )
                              ),
                            child: Row(
                              children: [
                                SizedBox(width: 10,),
                                Text(
                                  "ТТН:",
                                  style: TextStyle(
                                    fontFamily: "No__",
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.symmetric(horizontal: 20),
                                    height: 50,
                                    decoration:  BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          width: 1
                                        )
                                      )
                                    ),
                                    child: TextField(
                                      controller: _controller,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Например, 51886186"
                                      ),
                                    ),
                                  )
                                ),
                              ],
                            ),
                          ),
                        
                        //////////////////////авто
                          if(transportStore.carInfo!=null) Column(
                          children: [
                            Text(
                              "Водитель",
                              style: TextStyle(
                                fontFamily: "No__",
                                fontSize: 20,
                                fontWeight: FontWeight.w500
                              ),
                            ),
                            Container(
                              height: 80,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black,
                                  width: 2
                                )
                              ),
                              child: Row(
                                      children: [
                                        SizedBox(
                                          width: 80,
                                          height: 80,
                                          child: Icon(Icons.person_4,size: 40)
                                        ),
                                        Expanded(
                                          child: Observer(
                                            builder: (context) {
                                              if(transportStore.driverInfo==null){
                                                return GestureDetector(
                                                  onTap: () {
                                                    
                                                      transportStore.currentPeople="Водитель";
                                                      showModal();
                                                   
                                                    
                                                  },
                                                  child: Container(
                                                    margin: EdgeInsets.symmetric(vertical: 5),
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                      color: Color.fromRGBO(168, 201, 255, 1),
                                                      borderRadius: BorderRadius.circular(12)
                                                    ),
                                                    child: Text(
                                                        "Сканировать",
                                                        style: TextStyle(
                                                          fontFamily: "No__",
                                                          fontSize: 20,
                                                          fontWeight: FontWeight.w500
                                                        ),
                                                      ),
                                                  ),
                                                );
                                              }
                                              
                                              if(transportStore.driverInfo!.error.isNotEmpty){
                                                return GestureDetector(
                                                  onTap: () {
                                                    showInfo(transportStore.driverInfo!);
                                                  },
                                                  child: Container(
                                                    margin: EdgeInsets.symmetric(vertical: 5),
                                                      alignment: Alignment.center,
                                                      decoration: BoxDecoration(
                                                        color: transportStore.driverInfo!.error[0]=="Не найдено"?Colors.grey: Color.fromARGB(255, 221, 118, 111),
                                                        borderRadius: BorderRadius.circular(12)
                                                      ),
                                                      child: Builder(
                                                        builder: (context) {
                                                          if(transportStore.driverInfo!.fullInfo==null){
                                                            return Text(
                                                                    transportStore.driverInfo!.documentNumber,
                                                                    textAlign: TextAlign.center,
                                                                    style: TextStyle(
                                                                      fontFamily: "No__",
                                                                      fontSize: 20,
                                                                      color:  Colors.black,
                                                                      fontWeight: FontWeight.w500
                                                                    ),
                                                                  );
                                                              
                                                          }
                                                          return    Text(
                                                                    (transportStore.driverInfo!.fullInfo!.fullName??"")+"\n"+
                                                                    transportStore.driverInfo!.documentNumber,
                                                                    textAlign: TextAlign.center,
                                                                    style: TextStyle(
                                                                      fontFamily: "No__",
                                                                      fontSize: 20,
                                                                      color:  Colors.black,
                                                                      fontWeight: FontWeight.w500
                                                                    ),
                                                                  ); 
                                                        },
                                                      ),
                                                  ),
                                                );
                                              }
                                              return Container(
                                                margin: EdgeInsets.symmetric(vertical: 5),
                                                decoration: BoxDecoration(
                                                      color: Colors.green,
                                                      borderRadius: BorderRadius.circular(12)
                                                    ),
                                                child: Column(
                                                  crossAxisAlignment:CrossAxisAlignment.center ,
                                                  children: [
                                                    Text(
                                                      (transportStore.driverInfo!.fullInfo?.fullName??"")+"\n"+
                                                      transportStore.driverInfo!.documentNumber,
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                        fontFamily: "No__",
                                                        fontSize: 20,
                                                        fontWeight: FontWeight.w500
                                                      ),
                                                    ) 
                                                  ],
                                                ),
                                              );
                                            },
                                          )
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                                transportStore.driverInfo=null;
                                                setState(() {
                                                  
                                                });
                                              },
                                          child: SizedBox(
                                            width: 80,
                                            height: 80,
                                            child: Icon(Icons.close,color: const Color.fromARGB(255, 196, 62, 53),size: 40,),
                                          ),
                                        ),
                                        
                                      ],
                                    ),
                            )
                          ],
                        ),
                      ///////////////peoplea
                      if(transportStore.driverInfo!=null)
                        Column(
                          children: [
                            for(var i=0;i< transportStore.peopleInfo.length;i++)
                            Column(
                            children: [
                              Text(
                                "Пассажир ${i+1}",
                                style: TextStyle(
                                  fontFamily: "No__",
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500
                                ),
                              ),
                              Container(
                                height: 80,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 2
                                  )
                                ),
                                child: Row(
                                        children: [
                                          SizedBox(
                                            width: 80,
                                            height: 80,
                                            child: Icon(Icons.person_4,size: 40)
                                          ),
                                          Expanded(
                                            child: Observer(
                                              builder: (context) {
                                                if(transportStore.peopleInfo[i]==null){
                                                  return GestureDetector(
                                                    onTap: () {
                                                      transportStore.currentPeople="Пассажир ${i+1}";
                                                      showModal();
                                                    },
                                                    child: Container(
                                                      margin: EdgeInsets.symmetric(vertical: 5),
                                                      alignment: Alignment.center,
                                                      decoration: BoxDecoration(
                                                        color: Color.fromRGBO(168, 201, 255, 1),
                                                        borderRadius: BorderRadius.circular(12)
                                                      ),
                                                      child: Text(
                                                          "Сканировать",
                                                          style: TextStyle(
                                                            fontFamily: "No__",
                                                            fontSize: 20,
                                                            fontWeight: FontWeight.w500
                                                          ),
                                                        ),
                                                    ),
                                                  );
                                                }
                                                
                                                if(transportStore.peopleInfo[i]!.error.isNotEmpty){
                                                  print(transportStore.peopleInfo[i]!.error.isNotEmpty);
                                                  return Container(
                                                    margin: EdgeInsets.symmetric(vertical: 5),
                                                      alignment: Alignment.center,
                                                      decoration: BoxDecoration(
                                                        color:transportStore.peopleInfo[i]!.error[0] =="Не найдено"?Colors.grey: Color.fromARGB(255, 221, 118, 111),
                                                        borderRadius: BorderRadius.circular(12)
                                                      ),
                                                      child: Builder(
                                                        builder: (context) {
                                                          if(transportStore.peopleInfo[i]!.fullInfo==null){
                                                            return Text(
                                                                    transportStore.peopleInfo[i]!.documentNumber,
                                                                    style: TextStyle(
                                                                      fontFamily: "No__",
                                                                      fontSize: 20,
                                                                      fontWeight: FontWeight.w500
                                                                    ),
                                                                  );
                                                              
                                                          }
                                                          return    Text(
                                                                    (transportStore.peopleInfo[i]!.fullInfo!.fullName??"")+"\n"+
                                                                    transportStore.peopleInfo[i]!.documentNumber,
                                                                    style: TextStyle(
                                                                      fontFamily: "No__",
                                                                      fontSize: 20,
                                                                      color: Colors.white,
                                                                      fontWeight: FontWeight.w500
                                                                    ),
                                                                  ); 
                                                        },
                                                      ),
                                                  );
                                                }
                                                return Container(
                                                  margin: EdgeInsets.symmetric(vertical: 5),
                                                  decoration: BoxDecoration(
                                                        color: Colors.green,
                                                        borderRadius: BorderRadius.circular(12)
                                                      ),
                                                  child: Column(
                                                    crossAxisAlignment:CrossAxisAlignment.center ,
                                                    children: [
                                                      Text(
                                                        (transportStore.peopleInfo[i]!.fullInfo?.fullName??"")+"\n"+
                                                        transportStore.driverInfo!.documentNumber,
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                          fontFamily: "No__",
                                                          fontSize: 20,
                                                          fontWeight: FontWeight.w500
                                                        ),
                                                      ) 
                                                    ],
                                                  ),
                                                );
                                              },
                                            )
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              List<InformarionAboutPeople?> newList=[];
                                              for(int j=0;j<transportStore.peopleInfo.length;j++){
                                                if(j!=i){
                                                  newList.add(transportStore.peopleInfo[j]);
                                                }
                                              }
                                                transportStore.peopleInfo=ObservableList.of(newList);
                                                setState(() {
                                                  
                                                });
                                              },
                                            child: SizedBox(
                                              width: 80,
                                              height: 80,
                                              child: Icon(Icons.close,color: const Color.fromARGB(255, 196, 62, 53),size: 40,),
                                            ),
                                          ),
                                          
                                        ],
                                      ),
                              )
                            ],
                          ),
                        ],
                      ),
                        SizedBox(height: 24,),
                        if(driverInfo!=null) actionButton("Вход",isErrors&&!requiredAction?Color.fromRGBO(6, 203, 73, 1).withAlpha(100): Color.fromRGBO(6, 203, 73, 1),()async{
                          DateTime now = DateTime.now();
                          String formattedDate = DateFormat('dd.MM.yyyy').format(now);
                          String formattedTime = DateFormat('HH:mm').format(now);
                          if(transportStore.carInfo==null){
                            return;
                          }
                          if(transportStore.driverInfo!=null ){
                            final jurnal=Jurnal(
                                kpp: appStore.kpp, 
                                date: formattedDate, 
                                time: formattedTime, 
                                numberPassTS: transportStore.carInfo==null?null:transportStore.carInfo!.documentNumber, 
                                numberPassDriver: transportStore.driverInfo==null?null:transportStore.driverInfo!.documentNumber, 
                                numberPassPassanger: transportStore.driverInfo==null?null:transportStore.driverInfo!.documentNumber, 
                                inputObject: "ДА", 
                                outputObject: null,
                                ttn: _controller.text,
                                errors: transportStore.driverInfo!.error.join(",")
                              );
                              await dataBase.updateFullInfo(transportStore.driverInfo!.fullInfo!, "input");
                              await dataBase.insertJurnal(jurnal);
                          }
                          for( var people in transportStore.peopleInfo){
                            if(people!=null){
                              final jurnal= Jurnal(
                                kpp: appStore.kpp, 
                                date: formattedDate, 
                                time: formattedTime, 
                                numberPassTS: transportStore.carInfo==null?null:transportStore.carInfo!.documentNumber, 
                                numberPassDriver: transportStore.driverInfo==null?null:transportStore.driverInfo!.documentNumber, 
                                numberPassPassanger: people.documentNumber, 
                                inputObject: "ДА", 
                                outputObject: null,
                                ttn: _controller.text,
                                errors: people.error.join(",")
                              );
                              await dataBase.updateFullInfo(people.fullInfo!, "input");
                              await dataBase.insertJurnal(jurnal);
                            }
                            
                          }
                          await showDialog(
                            context: context, builder: (context) {
                              return Dialog(
                                child: SizedBox(
                                  height: 170,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 20),
                                    child: Column(
                                      children: [
                                        SizedBox(height: 10,),
                                        Text(
                                        "Запись добавлена",
                                        style: TextStyle(
                                          fontFamily: "No__",
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500
                                        ),
                                      ),
                                      SizedBox(height: 50,),
                                      actionButton("ОК", Colors.green, (){
                                        Navigator.pop(context);
                                      }),
                                      SizedBox(height: 10,),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                          transportStore.carInfo=null;
                          transportStore.driverInfo=null;
                          transportStore.peopleInfo=ObservableList.of([null]);
                                              
                        }),
                        SizedBox(height: 24,),
                        if(driverInfo!=null) actionButton("Выход",isErrors&&!requiredAction?Color.fromRGBO(59, 130, 246, 1).withAlpha(100): Color.fromRGBO(59, 130, 246, 1),()async{
                          DateTime now = DateTime.now();
                          String formattedDate = DateFormat('dd.MM.yyyy').format(now);
                          String formattedTime = DateFormat('HH:mm').format(now);
                          if(transportStore.carInfo==null){
                            return;
                          }
                          if(transportStore.driverInfo!=null){
                            final jurnal=Jurnal(
                                kpp: appStore.kpp, 
                                date: formattedDate, 
                                time: formattedTime, 
                                numberPassTS: transportStore.carInfo==null?null:transportStore.carInfo!.documentNumber, 
                                numberPassDriver: transportStore.driverInfo==null?null:transportStore.driverInfo!.documentNumber, 
                                numberPassPassanger: transportStore.driverInfo==null?null:transportStore.driverInfo!.documentNumber, 
                                inputObject: null, 
                                outputObject: "ДА",
                                ttn: _controller.text,
                                errors: transportStore.driverInfo!.error.join(",")
                              );
                              await dataBase.updateFullInfo(transportStore.driverInfo!.fullInfo!, "output");
                              await dataBase.insertJurnal(jurnal);
                          }
                          for( var people in transportStore.peopleInfo){
                            if(people!=null){
                              final jurnal= Jurnal(
                                kpp: appStore.kpp, 
                                date: formattedDate, 
                                time: formattedTime, 
                                numberPassTS: transportStore.carInfo==null?null:transportStore.carInfo!.documentNumber, 
                                numberPassDriver: transportStore.driverInfo==null?null:transportStore.driverInfo!.documentNumber, 
                                numberPassPassanger: people.documentNumber, 
                                inputObject: null, 
                                outputObject: "ДА",
                                ttn: _controller.text,
                                errors: people.error.join(",")
                              );
                              await dataBase.updateFullInfo(people.fullInfo!, "output");
                              await dataBase.insertJurnal(jurnal);
                            }
                            
                          }
                          await showDialog(
                            context: context, builder: (context) {
                              return Dialog(
                                child: SizedBox(
                                  height: 170,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 20),
                                    child: Column(
                                      children: [
                                        SizedBox(height: 10,),
                                        Text(
                                        "Запись добавлена",
                                        style: TextStyle(
                                          fontFamily: "No__",
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500
                                        ),
                                      ),
                                      SizedBox(height: 50,),
                                      actionButton("ОК", Colors.green, (){
                                        Navigator.pop(context);
                                      }),
                                      SizedBox(height: 10,),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                          transportStore.carInfo=null;
                          transportStore.driverInfo=null;
                          transportStore.peopleInfo=ObservableList.of([null]);
                        }),
                        SizedBox(height: 24,),
                        !isErrors||driverInfo==null?SizedBox.shrink():
                         Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  requiredAction=!requiredAction;
                                });
                              },
                              child: Container(
                                width: 25,
                                height: 25,
                                padding: EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black
                                  ),
                                  borderRadius: BorderRadius.circular(25)
                                ),
                                alignment: Alignment.center,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: requiredAction?Color.fromRGBO(59, 130, 246, 1):Colors.white,
                                    borderRadius: BorderRadius.circular(25)
                                  ),
                                  
                                ),
                              ),
                            ),
                            SizedBox(width: 12,),
                            Text(
                              "Выполнить в  любом случае",
                              style: TextStyle(
                                fontFamily: "Inter",
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 40,),
                      ],
                    );
                  }
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
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    element,
                    style: TextStyle(
                      height: 0.8,
                      color: Colors.red,
                      fontSize: 14
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
  List<DateWithInfo> dateWithInfo=[];
  List<DateWithInfo> otherData=[];
  List<DateWithInfo> karkas=[];
  DateWithInfo? passDate;
  DateWithInfo? passStatus;
  DateWithInfo?  lastDate;
  List<DateWithInfo> outputErrors=[];
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
      parsedInfo(result);

    }else{
      errors.add("Пропуск не найден");      
    }
    setState(() {
      finding=false;
    });
  }
  @override
  void initState() {
    if(transportStore.currentPeople!="Автомобиль"){
      findDocument();
    }
    
    super.initState();
  }
  String fullSignal="grey";
  parsedInfo(FullInfo info)async{
    fullSignal="green";

    // dateWithInfo.add(dateParserWithSignal(info.medical,"Медицинский осмотр"));
    // dateWithInfo.add(dateParserWithSignal(info.promSecure,"Промышленная безопасность"));
    // dateWithInfo.add(dateParserWithSignal(info.infoSecure,"Поргружение в \nпроизводственную безопасность"));
    // dateWithInfo.add(dateParserWithSignal(info.workSecure,"Охрана труда"));
    // dateWithInfo.add(dateParserWithSignal(info.medicalHelp,"Первая помощь"));
    // dateWithInfo.add(dateParserWithSignal(info.fireSecure,"Противопожарная безопасность"));
    // dateWithInfo.add(dateParserWithSignal(info.electroSecure,"Электробезопасность"));
    // dateWithInfo.add(dateParserWithSignal(info.winterDriver,"Защитное зимнее вождение"));
    // dateWithInfo.add(dateParserWithSignal(info.workInHeight,"ВЫСОТА"));
    
    // dateWithInfo.add(dateParserWithSignal(info.VOZTest,"Дата ВОЗ"));
    // dateWithInfo.add(dateParserWithSignal(info.fireSecure,"Противопожарная безопасность"));
    // print(info.infoSecure.toString()+"///////////////////////////");
    // dateWithInfo.add(DateWithInfo(date: info.promSecureOblast??"Данные отстутствуют",name:"Промышленная безопасность\n(области аттестации)",signal: info.promSecureOblast==null?"grey":"green"));
    // dateWithInfo.add(DateWithInfo(date: info.electroSecureGroup??"Данные отстутствуют",name:"Электробезопасность(группа)",signal: info.electroSecureGroup==null?"grey":"green"));
    // dateWithInfo.forEach((element) { 
    //   if(element.signal=="red"){

    //     fullSignal="red";
    //     outputErrors.add(element);
    //   }
    // });
    // otherData.add(DateWithInfo(date: info.driverPermit??"Данные отстутствуют",name:"Право управления ТС",signal: info.driverPermit==null?"grey":"green"));
    // otherData.add(DateWithInfo(date: info.workInHeightGroup??"Данные отстутствуют",name:"ВЫСОТА(группа)",signal: info.workInHeightGroup==null?"grey":"green"));

    // otherData.add(dateParserWithSignal(info.GPVPGroup,"ГПВП - Бригады ТКРС/ТРС "));
    // otherData.add(dateParserWithSignal(info.GNVPGroup,"ГНВП - Бригады бурения"));
    // otherData.forEach((element) { 
    //   if(element.signal=="red"){
    //     outputErrors.add(element);
    //     fullSignal="red";
    //   }
    // });
    // karkas.add(DateWithInfo(date: info.burAndVSR??"Данные отстутствуют",name:"Бурение и ВСР",signal: info.burAndVSR==null?"grey":"green"));
    // karkas.add(DateWithInfo(date: info.KSAndCMP??"Данные отстутствуют",name:"КС и СМР",signal: info.KSAndCMP==null?"grey":"green"));
    // karkas.add(DateWithInfo(date: info.transport??"Данные отстутствуют",name:"Транспорт",signal: info.transport==null?"grey":"green"));
    // karkas.add(DateWithInfo(date: info.energy??"Данные отстутствуют",name:"Энергетика",signal: info.energy==null?"grey":"green"));
    // karkas.add(DateWithInfo(date: info.GT??"Данные отстутствуют",name:"ГТ",signal: info.GT==null?"grey":"green"));
    // karkas.add(DateWithInfo(date: info.PPDU??"Данные отстутствуют",name:"ППДУ",signal: info.PPDU==null?"grey":"green"));
    // karkas.add(DateWithInfo(date: info.CA??"Данные отстутствуют",name:"ЦА",signal: info.CA==null?"grey":"green"));
    // karkas.add(DateWithInfo(date: info.KP_2??"Данные отстутствуют",name:"КП-2",signal: info.KP_2==null?"grey":"green"));
    // karkas.add(DateWithInfo(date: info.PB_11??"Данные отстутствуют",name:"РВ.11",signal: info.PB_11==null?"grey":"green"));
    // karkas.add(DateWithInfo(date: info.PB_12??"Данные отстутствуют",name:"РВ.12",signal: info.PB_12==null?"grey":"green"));
    // karkas.forEach((element) { 
    //   if(element.signal=="red"){
    //     outputErrors.add(element);
    //     fullSignal="red";
    //   }
    // });
    // passDate=dateParserWithSignal(info.passDate,"Срок действия пропуска",);
    // if(passDate!.signal=="red"){
    //   outputErrors.add(passDate!);
    //   fullSignal="red";
    // }
    String passSignal="grey";
    if(info.passStatus!=null&&info.passStatus!.trim()=="НЕ ДОПУЩЕН") passSignal="red";
    if(info.passStatus!=null&&info.passStatus!.trim()=="ДОПУЩЕН") passSignal="green";
    passStatus=DateWithInfo(date: info.passStatus??"Данные отсутствуют",name:"",signal: passSignal);
    if(passStatus!.signal=="red"){
      outputErrors.add(passStatus!);
      fullSignal="red";
    }
    //lastDate=dateParserWithSignal(info.lastInputDate,""); 
    
    // if(info.lastInputKPP!=null&&appStore.kpp!=null){
    //   final pars=info.lastInputKPP!.split(" ");
    //   if(pars.length==2){
    //     try {
          
    //       if(pars[1]==appStore.kpp&&){
    //         outputErrors.
    //       }
    //     } catch (e) {
          
    //     }
    //   }
    // }
    setState(() {
      
    });
  }

  void addPeople(){
    List<String> err=[];
    err=outputErrors.map((el)=>el.name).toList();
    err.addAll(errors);
    final infoForUpdate= InformarionAboutPeople(documentNumber: widget.documentNumber)
      ..fullInfo=info
      ..error=err;
    
    transportStore.updatePeople(infoForUpdate);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    if(transportStore.currentPeople=="Автомобиль"){
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Container(
                  height: 100,
                  width: double.infinity,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: fullSignal=="green"?Color.fromRGBO(6, 203, 73, 1):fullSignal=="grey"?Colors.grey: Color.fromRGBO(241, 45, 45, 1)
                  ),
                  child: Text(
                        "Пропуск № "+widget.documentNumber,
                        style: TextStyle(
                          fontFamily: "Inter",
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: Colors.white
                        ),
                      ),
                ),
                SizedBox(height: 40,),
                
                actionButton("Добавить в список",Color.fromRGBO(59, 130, 246, 1),addPeople),
                SizedBox(height: 20,),
                actionButton("Отмена",Colors.green,(){
                  Navigator.pop(context);
                }),
                SizedBox(height: 20,),
          ],
        ),
      );
    }
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          //crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 24,),
                
                      Builder(
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
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      element,
                                                      style: TextStyle(
                                                        color: Colors.grey,
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
                                      for(var element in outputErrors)
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          
                                            Text(
                                              element.date,
                                              style: TextStyle(
                                                height: 0.8,
                                                fontFamily: "Inter",
                                                fontSize: 20,
                                                fontWeight: FontWeight.w800,
                                                color: element.signal=="red"?Colors.red:Colors.grey
                                              ),
                                            ),
                                        ],
                                      ),
                                      SizedBox(height: 40,),
                                      actionButton("Добавить в список",Color.fromRGBO(59, 130, 246, 1),addPeople),
                                      SizedBox(height: 40,),
                                      actionButton("Отмена",Colors.green,(){
                                        Navigator.pop(context);
                                      }),
                                      SizedBox(height: 20,)
                                    ],
                                  )
                                  
                                ],
                              );
                            }
                          },
                        
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
      color: fullSignal=="green"?Color.fromRGBO(6, 203, 73, 1):fullSignal=="grey"?Colors.grey: Color.fromRGBO(241, 45, 45, 1)
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


  //tools
  DateWithInfo dateParserWithSignal(String? date,String descript){
    if(date==null){
      return DateWithInfo(date: "Данные отсутствуют", name: descript, signal: 'grey');
    }
    print(date);
    final splitDate=date.split("/");
    if(splitDate.length<3){
      return  DateWithInfo(date: "Неверная дата", name: descript, signal: 'grey');
    }
    splitDate[2]="20"+splitDate[2];
    date= splitDate.join(".");
    print(date);
    DateTime currentDate=DateTime.now();
    if(date.isEmpty||date=="-"||date==" "){
      return DateWithInfo(date: "Данные отсутствуют", name: descript, signal: 'grey');
    }
    DateTime? parse;
    try {
      parse=DateFormat("MM.dd.yyyy").parse(date);
      // print(parse.day);
      // print(parse.month);
      //parse=DateTime.parse(date);
    } catch (e) {
      print(e);
    }
    if(parse==null){
      return DateWithInfo(date: "Неверный формат даты", name: descript, signal: 'grey');
    }
    String formatedDate = DateFormat("dd.MM.yyyy").format(parse);
    if(currentDate.difference(parse).inDays<=30&&currentDate.difference(parse).inDays>=0){
      return DateWithInfo(date: formatedDate, name: descript, signal: 'yellow');
    }else if(parse.isBefore(currentDate)){
      return DateWithInfo(date: formatedDate, name: descript, signal: 'red');
    }
    return DateWithInfo(date: formatedDate, name: descript, signal: 'green');
  }