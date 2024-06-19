class Jurnal{
  String? kpp;
  String? date;
  String? time;
  String? numberPassTS;
  String? numberPassDriver;
  String? numberPassPassanger;
  String? inputObject;
  String? outputObject;
  Jurnal({
    required this.kpp,
    required this.date,
    required this.time,
    required this.numberPassTS,
    required this.numberPassDriver,
    required this.numberPassPassanger,
    required this.inputObject,
    required this.outputObject,
  });

  Map<String,dynamic> toMap(){
    return {
      "kpp":kpp,
      "date":date,
      "time":time,
      "numberPassTS":numberPassTS,
      "numberPassDriver":numberPassDriver,
      "numberPassPassanger":numberPassPassanger,
      "inputObject":inputObject,
      "outputObject":outputObject,
    };
  }
}