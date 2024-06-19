import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:secure_kpp/pages/main_page/main_page.dart';
import 'package:secure_kpp/pages/start_page/kpp_auth.dart';
import 'package:secure_kpp/storage/role_storeage.dart';

class VariableKppPage extends StatefulWidget {
  const VariableKppPage({super.key});

  @override
  State<VariableKppPage> createState() => _VariableKppPageState();
}

class _VariableKppPageState extends State<VariableKppPage> {


  setKppInDevice(int kpp)async{
    await RoleStorage().setRole("kpp_$kpp");
    Navigator.push(context, MaterialPageRoute(builder: (context) => MainPage(),));
  }


  @override
  Widget build(BuildContext context) {
    double width=MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: 0,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(height: 24,),
              Text(
                  "Выберите КПП",
                  style: TextStyle(
                    fontFamily: "No__",
                    fontSize: 20,
                    fontWeight: FontWeight.w500
                  ),
                ),
                SizedBox(height: 35,),
              
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: GridView.builder(
                        itemCount: 27,
                        
                        itemBuilder: (context, index) {
                         return kpp_element(index);
                        },
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4, // Количество элементов в ряду
                          crossAxisSpacing: 10, // Интервал между элементами по горизонтали
                          mainAxisSpacing: 10, // Интервал между элементами по вертикали
                        ),
                        
                      ),
                    ),
                  )
            ],
          ),
          Positioned(
            top: 18,
            left: 16,
            child: SizedBox(
              width: 40,
              height: 40,
              child: Icon(Icons.arrow_back)
            )
          )
        ],
      ),
    );
  }

  Widget kpp_element(int index){
    return GestureDetector(
      onTap:()=> setKppInDevice(index+1),
      child: SizedBox(
        height: 58,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Color.fromRGBO(59, 130, 246, 1),
            borderRadius: BorderRadius.circular(12)
          ),
          child: Align(
            alignment: Alignment.center,
            child: Text(
                "КПП "+(index+1).toString(),
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
}