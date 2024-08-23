import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:secure_kpp/models/full_info.dart';


part 'transport_store.g.dart';

class TransportStore = _TransportStore with _$TransportStore;

abstract class _TransportStore with Store {
//scan, ruchnoi
@observable
String _navigation="scan";
String get navigation=>_navigation;
set navigation(String value){
  _navigation=value;
}
//personal, transport
@observable
String _navigationType="personal";
String get navigationType=>_navigationType;
set navigationType(String value){
  _navigationType=value;
}
@observable
String _currentPeople="";
String get currentPeople=>_currentPeople;
set currentPeople(String value){
  _currentPeople=value;
}

TextEditingController ttnCcontroller=TextEditingController();

@observable
InformarionAboutPeople? carInfo;

@observable
InformarionAboutPeople? driverInfo;

@action
deleteDriver(){
  driverInfo=null;
}

@observable
ObservableList<InformarionAboutPeople?> peopleInfo=ObservableList<InformarionAboutPeople?>.of([null]);

@action
addPeople(){
  peopleInfo.add(null);
  peopleInfo=ObservableList.of(peopleInfo);
}

@action
updatePeople(InformarionAboutPeople fullInfo){
  if(_currentPeople=="Автомобиль"){
    carInfo=fullInfo..error=[];
  }else if(_currentPeople=="Водитель"){
    driverInfo=fullInfo;
  }else if(_currentPeople.contains("Пассажир")){
    peopleInfo.insert(peopleInfo.length-1,fullInfo);
    print(fullInfo.documentNumber);
    peopleInfo=ObservableList.of(peopleInfo);
  }
  
}


} 


TransportStore transportStore=TransportStore();


class InformarionAboutPeople{
  FullInfo? fullInfo;
  List<String> error=[];
  String documentNumber;
  InformarionAboutPeople({
    required this.documentNumber
  });
}