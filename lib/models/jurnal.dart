class Jurnal{
  String? kpp;
  String? date;
  String? time;
  String? numberPassTS;
  String? numberPassDriver;
  String? numberPassPassanger;
  String? inputObject;
  String? outputObject;
  String? errors;
  String? ttn;
  Jurnal({
    required this.kpp,
    required this.date,
    required this.time,
    required this.numberPassTS,
    required this.numberPassDriver,
    required this.numberPassPassanger,
    required this.inputObject,
    required this.outputObject,
    required this.errors,
    required this.ttn
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
      "ttn":ttn,
      "errors":errors
    };
  }
}