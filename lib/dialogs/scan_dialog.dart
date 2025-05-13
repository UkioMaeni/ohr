import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:secure_kpp/models/full_info.dart';

class ScanDialog extends StatefulWidget {
  const ScanDialog({super.key});

  @override
  State<ScanDialog> createState() => _ScanDialogState();
}

class _ScanDialogState extends State<ScanDialog> {


  bool finding=true;
  FullInfo? info;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            height: 220,
            width: double.infinity,
            padding: EdgeInsets.only(left: 40,top: 40),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color:info!=null?Color.fromRGBO(6, 203, 73, 1):Color.fromRGBO(241, 45, 45, 1)
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
                // Text(
                //   "Пропуск № "+(widget.documentNumber??"Нет данных"),
                //   style: TextStyle(
                //     fontFamily: "Inter",
                //     fontSize: 20,
                //     fontWeight: FontWeight.w800,
                //     color: Colors.white
                //   ),
                // ),
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
          ),
        ],
      ),
    );
  }
}