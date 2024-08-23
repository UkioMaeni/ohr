import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:secure_kpp/db/sqllite.dart';
import 'package:secure_kpp/models/full_info.dart';
import 'package:secure_kpp/models/jurnal.dart';
import 'package:secure_kpp/storage/role_storeage.dart';
import 'package:secure_kpp/store/store.dart';
import 'package:intl/intl.dart';

class DateWithInfo{
  String date;
  String name;
  String signal;
  DateWithInfo({
    required this.date,
    required this.name,
    required this.signal
  });
}


class CheckPage extends StatefulWidget {
  final String documentNumber;
  final Function() toScan;
  const CheckPage({super.key,required this.documentNumber,required this.toScan});

  @override
  State<CheckPage> createState() => _CheckPageState();
}

class _CheckPageState extends State<CheckPage> {


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
      parsedInfo(result);
    }else{
      errors.add("Не найдено");      
    }
    setState(() {
      finding=false;
    });
  }

  String fullSignal="grey";


  List<String> professionals=[];
  List<String> VOZprofessionals=[];
  List<DateWithInfo> dateWithInfo=[];
  List<DateWithInfo> otherData=[];
  List<DateWithInfo> karkas=[];
  List<DateWithInfo> outputErrors=[];
  DateWithInfo? passDate;
  DateWithInfo? passStatus;
  DateWithInfo?  lastDate;
  String lastKpp="Нет данных";
  String lastVector="Нет данных";
  parsedInfo(FullInfo info)async{
    fullSignal="green";

    String passSignal="grey";
    if(info.passStatus!=null&&info.passStatus!.trim()=="НЕ ДОПУЩЕН") passSignal="red";
    if(info.passStatus!=null&&info.passStatus!.trim()=="ДОПУЩЕН") passSignal="green";
    passStatus=DateWithInfo(date: info.passStatus??"Данные отсутствуют",name:"",signal: passSignal);
    if(passStatus!.signal=="red"){
      outputErrors.add(passStatus!);
      fullSignal="red";
    }

    if(role.contains("kpp")){
      return;
    }
    if(info.professionals!=null){
      professionals= info.professionals!.split("/");
    }
    if(info.VOZProfessional!=null){
      VOZprofessionals=info.VOZProfessional!.split("/");
    }
    
    dateWithInfo.add(dateParserWithSignal(info.medical,"Медицинский осмотр",null));
    dateWithInfo.add(dateParserWithSignal(info.promSecure,"Промышленная безопасность",info.promSecureOblast==null?null:info.promSecureOblast));
    dateWithInfo.add(dateParserWithSignal(info.infoSecure,"Поргружение в\nпроизводственную безопасность",null));
    dateWithInfo.add(dateParserWithSignal(info.workSecure,"Охрана труда",null));
    dateWithInfo.add(dateParserWithSignal(info.medicalHelp,"Первая помощь",null));
    dateWithInfo.add(dateParserWithSignal(info.fireSecure,"Противопожарная безопасность",null));
    dateWithInfo.add(dateParserWithSignal(info.electroSecure,"Электробезопасность",info.electroSecureGroup==null?null:info.electroSecureGroup));
    otherData.add(dateParserWithSignal(info.winterDriver,"Защитное зимнее вождение",null));
    otherData.add(dateParserWithSignal(info.workInHeight,"ВЫСОТА",info.workInHeightGroup==null?null:info.workInHeightGroup!.trim()));
    
    dateWithInfo.add(dateParserWithSignal(info.VOZTest,"Дата ВОЗ",null));
    dateWithInfo.add(dateParserWithSignal(info.fireSecure,"Противопожарная безопасность",null));
    //dateWithInfo.add(DateWithInfo(date: info.promSecureOblast??"Данные отстутствуют",name:"Промышленная безопасность\n(области аттестации)",signal: info.promSecureOblast==null?"grey":"green"));
    //dateWithInfo.add(DateWithInfo(date: info.electroSecureGroup??"Данные отстутствуют",name:"Электробезопасность(группа)",signal: info.electroSecureGroup==null?"grey":"green"));
    dateWithInfo.forEach((element) { 
      if(element.signal=="red"){
        outputErrors.add(element);
        fullSignal="red";
      }
    });
    dateWithInfo.add(DateWithInfo(date: info.driverPermit??"Данные отстутствуют",name:"Право управления ТС",signal: info.driverPermit==null?"grey":"green"));
    //otherData.add(DateWithInfo(date: info.workInHeightGroup??"Данные отстутствуют",name:"ВЫСОТА(группа)",signal: info.workInHeightGroup==null?"grey":"green"));

    otherData.add(dateParserWithSignal(info.GPVPGroup,"ГПВП - Бригады ТКРС/ТРС ",null));
    otherData.add(dateParserWithSignal(info.GNVPGroup,"ГНВП - Бригады бурения",null));
    otherData.forEach((element) { 
      if(element.signal=="red"){
        outputErrors.add(element);
        fullSignal="red";
      }
    });
    karkas.add(DateWithInfo(date: info.burAndVSR??"Данные отстутствуют",name:"Бурение и ВСР",signal: info.burAndVSR==null?"grey":"green"));
    karkas.add(DateWithInfo(date: info.KSAndCMP??"Данные отстутствуют",name:"КС и СМР",signal: info.KSAndCMP==null?"grey":"green"));
    karkas.add(DateWithInfo(date: info.transport??"Данные отстутствуют",name:"Транспорт",signal: info.transport==null?"grey":"green"));
    karkas.add(DateWithInfo(date: info.energy??"Данные отстутствуют",name:"Энергетика",signal: info.energy==null?"grey":"green"));
    karkas.add(DateWithInfo(date: info.GT??"Данные отстутствуют",name:"ГТ",signal: info.GT==null?"grey":"green"));
    karkas.add(DateWithInfo(date: info.PPDU??"Данные отстутствуют",name:"ППДУ",signal: info.PPDU==null?"grey":"green"));
    karkas.add(DateWithInfo(date: info.CA??"Данные отстутствуют",name:"ЦА",signal: info.CA==null?"grey":"green"));
    karkas.add(DateWithInfo(date: info.KP_2??"Данные отстутствуют",name:"КП-2",signal: info.KP_2==null?"grey":"green"));
    karkas.add(DateWithInfo(date: info.PB_11??"Данные отстутствуют",name:"РВ.11",signal: info.PB_11==null?"grey":"green"));
    karkas.add(DateWithInfo(date: info.PB_12??"Данные отстутствуют",name:"РВ.12",signal: info.PB_12==null?"grey":"green"));
    karkas.forEach((element) { 
      if(element.signal=="red"){
        outputErrors.add(element);
        fullSignal="red";
      }
    });
    passDate=dateParserWithSignal(info.passDate,"Срок действия пропуска",null);
    if(passDate!.signal=="red"){
      outputErrors.add(passDate!);
      fullSignal="red";
    }
    
    lastDate=dateParserWithSignal(info.lastInputDate,"",null); 
    if(info.lastInputKPP!=null){
      final infoVector= info.lastInputKPP!.split(" ");
      if(infoVector.length==2){
        lastKpp=infoVector[0];
        lastVector=infoVector[1];
      }
    }
    
  }


  DateWithInfo dateParserWithSignal(String? date,String descript,String? postfix){
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
    if(parse.difference(currentDate).inDays<=30&&parse.difference(currentDate).inDays>=0){
      return DateWithInfo(date: formatedDate +(postfix==null?"":"\n(${postfix})"), name: descript, signal: 'yellow');
    }else if(parse.isBefore(currentDate)){
      return DateWithInfo(date: formatedDate+(postfix==null?"":"\n(${postfix})"), name: descript, signal: 'red');
    }
    return DateWithInfo(date: formatedDate+(postfix==null?"":"\n(${postfix})"), name: descript, signal: 'green');
  }

  @override
  void initState() {
    findDocument();
    super.initState();
  }

  List<String> parseDate(){
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd.MM.yyyy').format(now);
    String formattedTime = DateFormat('HH:mm').format(now);
    return [formattedDate,formattedTime];
  } 


  @override
  Widget build(BuildContext context) {
    return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  SizedBox(height: 24,),
                  Stack(
                    children: [
                      Align(
                        child: Text(
                          "Пропуск",
                          style: TextStyle(
                            fontFamily: "No__",
                            fontSize: 20,
                            fontWeight: FontWeight.w500
                          ),
                        ),
                      ),
                      Positioned(
                        left: 0,
                        child: GestureDetector(
                          onTap:widget.toScan ,
                          child: SizedBox(
                            width: 50, child: Icon(Icons.arrow_back,size: 30,)
                          ),
                        )
                      )
                    ],
                  ),
                  Expanded(
                    child: Builder(
                      builder: (context) {
                        if(finding){
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }else{
                          return SingleChildScrollView(
                            child: Column(
                              children: [
                                SizedBox(height: 60,),
                                personInfo(passStatus?.signal??"grey"),
                                SizedBox(height: 32,),
                                statusChecked(),
                                Builder(
                                  builder: (context) {
                                    if(role.contains("kpp")){
                                      return Column(
                                        children: [
                                          // if(fullSignal=="grey")
                                          // Align(
                                          //   alignment: Alignment.center,
                                          //   child: Text(
                                          //         "Не найдено",
                                          //         style: TextStyle(
                                          //           fontFamily: "Inter",
                                          //           fontSize: 20,
                                          //           color: Colors.grey,
                                          //           fontWeight: FontWeight.w600,
                                          //         ),
                                          //       ),
                                          // ),
                                          
                                          SizedBox(height: 32,),
                                          actionButton(
                                            "Вход",
                                            Color.fromRGBO(6, 203, 73, 1),
                                            ()async{
                                              final dateValues=parseDate();
                                               String errorsWrite="";
                                              if(fullSignal=="grey"){
                                                errorsWrite=errorsWrite+"Пропуск не найден,";
                                              }
                                              if(passStatus==null){
                                                errorsWrite=errorsWrite+"Нет записи о допуске,";
                                              }
                                              if(passStatus!=null&&passStatus!.date=="НЕ ДОПУЩЕН"){
                                                errorsWrite=errorsWrite+"Не допущен,";
                                              }
                                              print(widget.documentNumber);
                                              final jurnal= Jurnal(
                                                kpp: appStore.kpp, 
                                                date: dateValues[0], 
                                                time: dateValues[1], 
                                                numberPassTS: null, 
                                                numberPassDriver: null, 
                                                numberPassPassanger: widget.documentNumber, 
                                                inputObject: "ДА", 
                                                outputObject: null,
                                                ttn: "",
                                                errors: errorsWrite
                                              );
                                              await dataBase.insertJurnal(jurnal);
                                              await dataBase.updateFullInfo(widget.documentNumber,"input");
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
                                                widget.toScan();
                                            }
                                          ),
                                          SizedBox(height: 24,),

                                          


                                          actionButton(
                                            "Выход",
                                            Color.fromRGBO(59, 130, 246, 1),
                                            ()async{
                            
                                              final dateValues=parseDate();
                                              String errorsWrite="";
                                              if(fullSignal=="grey"){
                                                errorsWrite=errorsWrite+"Пропуск не найден,";
                                              }
                                              if(passStatus==null){
                                                errorsWrite=errorsWrite+"Нет записи о допуске,";
                                              }
                                              if(passStatus!=null&&passStatus!.date=="НЕ ДОПУЩЕН"){
                                                errorsWrite=errorsWrite+"Не допущен,";
                                              }
                                              final jurnal= Jurnal(
                                                kpp: appStore.kpp, 
                                                date: dateValues[0], 
                                                time: dateValues[1], 
                                                numberPassTS: null, 
                                                numberPassDriver: null, 
                                                numberPassPassanger: widget.documentNumber, 
                                                inputObject: null, 
                                                ttn: "",
                                                outputObject: "ДА",
                                                errors: errorsWrite
                                              );
                                              await dataBase.insertJurnal(jurnal);
                                              await dataBase.updateFullInfo(widget.documentNumber,"input");
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
                                                widget.toScan();
                                            }
                                          ),
                                          SizedBox(height: 30),
                                          
                                          outputErrors.isEmpty&&fullSignal!="grey"?SizedBox.shrink():
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
                                            )
                                        ],
                                      );
                                    }else if(role.contains("special")){
                                      if(info==null){
                                        return Align(
                                            child: Text(
                                              "Пропуск не найден",
                                              style: TextStyle(
                                                fontFamily: "No__",
                                                fontSize: 35,
                                                color: Colors.grey,
                                                fontWeight: FontWeight.w600
                                              ),
                                            ),
                                          );
                                      }
                                      return  InfoForSpecoalist(
                                        professionals:professionals,
                                        VOZprofessionals:VOZprofessionals,
                                        dateWithInfo:dateWithInfo,
                                        otherData:otherData,
                                        passDate:passDate,
                                        passStatus:passStatus,
                                        karkas:karkas,
                                        lastDate:lastDate,
                                        lastKpp:lastKpp,
                                        lastVector:lastVector
                                      );
                                        
                                      
                                    }else{
                                      return SizedBox.shrink();
                                    }
                                  },
                                ),
                                
                              ],
                            ),
                          );
                        }
                      },
                    ),
                  )
                ],
                
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

