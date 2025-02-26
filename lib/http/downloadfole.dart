import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:secure_kpp/models/full_info.dart';
//const baseUrl="http://192.168.1.92:3005/api";
const baseUrl="http://82.97.245.161:3005/api";

class DownloadFileHttp{

    Dio dio=Dio();

    Future<int> download(String login,String pass)async{
      bool completer=false;
        try {
          Response response= await dio.post(
            "$baseUrl/auth",
            data: {
              "login":login,
              "pass":pass
            }
          );  
          print(response.data);
          return 0;
        } catch (e,stackTrace) {
          print(e);
          return -1;
        }
    }



  

}



