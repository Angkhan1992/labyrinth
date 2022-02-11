class UserModel {
  String? id;
  String? usrID;
  String? usrName;
  String? usrEmail;
  String? usrAvatar;
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
  String? usrCoin;
  String? usrToken;
  String? usrOther;

  UserModel({
    this.id,
    this.usrID,
    this.usrName,
    this.usrAvatar,
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
    this.usrCoin,
    this.usrToken,
    this.usrOther,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["usr_id"],
      usrID: json["usr_userid"],
      usrName: json["usr_name"],
      usrEmail: json["usr_email"],
      usrAvatar: json["usr_avatar"],
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
      usrCoin: json["usr_coin"],
      usrToken: json["token"],
      usrOther: json["other"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "usr_id": id,
      "usr_userid": usrID,
      "usr_name": usrName,
      "usr_email": usrEmail,
      "usr_avatar": usrAvatar,
      "usr_gender": usrGender ?? '',
      "usr_dob": usrDOB ?? '',
      "usr_country": usrCountry ?? '',
      "reg_date": usrRegdate ?? '',
      "update_date": usrUpdate ?? '',
      "usr_type": usrType ?? '',
      "usr_level": usrLevel ?? '',
      "usr_member": usrMember ?? '',
      "usr_purpose": usrPurpose ?? '',
      "usr_experience": usrExperience ?? '',
      "usr_coin": usrCoin ?? '0',
      "token": usrToken ?? '',
      "other": usrOther ?? '',
    };
  }

  Map<String, dynamic> toQRJson() {
    return {
      "usr_userid": usrID,
      "usr_name": usrName,
      "usr_email": usrEmail,
      "usr_avatar": usrAvatar,
      "usr_gender": usrGender ?? '',
      "usr_dob": usrDOB ?? '',
      "usr_country": usrCountry ?? '',
      "usr_type": usrType ?? '',
      "usr_level": usrLevel ?? '',
      "usr_member": usrMember ?? '',
      "usr_purpose": usrPurpose ?? '',
    };
  }
}
