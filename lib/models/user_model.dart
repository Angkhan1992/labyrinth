class UserModel {
  String? id;
  String? usrID;
  String? usrName;
  String? usrEmail;
  String? usrGender;
  String? usrDOB;
  String? usrCountry;
  String? usrRegdate;
  String? usrUpdate;
  String? usrType;
  String? usrLevel;
  String? usrMember;
  String? usrPurpose;
  String? usrExperience;
  String? usrToken;
  String? usrOther;

  UserModel({
    this.id,
    this.usrID,
    this.usrName,
    this.usrEmail,
    this.usrGender,
    this.usrDOB,
    this.usrCountry,
    this.usrRegdate,
    this.usrUpdate,
    this.usrType,
    this.usrLevel,
    this.usrMember,
    this.usrPurpose,
    this.usrExperience,
    this.usrToken,
    this.usrOther,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["usr_id"],
      usrID: json["usr_userid"],
      usrName: json["usr_name"],
      usrEmail: json["usr_email"],
      usrGender: json["usr_gender"],
      usrDOB: json["usr_dob"],
      usrCountry: json["usr_country"],
      usrRegdate: json["reg_date"],
      usrUpdate: json["update_date"],
      usrType: json["usr_type"],
      usrLevel: json["usr_level"],
      usrMember: json["usr_member"],
      usrPurpose: json["usr_purpose"],
      usrExperience: json["usr_experience"],
      usrToken: json["token"],
      usrOther: json["other"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "usr_id": this.id,
      "usr_userid": this.usrID,
      "usr_name": this.usrName,
      "usr_email": this.usrEmail,
      "usr_gender": this.usrGender ?? '',
      "usr_dob": this.usrDOB ?? '',
      "usr_country": this.usrCountry ?? '',
      "reg_date": this.usrRegdate ?? '',
      "update_date": this.usrUpdate ?? '',
      "usr_type": this.usrType ?? '',
      "usr_level": this.usrLevel ?? '',
      "usr_member": this.usrMember ?? '',
      "usr_purpose": this.usrPurpose ?? '',
      "usr_experience": this.usrExperience ?? '',
      "token": this.usrToken ?? '',
      "other": this.usrOther ?? '',
    };
  }
}
