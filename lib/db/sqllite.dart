import 'package:intl/intl.dart';
import 'package:secure_kpp/models/full_info.dart';
import 'package:secure_kpp/models/jurnal.dart';
import 'package:secure_kpp/store/store.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
class SQLLite{
  String path="";
  Future getPath()async{
       String newPath= join(await getDatabasesPath(), 'my_database.db');
      path=newPath;
  }

  Future<void> createDB()async{
    try {
      Database db = await openDatabase(path);
      await db.execute(
        '''
          CREATE TABLE IF NOT EXISTS
          full_info(
            id INTEGER PRIMARY KEY, 
            fullName TEXT NULL,  
            propusknumber TEXT NULL, 
            organization TEXT NULL, 
            professionals TEXT NULL, 
            medical TEXT NULL,
            promsecure TEXT NULL,

            promSecureOblast TEXT NULL,

            infosecure TEXT NULL,
            worksecure TEXT NULL,
            medicalhelp TEXT NULL,
            firesecure TEXT NULL,

            electroSecureGroup TEXT NULL,
            electroSecure TEXT NULL,
            driverPermit TEXT NULL,

            winterdriver TEXT NULL,
            workinheight TEXT NULL,
            workInHeightGroup TEXT NULL,
            gpvpgroup TEXT NULL,
            gnvpgroup TEXT NULL,
            voztest TEXT NULL,
            vozprofessional TEXT NULL,

            burAndVSR TEXT NULL,
            KSAndCMP TEXT NULL,
            transport TEXT NULL,
            energy TEXT NULL,
            GT TEXT NULL,
            PPDU TEXT NULL,
            CA TEXT NULL,
            KP_2 TEXT NULL,
            PB_11 TEXT NULL,
            PB_12 TEXT NULL,
            medicalType TEXT NULL,
            lastinputdate TEXT NULL,
            lastinputkpp TEXT NULL,
            passstatus TEXT NULL,
            passdate TEXT NULL
            )
          '''
      );
      await db.execute(
        '''
          CREATE TABLE IF NOT EXISTS
          jurnal(
            id INTEGER PRIMARY KEY, 
            kpp TEXT NULL, 
            date TEXT NULL, 
            time TEXT NULL, 
            numberPassTS TEXT NULL, 
            numberPassDriver TEXT NULL, 
            numberPassPassanger TEXT NULL, 
            inputObject TEXT NULL, 
            outputObject TEXT NULL,
            ttn TEXT NULL,
            errors TEXT NULL
            )
          '''
      );
    } catch (e) {
      
    }
  }

  Future<void> insertFullInfo(List<FullInfo> items,Function() completer)async{
    final Database db = await openDatabase(path);
    final batch = db.batch();
    batch.delete("full_info");
    for (final item in items) {
      batch.insert('full_info', item.toMap(),conflictAlgorithm: ConflictAlgorithm.replace,);
      completer();
    }
    await batch.commit();
    await db.close();
    // await Future.forEach(items,(element)async {
    //       await db.insert(
    //         "full_info",
    //         element.toMap(),
    //         conflictAlgorithm: ConflictAlgorithm.replace,
    //       );
    //       completer();
    //   });
  }
  
  Future<void> updateFullInfo(String documentNumber,String vector)async{
    final Database db = await openDatabase(path);
    if(vector=="input"){
      db.update(
        "full_info", 
        {
          "lastinputdate":DateFormat("dd.MM.yyyy").format(DateTime.now()),
          "lastinputkpp":"Вход "+(appStore.kpp??"<неизв кпп>")
        },
        where: "propusknumber = ?",
        whereArgs: [
          documentNumber
        ]
      );
    }else{
      db.update(
        "full_info", 
        {
          "lastinputdate":DateFormat("dd.MM.yyyy").format(DateTime.now()),
          "lastinputkpp":"Выход "+(appStore.kpp??"<неизв кпп>")
        },
        where: "propusknumber = ?",
        whereArgs: [
          documentNumber
        ]
      );
    }
  }

  

  Future<void> insertJurnal(Jurnal jurnal)async{
    final Database db = await openDatabase(path);
    await db.insert(
        "jurnal",
        jurnal.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
  }
  Future<void> deleteJurnal()async{
    final Database db = await openDatabase(path);
    await db.delete(
        "jurnal",
      );
  }
  Future<List<Map<String, dynamic>>> checkJurnal()async{
    final Database db = await openDatabase(path);
    final List<Map<String, dynamic>> find = await db.query('jurnal');
    print(find);
    return find;
  }



  Future<FullInfo?> search(String passNumber)async{
    final Database db = await openDatabase(path);
    final List<Map<String, dynamic>> find = await db.query('full_info',where: "propusknumber=\$1",whereArgs: [passNumber]);
    print(find);
    if(find.isNotEmpty){
      final Map<String, dynamic> data=find[0];
      return FullInfo(
        fullName: data["fullName"], 
        propuskNumber: data["propusknumber"], 
        organization: data["organization"], 
        professionals: data["professionals"], 
        medical: data["medical"], 
        promSecure: data["promsecure"], 
        infoSecure: data["infosecure"], 
        workSecure: data["worksecure"], 
        medicalHelp: data["medicalhelp"], 
        fireSecure: data["firesecure"],
        promSecureOblast: data["promSecureOblast"],
        electroSecureGroup: data["electroSecureGroup"],
        electroSecure: data["electroSecure"],
        driverPermit: data["driverPermit"], 
        winterDriver: data["winterdriver"], 
        workInHeight: data["workinheight"], 
        workInHeightGroup: data["workInHeightGroup"],
        GPVPGroup: data["gpvpgroup"], 
        GNVPGroup: data["gnvpgroup"], 
        VOZTest: data["voztest"], 
        VOZProfessional: data["vozprofessional"],
        burAndVSR: data["burAndVSR"],
        KSAndCMP: data["KSAndCMP"],
        transport: data["transport"],
        energy: data["energy"],
        GT: data["GT"],
        PPDU: data["PPDU"],
        KP_2: data["KP_2"],
        PB_11: data["PB_11"],
        PB_12: data["PB_12"], 
        medicalType: data["medicalType"],
        lastInputDate: data["lastinputdate"], 
        lastInputKPP: data["lastinputkpp"], 
        passStatus: data["passstatus"], 
        passDate: data["passdate"]
        );
    }
    return null;
  }
  Future<int> checkCount()async{
    final Database db = await openDatabase(path);
    final List<Map<String, dynamic>> find = await db.query('full_info');
    print(find);
    return find.length;
  }
  Future<int> checkJurnalCount()async{
    final Database db = await openDatabase(path);
    final List<Map<String, dynamic>> find = await db.query('jurnal');
    print(find);
    return find.length;
  }
  Future<void> dropDatabase() async {
    final Database db = await openDatabase(path);
    await db.close();
    
    // Удаляем файл базы данных
    await deleteDatabase(path);
  }
}

final dataBase=SQLLite();