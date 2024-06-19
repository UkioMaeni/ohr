import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
    return Column(
      children: [
        SizedBox(height: 100,),
          input(),
          SizedBox(height: 30,),
          //button("Проверить",widget.toCheck)
      ],
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

  Widget input(){
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
}