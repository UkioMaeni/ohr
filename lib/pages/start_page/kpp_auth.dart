import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:secure_kpp/http/auth.dart';
import 'package:secure_kpp/pages/main_page/main_page.dart';
import 'package:secure_kpp/storage/role_storeage.dart';

class KppAuthPage extends StatefulWidget {
  const KppAuthPage({super.key});

  @override
  State<KppAuthPage> createState() => _KppAuthPageState();
}

class _KppAuthPageState extends State<KppAuthPage> {

  final TextEditingController login=TextEditingController();
  final TextEditingController pass=TextEditingController();
  bool error=false;
  bool loading=false;


  void auth()async{
    setState(() {
      loading=true;
    });
    final result=await AuthHttp().auth(login.text,pass.text);
    if(result==0){
      await RoleStorage().setRole("special");
      RoleStorage.role="special";
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MainPage(),), (route) => false);
    }else{
      setState(() {
         error=true;
         loading=false;
      });
    }

    //Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MainPage(),), (route) => false);
  }

  @override
  void dispose() {
    login.dispose();
    pass.dispose();
    super.dispose();
  }  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: 0,
      ),
      body: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 24,),
                  Text(
                      "Вход специалиста ПБ",
                      style: TextStyle(
                        fontFamily: "No__",
                        fontSize: 20,
                        fontWeight: FontWeight.w500
                      ),
                    ),
                    SizedBox(height: 250,),
                    input(login,false,"Логин"),
                    SizedBox(height: 10,),
                    input(pass,true,"Пароль"),
                    errorState(),
                    button("Войти",auth)
                ],
              ),
            ),
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

  Widget errorState(){
    return Container(
      height: 40,
      alignment: Alignment.centerLeft,
      child: error? Text(
                "Неверный пароль",
                style: TextStyle(
                  fontFamily: "No__",
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.red
                ),
              ):SizedBox.shrink(),
    );
  }

  bool obscureText=true;

  Widget input(TextEditingController _controller,bool secure,String hint){
    return Container(
      height: 56,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(
          color:error?Colors.red: Color.fromRGBO(198, 198, 198, 1),
        ),
        borderRadius: BorderRadius.circular(12)
      ),
      alignment: Alignment.center,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              onChanged: (value) {
                setState(() {
                  error=false;
                });
              },
              style: 
              TextStyle(
                  fontFamily: "No__",
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
              obscureText: obscureText,
              decoration: InputDecoration(
                
                contentPadding: EdgeInsets.only(left: 20,right: 20,bottom: 0,top: 0),
                border: InputBorder.none,
                hintText: hint,
                hintStyle: TextStyle(
                  fontFamily: "No__",
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: Color.fromRGBO(128, 128, 128, 1)
                )
              ),
            ),
          ),
          if(secure)GestureDetector(
            onTapDown: (_) {
              setState(() {
                obscureText=false;
              });
            },
            onTapUp: (_) {
              setState(() {
                obscureText=true;
              });
            },
            child:  Container(
              width: 60,
              alignment: Alignment.center,
              child:!obscureText? Icon(Icons.visibility):Icon(Icons.visibility_off)
            ),
          ),

        ],
      ),
    );
  }
   Widget button(String title, Function() onClick){
    return GestureDetector(
      onTap: onClick,
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
            child: loading
            ?CircularProgressIndicator() 
            :Text(
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
}