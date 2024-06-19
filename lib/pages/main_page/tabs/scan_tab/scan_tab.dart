import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:secure_kpp/pages/main_page/tabs/scan_tab/conponents/scaning.dart';
import 'package:secure_kpp/pages/main_page/tabs/scan_tab/pages/check.dart';
import 'package:secure_kpp/pages/main_page/tabs/scan_tab/pages/scan.dart';

class ScanTab extends StatefulWidget {
  const ScanTab({super.key});

  @override
  State<ScanTab> createState() => _ScanTabState();
}

class _ScanTabState extends State<ScanTab> {


  String page="scan";
  String numberDocument="";
  void toCheck(String value){
    setState(() {
      numberDocument=value;
      page="check";
    });
  }
  void toScan(){
    setState(() {
      page="scan";
    });
  }

  @override
  Widget build(BuildContext context) {
    print(numberDocument);
    if(page=="scan"){
      return  ScanPage(toCheck:toCheck);
    }else if(page=="check"){
      return CheckPage(documentNumber: numberDocument,toScan:toScan);
    }else{
      return SizedBox.shrink();
    }
    
  }

  

  
}