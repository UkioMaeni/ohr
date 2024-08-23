import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:secure_kpp/pages/main_page/store/transport_store.dart';
import 'package:secure_kpp/pages/main_page/tabs/scan_tab/scan_tab.dart';
import 'package:secure_kpp/pages/main_page/tabs/ruchnoi_tab/scaning_ruchnoi.dart';
import 'package:secure_kpp/pages/settings/settings_tab.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  late final PageController _pageController;
  int _indexTab=0;
  @override
  void initState() {
    _pageController=PageController();
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    double width=MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: 0,
      ),
      body: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Align(),
              Column(
                
                children: [
                  SizedBox(height: 24,),
                  Text(
                    _indexTab==0?"Сканировать":"Ввод вручную",
                    style: TextStyle(
                      fontFamily: "No__",
                      fontSize: 25,
                      fontWeight: FontWeight.w500
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 0,
                right: 40,
                child: GestureDetector(
                  onTap: () {
                      showModalBottomSheet(
                        context: context, builder: (context) {
                          return SettingsTab();
                        },
                      );                    
                  },
                  child: Icon(Icons.settings,size: 35,color: Color.fromARGB(255, 65, 64, 64),)
                )
              )
            ],
          ),
           
          Expanded(
            child:
            Observer(
              builder: (context) {
                String page= transportStore.navigation;
                if(page=="scan"){
                  return ScanTab();
                }else{
                    return ScaningRuchnoi( );
                }
              },
            )
            //  PageView.builder(
            //   controller: _pageController,
            //   onPageChanged: (value) {
            //     setState(() {
            //       _indexTab=value;
            //     });
            //   },
            //   physics: NeverScrollableScrollPhysics(),
            //   itemBuilder: (context, index) {
            //     if(index==0){
            //       return ScanTab();
            //     }else{
                  
            //     }
            //   },
            // )
          ),
          Container(
            height: 97,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20)
              ),
              boxShadow: [
                BoxShadow(blurRadius: 10,spreadRadius: 0,offset: Offset(0, -4),color: Color.fromRGBO(223, 223, 223, 0.4)),
                
              ]
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                       transportStore.navigation="scan";
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(transportStore.navigation=="scan"?"assets/svg/scan.svg":"assets/svg/scan_a.svg",color:_indexTab==0?Colors.black: Color.fromRGBO(78, 78, 78, 1),),
                        Text(
                        "Скан",
                        style: TextStyle(
                          fontFamily: "No__",
                          fontSize: 20,
                          fontWeight: transportStore.navigation=="scan"?FontWeight.w500: FontWeight.w300,
                          color: transportStore.navigation=="scan"?Colors.black: Color.fromRGBO(78, 78, 78, 1)
                        ),
                      )
                      ],
                    ),
                  )
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        transportStore.navigation="ruchnoi";
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(transportStore.navigation!="scan"?"assets/svg/settings.svg":"assets/svg/settings_a.svg",color:_indexTab==1?Colors.black: Color.fromRGBO(78, 78, 78, 1),),
                        Text(
                        "Вручную",
                        style: TextStyle(
                          fontFamily: "No__",
                          fontSize: 20,
                          fontWeight: transportStore.navigation!="scan"?FontWeight.w500: FontWeight.w300,
                          color: transportStore.navigation!="scan"?Colors.black: Color.fromRGBO(78, 78, 78, 1)
                        ),
                      )
                      ],
                    ),
                  )
                )
              ],
            ),
          )
        ],
      ),
      
    );
  }
}