Widget itemInfoWithDateWithGroup(String title, String? data){
    print(data);
    // String formattedDate="-";
    // if(data!=null){
    //   final formatter = DateFormat('yMd');
    //   final parsedDate = formatter.parse(data);
    //   formattedDate=DateFormat("dd.MM.yyyy").format(parsedDate.copyWith(year: parsedDate.year+2000));
    // }
    
    return Container(
      alignment: Alignment.centerLeft,
      child: Text(
              title+": "+(data?.replaceAll("\n", " ")??"-"),
              style: TextStyle(
                fontFamily: "Inter",
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.black
              ),
            ),
    );
  }
  Widget itemInfoWithDate(String title, String? data){
    
    String formattedDate="-";
    if(data!=null){
      final formatter = DateFormat('yMd');
      final parsedDate = formatter.parse(data);
      formattedDate=DateFormat("dd.MM.yyyy").format(parsedDate.copyWith(year: parsedDate.year+2000));
    }
    
    return Container(
      alignment: Alignment.centerLeft,
      child: Text(
              title+": "+formattedDate,
              style: TextStyle(
                fontFamily: "Inter",
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.black
              ),
            ),
    );
  }


  Widget actionButton(String title,Color color,Function() action){
    return GestureDetector(
      onTap: (){
        if(outputErrors.isEmpty&&fullSignal!="grey" || requiredAction){
          action();
        }
      }, 
      child: Container(
        height: 56,
        alignment: Alignment.center,
        width: double.infinity,
        decoration: BoxDecoration(
          color:outputErrors.isEmpty&&fullSignal!="grey" || requiredAction?color:color.withAlpha(100),
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


  Widget statusChecked(){
    return Align(
      alignment: Alignment.center,
      child: Text(
          passStatus==null?"НЕ НАЙДЕН":passStatus!.date,
          style: TextStyle(
            fontFamily: "Inter",
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color:passStatus==null?Colors.grey:passStatus!.signal=="red"?Colors.red:passStatus!.signal=="green"? Color.fromRGBO(6, 203, 73, 1):Colors.grey
          ),
        )
        
    );
  }


Widget personInfo(String signal){
  return Container(
    height: 220,
    width: double.infinity,
    padding: EdgeInsets.only(left: 40,top: 40),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      color: signal=="red"?Color.fromRGBO(241, 45, 45, 1):fullSignal=="grey"?Colors.grey:Color.fromRGBO(6, 203, 73, 1)
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

//  666666



class InfoForSpecoalist extends StatefulWidget {
  final List<String> professionals;
  final List<String>VOZprofessionals;
  final List<DateWithInfo> dateWithInfo;
  final List<DateWithInfo> otherData;
  final DateWithInfo? passDate;
  final DateWithInfo? passStatus;
  final List<DateWithInfo> karkas;
  final DateWithInfo? lastDate;
  final String lastKpp;
  final String lastVector;
  const InfoForSpecoalist({
    super.key,
    required this.professionals,
    required this.VOZprofessionals,
    required this.dateWithInfo,
    required this.otherData,
    required this.passDate,
    required this.passStatus,
    required this.karkas,
    required this.lastDate,
    required this.lastKpp,
    required this.lastVector
  });

  @override
  State<InfoForSpecoalist> createState() => _InfoForSpecoalistState();
}

class _InfoForSpecoalistState extends State<InfoForSpecoalist> {


  @override
  Widget build(BuildContext context) {
    print(widget.passStatus!.signal);
    return  Column(
        children: [
          Align(
            alignment: Alignment.center,
            child: Text(
            widget.passStatus!.date,
            style: TextStyle(
              fontFamily: "Inter",
              fontSize: 25,
              fontWeight: FontWeight.w800,
              color: widget.passStatus!.signal=="grey"? Colors.grey:widget.passStatus!.signal=="red"?Colors.red:widget.passStatus!.signal=="yellow"?Color.fromARGB(255, 255, 208, 0):Colors.green
            ),
          ),
          ),
          SizedBox(height: 20,),
          formWrapper(
            "Срок пропуска",
            const Color.fromARGB(255, 185, 90, 83),
              Column(
                children: [
                  
                  Container(
                    height: 40,
                    child: Row(
                      children: [
                        Text(
                          widget.passDate?.date??"Нет данных",
                          style: TextStyle(
                            fontFamily: "Inter",
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: widget.passDate!.signal=="grey"? Colors.grey:widget.passDate!.signal=="red"?Colors.red:widget.passDate!.signal=="yellow"?Color.fromARGB(255, 255, 208, 0):Colors.green
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                ],
              )
          ),
          SizedBox(height: 20,),
          formWrapper(
            "Профессии",
            const Color.fromARGB(255, 185, 90, 83),
              Column(
                children: [
                  for(var element in widget.professionals)
                  Container(
                    height: 40,
                    child: Row(
                      children: [
                        Text(
                          element,
                          style: TextStyle(
                            fontFamily: "Inter",
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: Colors.black
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
          ),
          SizedBox(height: 20,),
          formWrapper(
            "Тестирование ВОЗ",
            const Color.fromARGB(255, 185, 90, 83),
              Column(
                children: [
                  for(var element in widget.VOZprofessionals)
                  Container(
                    height: 40,
                    child: Row(
                      children: [
                        Text(
                          element,
                          style: TextStyle(
                            fontFamily: "Inter",
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: Colors.black
                          ),
                        ),
                      ],
                    ),
                  ),
                  if(widget.VOZprofessionals.isEmpty)
                  Container(
                    alignment: Alignment.centerLeft, 
                    height: 40,
                    child: Text(
                      "Нет данных",
                      style: TextStyle(
                        fontFamily: "Inter",
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: Colors.grey
                      ),
                    ),
                  ),
                ],
              )
          ),
          SizedBox(height: 20,),
          formWrapper(
            "Аттестации и тесты",
            const Color.fromARGB(255, 185, 90, 83),
              Column(
                children: [
                  for(var element in widget.dateWithInfo)
                  Builder(
                    builder: (context) {
                      return Container(
                        height: 50,
                        child: Row(
                          children: [
                            Text(
                              element.name+"\n"+element.date,
                              style: TextStyle(
                                height: 0.9,
                                fontFamily: "Inter",
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: element.signal=="grey"? Colors.grey:element.signal=="red"?Colors.red:element.signal=="yellow"?Color.fromARGB(255, 255, 208, 0):Colors.green
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  ),
                  if(widget.dateWithInfo.isEmpty)
                  Container(
                    alignment: Alignment.centerLeft, 
                    height: 40,
                    child: Text(
                      "Нет данных",
                      style: TextStyle(
                        fontFamily: "Inter",
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: Colors.grey
                      ),
                    ),
                  ),
                ],
              )
          ),
          SizedBox(height: 20,),
          formWrapper(
            "Обучения",
            const Color.fromARGB(255, 185, 90, 83),
              Column(
                children: [
                  for(var element in widget.otherData)
                  Container(
                    height: 50,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            element.name+"\n"+element.date,
                            style: TextStyle(
                              fontFamily: "Inter",
                              fontSize: 14,
                              height: 0.9,
                              fontWeight: FontWeight.w800,
                              color: element.signal=="grey"? Colors.grey:element.signal=="red"?Colors.red:Colors.green
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if(widget.otherData.isEmpty)
                  Container(
                    alignment: Alignment.centerLeft, 
                    height: 50,
                    child: Text(
                      "Нет данных",
                      style: TextStyle(
                        fontFamily: "Inter",
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: Colors.grey
                      ),
                    ),
                  ),
                ],
              )
          ),
          SizedBox(height: 20,),
          formWrapper(
            "Каркас безопасности",
            const Color.fromARGB(255, 185, 90, 83),
              Column(
                children: [
                  for(var element in widget.karkas)
                  Container(
                    height: 50,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            element.name+"\n"+element.date,
                            style: TextStyle(
                              fontFamily: "Inter",
                              fontSize: 14,
                              height: 0.9,
                              fontWeight: FontWeight.w800,
                              color: element.signal=="grey"? Colors.grey:element.signal=="red"?Colors.red:Colors.green
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if(widget.otherData.isEmpty)
                  Container(
                    alignment: Alignment.centerLeft, 
                    height: 50,
                    child: Text(
                      "Нет данных",
                      style: TextStyle(
                        fontFamily: "Inter",
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: Colors.grey
                      ),
                    ),
                  ),
                ],
              )
          ),
          SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Результаты\nпоследнего\nсканирования:",
                style: TextStyle(
                  fontFamily: "Inter",
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Colors.black
                ),
              ),
              Text(
                widget.lastDate?.date??"Ошибка данных",
                style: TextStyle(
                  fontFamily: "Inter",
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Colors.black
                ),
              ),
            ],
          ),
          SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Направление:",
                style: TextStyle(
                  fontFamily: "Inter",
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Colors.black
                ),
              ),
              Text(
                widget.lastVector=="Вход"?"Заехал на объект":widget.lastVector=="Выход"?"Выехал с объекта":widget.lastVector,
                style: TextStyle(
                  fontFamily: "Inter",
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Colors.black
                ),
              ),
            ],
          ),
          SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "КПП:",
                style: TextStyle(
                  fontFamily: "Inter",
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Colors.black
                ),
              ),
              Text(
                widget.lastKpp,
                style: TextStyle(
                  fontFamily: "Inter",
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Colors.black
                ),
              ),
            ],
          ),
          SizedBox(height: 40,),
        ],
      
      
    );
  }

Widget formWrapper(String title, Color borderColor,Widget child,){
  return Column(
    
    children: [
      Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: TextStyle(
            fontFamily: "Inter",
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: Colors.black
          ),
        ),
      ),
      Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          border: Border.all(
            color: borderColor,
            width: 2
          )
        ),
        child: child,
      ),
    ],
  );
}


}