class FullInfo{
  String? fullName;
  String? propuskNumber;
  String? organization;
  String? professionals;

  String? medical;
  String? promSecure;
  String? promSecureOblast;
  String? infoSecure;
  String? workSecure;
  String? medicalHelp;
  String? fireSecure;
  String? electroSecureGroup;
  String? electroSecure;
  String? driverPermit;
  String? winterDriver;
  String? workInHeight;
  String? GPVPGroup;
  String? GNVPGroup;
  String? VOZTest;
  String? VOZProfessional;
  String? burAndVSR;
  String? KSAndCMP;
  String? transport;
  String? energy;
  String? GT;
  String? PPDU;
  String? CA;
  String? KP_2;
  String? PB_11;
  String? PB_12;
  String? lastInputDate;
  String? lastInputKPP;
  String? passStatus;
  String? passDate;
  FullInfo({
    required this.fullName,
    required this.propuskNumber,
    required this.organization,
    required this.professionals,
    required this.medical,
    required this.promSecure,
    required this.promSecureOblast,
    required this.infoSecure,
    required this.workSecure,
    required this.medicalHelp,
    required this.fireSecure,
    required this.electroSecureGroup,
    required this.electroSecure,
    required this.driverPermit,
    required this.winterDriver,
    required this.workInHeight,
    required this.GPVPGroup,
    required this.GNVPGroup,
    required this.VOZTest,
    required this.VOZProfessional,
    required this.burAndVSR,
    required this.KSAndCMP,
    required this.transport,
    required this.energy,
    required this.GT,
    required this.PPDU,
    required this.KP_2,
    required this.PB_11,
    required this.PB_12,
    required this.lastInputDate,
    required this.lastInputKPP,
    required this.passStatus,
    required this.passDate,
    
  });

  Map<String,dynamic> toMap(){
    return {
      "fullName":fullName,
      "propusknumber":propuskNumber,
      "organization":organization,
      "professionals":professionals,
      "medical":medical,
      "promsecure":promSecure,
      "promSecureOblast":promSecureOblast,
      "infosecure":infoSecure,
      "worksecure":workSecure,
      "medicalhelp":medicalHelp,
      "firesecure":fireSecure,
      "electroSecureGroup":electroSecureGroup,
      "electroSecure":electroSecure,
      "driverPermit":driverPermit,
      "winterdriver":winterDriver,
      "workinheight":workInHeight,
      "gpvpgroup":GPVPGroup,
      "gnvpgroup":GNVPGroup,
      "voztest":VOZTest,
      "vozprofessional":VOZProfessional,
      "burAndVSR":burAndVSR,
      "KSAndCMP":KSAndCMP,
      "transport":transport,
      "energy":energy,
      "GT":GT,
      "PPDU":PPDU,
      "CA":CA,
      "KP_2":KP_2,
      "PB_11":PB_11,
      "PB_12":PB_12,
      "lastinputdate":lastInputDate,
      "lastinputkpp":lastInputKPP,
      "passstatus":passStatus,
      "passdate":passDate,
    };
  }
}