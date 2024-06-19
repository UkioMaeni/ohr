import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:secure_kpp/models/full_info.dart';
const baseUrl="https://147.45.161.163:3000/api";


class AuthHttp{

    Dio dio=Dio();

    Future<int> auth(String pass)async{
      bool completer=false;
        try {;
          Response response= await dio.post(
            "$baseUrl/auth",
            data: {
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



