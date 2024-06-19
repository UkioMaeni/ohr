import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:secure_kpp/pages/main_page/tabs/scan_tab/conponents/scaning.dart';
import 'package:secure_kpp/pages/main_page/tabs/ruchnoi_tab/scaning_ruchnoi.dart';
import 'package:secure_kpp/pages/main_page/tabs/scan_tab/conponents/transport_scan.dart';

class ScanPage extends StatefulWidget {
  final Function(String) toCheck;
  const ScanPage({super.key,required this.toCheck});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                 
                  SizedBox(height: 48,),
                  scanType(),
                  SizedBox(height: 32,),
                  variableScan=="scan"?Scaning(toCheck:widget.toCheck):ScanTransportPage(toCheck: widget.toCheck)
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