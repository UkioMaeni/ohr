import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:mobx/mobx.dart';
import 'package:secure_kpp/db/sqllite.dart';
import 'package:secure_kpp/models/jurnal.dart';
import 'package:secure_kpp/pages/main_page/store/transport_store.dart';
import 'package:secure_kpp/pages/main_page/tabs/scan_tab/conponents/transport_scan.dart';
import 'package:secure_kpp/pages/main_page/tabs/scan_tab/pages/check.dart';
import 'package:secure_kpp/storage/role_storeage.dart';
import 'package:secure_kpp/store/store.dart';

class ModalInput extends StatefulWidget {
  const ModalInput({super.key});

  @override
  State<ModalInput> createState() => _ModalInputState();
}

class _ModalInputState extends State<ModalInput> {

  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
   _controller.dispose();
    super.dispose();
  }


  String page="input";


  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12)
        ),
        padding: EdgeInsets.symmetric(horizontal: 10),
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
            page=="input"?
            Column(
              children: [
                SizedBox(height: 50,),
                input(_controller),
                SizedBox(height: 40,),
                actionButton("Проверить", Colors.green, (){
                  if(transportStore.currentPeople=="Автомобиль"){
                    transportStore.updatePeople(InformarionAboutPeople(documentNumber: _controller.text));
                    Navigator.pop(context);
                  }else{
                    setState(() {
                      page="check";
                    });
                  }

                })
              ],
            ):
            CheckPageInTransport(documentNumber: _controller.text,toScan: () {
              setState(() {
                page="scan";
              });
            },)
            
          ],
        ),
      ),
    );
  }
}


class TransportRuchnoi extends StatefulWidget {
  const TransportRuchnoi({super.key});

  @override
  State<TransportRuchnoi> createState() => _TransportRuchnoiState();
}

class _TransportRuchnoiState extends State<TransportRuchnoi> {

  void inputNumber(){
    showDialog(
      context: context, 
      builder: (context) {
        return Dialog(child: ModalInput(),insetPadding: EdgeInsets.zero,);
      },
    );
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
final TextEditingController _controller =TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

bool requiredAction=false;
  @override
  Widget build(BuildContext context) {
    return Observer(
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
        return Expanded(
          child: ListView(
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
                                                            inputNumber();
                                                          },
                                                          child: Container(
                                                            margin: EdgeInsets.symmetric(vertical: 5),
                                                            alignment: Alignment.center,
                                                            decoration: BoxDecoration(
                                                              color: Color.fromRGBO(168, 201, 255, 1),
                                                              borderRadius: BorderRadius.circular(12)
                                                            ),
                                                            child: Text(
                                                                "Ввести",
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
                                    ////ввод водимлы
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
                                                                  inputNumber();
                                                              
                                                                
                                                              },
                                                              child: Container(
                                                                margin: EdgeInsets.symmetric(vertical: 5),
                                                                alignment: Alignment.center,
                                                                decoration: BoxDecoration(
                                                                  color: Color.fromRGBO(168, 201, 255, 1),
                                                                  borderRadius: BorderRadius.circular(12)
                                                                ),
                                                                child: Text(
                                                                    "Ввести",
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
                                                                    color: Color.fromARGB(255, 221, 118, 111),
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
                                    ///////ввод людей
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
                                                          inputNumber();
                                                        },
                                                        child: Container(
                                                          margin: EdgeInsets.symmetric(vertical: 5),
                                                          alignment: Alignment.center,
                                                          decoration: BoxDecoration(
                                                            color: Color.fromRGBO(168, 201, 255, 1),
                                                            borderRadius: BorderRadius.circular(12)
                                                          ),
                                                          child: Text(
                                                              "Ввести",
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
                                                      return Container(
                                                        margin: EdgeInsets.symmetric(vertical: 5),
                                                          alignment: Alignment.center,
                                                          decoration: BoxDecoration(
                                                            color: Color.fromARGB(255, 221, 118, 111),
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
                                                                          color: Colors.white,
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
                          ///экшены
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
          ),
        );
      }
    );
  }
}



class ScaningRuchnoi extends StatefulWidget {
  const ScaningRuchnoi({super.key});

  @override
  State<ScaningRuchnoi> createState() => _ScaningRuchnoiState();
}

class _ScaningRuchnoiState extends State<ScaningRuchnoi> {

  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          SizedBox(height: 48,),
            scanType(),
            SizedBox(height: 32,),
            Builder(
              builder: (context) {
                if(variableScan=="scan"){
                  return Column(
                    children: [
                      input(_controller),
                      SizedBox(height: 40,),
                      actionButton("Проверить", Colors.green, (){
                        showDialog(
                          context: context, builder: (context) {
                            return Container(
                              color: Colors.white,
                              child: CheckPage(documentNumber: _controller.text,toScan: () {
                                Navigator.pop(context);
                              },),
                            );
                          },
                        );
                      })
                    ],
                  );
                  
                }
                return TransportRuchnoi();
              },
            ),
            
            SizedBox(height: 30,),
            //button("Проверить",widget.toCheck)
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
      child: Builder(
        builder: (context) {
          if(RoleStorage.role=="special"){
            return scanTypePunkt("Персонал","scan");
          }
          return Row(
            children: [
              scanTypePunkt("Персонал","scan"),
              scanTypePunkt("Транспорт","Transport"),
            ],
          );
        }
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

  Widget button(String title, Function(String) onClick){
    return GestureDetector(
      onTap: ()=>onClick(_controller.text),
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

Widget input(TextEditingController _controller){
    return Container(
      height: 56,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(
          color: Color.fromRGBO(198, 198, 198, 1),
        ),
        borderRadius: BorderRadius.circular(12)
      ),
      alignment: Alignment.center,
      child: TextField(
              controller: _controller,
              style: 
              TextStyle(
                  fontFamily: "No__",
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                
                contentPadding: EdgeInsets.only(left: 20,right: 20,bottom: 0,top: 0),
                border: InputBorder.none,
                hintText: "Номер пропуска",
                hintStyle: TextStyle(
                  fontFamily: "No__",
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: Color.fromRGBO(128, 128, 128, 1)
                )
              ),
            ),
    );
  }