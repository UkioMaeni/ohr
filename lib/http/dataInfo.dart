import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:secure_kpp/db/sqllite.dart';
import 'package:secure_kpp/models/full_info.dart';
const baseUrl="http://192.168.1.92:3005/api";
class UserChatInfo{
  String nickname;
  String photoUri;
  String state;
  UserChatInfo({
    required this.nickname,
    required this.photoUri,
    required this.state
  });
}

class DataInfoHttp{

    Dio dio=Dio();

    Future<int> addJurnalToServer()async{
      try {
        final info =await dataBase.checkJurnal();
        await dio.post(
          "$baseUrl/full",
          data: {
            "jurnal":info
          }
        );
        return 0;
      } catch (e) {
        return -1;
      }
    }
    Future<List<FullInfo>?> getFullInfo()async{
      bool completer=false;
      
        try {
          final response = await http.get(
            Uri.parse("$baseUrl/full"),
          );
          print(response.body);
          // Response response= await dio.get(
          // "$baseUrl/full",
          
          // options: Options(
          //   receiveTimeout: Duration(seconds: 20),
          //   headers: {
          //     'Accept': 'chunked',
          //   },
            
          // ),
          // onReceiveProgress: (int received, int total) {

          // },
          
          // );  
          List<dynamic> list=json.decode(response.body);
          //inspect(list);
          print(list.length);
          List<FullInfo> fullInfo=[];
          for (var element in list){
            fullInfo.add(
              FullInfo(
                fullName: element["fullName"], 
                propuskNumber: element["propuskNumber"], 
                organization: element["organization"], 
                professionals: element["professionals"], 
                medical: element["medical"], 
                promSecure: element["promSecure"], 
                infoSecure: element["infoSecure"], 
                workSecure: element["workSecure"], 
                medicalHelp: element["medicalHelp"], 
                fireSecure: element["fireSecure"], 
                promSecureOblast: element["promSecureOblast"],
                electroSecureGroup: element["electroSecureGroup"],
                electroSecure: element["electroSecure"],
                driverPermit: element["driverPermit"],
                winterDriver: element["winterDriver"], 
                workInHeight: element["workInHeight"], 
                workInHeightGroup: element["workInHeightGroup"],
                GPVPGroup: element["GPVPGroup"], 
                GNVPGroup: element["GNVPGroup"], 
                VOZTest: element["VOZTest"], 
                VOZProfessional: element["VOZProfessional"], 
                burAndVSR: element["burAndVSR"],
                KSAndCMP: element["KSAndCMP"],
                transport: element["transport"],
                energy: element["energy"],
                GT: element["GT"],
                PPDU: element["PPDU"],
                KP_2: element["KP_2"],
                PB_11: element["PB_11"],
                PB_12: element["PB_12"],
                medicalType:element["medicalType"],
                lastInputDate: element["lastInputDate"], 
                lastInputKPP: element["lastInputKPP"], 
                passStatus: element["passStatus"], 
                passDate: element["passDate"]
              )
            );
          }
          return fullInfo;
        } catch (e,stackTrace) {
          print(e);
          return null;
        }
    }



  

}



