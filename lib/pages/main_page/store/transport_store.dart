import 'package:flutter/foundation.dart';
import 'package:mobx/mobx.dart';
import 'package:secure_kpp/models/full_info.dart';


part 'transport_store.g.dart';

class TransportStore = _TransportStore with _$TransportStore;

abstract class _TransportStore with Store {


@observable
String _currentPeople="";
String get currentPeople=>_currentPeople;
set currentPeople(String value){
  _currentPeople=value;
}

@observable
InformarionAboutPeople? carInfo;

@observable
InformarionAboutPeople? driverInfo;

@action
deleteDriver(){
  driverInfo=null;
}

@observable
ObservableList<InformarionAboutPeople?> peopleInfo=ObservableList<InformarionAboutPeople?>.of([null,null]);

@action
addPeople(){
  peopleInfo.add(null);
  peopleInfo=ObservableList.of(peopleInfo);
}

@action
updatePeople(InformarionAboutPeople fullInfo){
  if(_currentPeople=="Водитель"){
    driverInfo=fullInfo;
  }else if(_currentPeople=="Пассажир"){

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