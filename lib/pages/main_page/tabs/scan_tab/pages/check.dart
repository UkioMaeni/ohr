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
    }else{
      errors.add("Не найдено");      
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
                          return Column(
                            children: [
                              SizedBox(height: 60,),
                              personInfo(),
                              SizedBox(height: 32,),
                              statusChecked(),
                              Builder(
                                builder: (context) {
                                  if(role.contains("kpp")){
                                    return Column(
                                      children: [
                                        SizedBox(height: 32,),
                                        actionButton(
                                          "Вход",
                                          Color.fromRGBO(6, 203, 73, 1),
                                          ()async{
                                            final dateValues=parseDate();
                                            final jurnal= Jurnal(
                                              kpp: appStore.kpp, 
                                              date: dateValues[0], 
                                              time: dateValues[1], 
                                              numberPassTS: null, 
                                              numberPassDriver: null, 
                                              numberPassPassanger: widget.documentNumber, 
                                              inputObject: null, 
                                              outputObject: "ДА"
                                            );
                                            await dataBase.insertJurnal(jurnal);
                                            widget.toScan();
                                          }
                                        ),
                                        SizedBox(height: 24,),
                                        actionButton(
                                          "Выход",
                                          Color.fromRGBO(59, 130, 246, 1),
                                          ()async{

                                            final dateValues=parseDate();
                                            final jurnal= Jurnal(
                                              kpp: appStore.kpp, 
                                              date: dateValues[0], 
                                              time: dateValues[1], 
                                              numberPassTS: null, 
                                              numberPassDriver: null, 
                                              numberPassPassanger: widget.documentNumber, 
                                              inputObject: null, 
                                              outputObject: "ДА"
                                            );
                                            await dataBase.insertJurnal(jurnal);
                                            widget.toScan();
                                          }
                                        ),
                                        SizedBox(height: 30),
                                        errors.isEmpty?SizedBox.shrink():
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
                                      return SizedBox.shrink();
                                    }
                                    return Expanded(
                                      child: SingleChildScrollView(
                                        child: Column(
                                          children: [
                                           // itemInfo("Основная профессия",info?.mainProfessional),
                                            //itemInfo("Вторая профессия",info?.secondProfessional),
                                            //itemInfo("Третья профессия",info?.firdProfessional),
                                            //itemInfo("Прочие профессии",info?.otherProfessional),
                                            itemInfoWithDate("Медосмотр",info?.medical),
                                            itemInfoWithDate("Пром безопасность",info?.promSecure),
                                            itemInfoWithDate("Погружение в пром безопасность",info?.medical),
                                            itemInfoWithDate("Обучение 'Охрана труда'",info?.workSecure),
                                            itemInfoWithDate("Обучение 'Первая помощь'",info?.medicalHelp),
                                            itemInfoWithDate("Пожарная безопасность",info?.fireSecure),
                                            //itemInfoWithDateWithGroup("Группа ЭБ",info?.groupEB),
                                            itemInfoWithDate("Зимнее защитное вождение",info?.winterDriver),
                                            itemInfoWithDateWithGroup("Работы на высоте",info?.workInHeight),
                                            itemInfoWithDate("ГПВП - Бригады ТКРС/ТРС",info?.GPVPGroup),
                                            itemInfoWithDate("ГНВП - Бригады бурения",info?.GNVPGroup),
                                            itemInfoWithDate("Прохождение теста ВОЗ",info?.VOZTest),
                                            itemInfo("Профессии ВОЗ",info?.VOZProfessional),
                                            itemInfo("Срок действия пропуска",info?.passDate),
                                            itemInfo("Статус пропуска",info?.passStatus),
                                          ],
                                        ),
                                      ),
                                    );
                                  }else{
                                    return SizedBox.shrink();
                                  }
                                },
                              ),
                              
                            ],
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
        if(errors.isEmpty || requiredAction){
          action();
        }
      }, 
      child: Container(
        height: 56,
        alignment: Alignment.center,
        width: double.infinity,
        decoration: BoxDecoration(
          color:errors.isEmpty || requiredAction?color:color.withAlpha(100),
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
      alignment: errors.isEmpty?Alignment.center:Alignment.centerLeft,
      child: errors.isEmpty
      ?Text(
          "Найден",
          style: TextStyle(
            fontFamily: "Inter",
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: Color.fromRGBO(6, 203, 73, 1)
          ),
        )
        :Column(
          children: [
            for(var element in errors)
            Text(
              element,
              style: TextStyle(
                fontFamily: "Inter",
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Color.fromRGBO(241, 45, 45, 1)
              ),
            )
          ],
        )
        ,
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

//  666666