import 'package:flutter/material.dart';
import 'package:labyrinth/generated/l10n.dart';
import 'package:labyrinth/themes/colors.dart';
import 'package:labyrinth/themes/dimens.dart';
import 'package:labyrinth/utils/constants.dart';
import 'package:labyrinth/utils/extension.dart';
import 'package:labyrinth/widgets/setting/setting_widget.dart';

class UserModel extends ChangeNotifier {
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

  void setUsrName(String name) {
    usrName = name;
    notifyListeners();
  }

  void setUsrEmail(String email) {
    usrEmail = email;
    notifyListeners();
  }

  void setUsrAvatar(String avatar) {
    usrAvatar = avatar;
    notifyListeners();
  }

  void setUsrGender(String gender) {
    usrGender = gender;
    notifyListeners();
  }

  void setUsrBirth(String birth) {
    usrDOB = birth;
    notifyListeners();
  }

  void setUsrCountry(String country) {
    usrCountry = country;
    notifyListeners();
  }

  void setUsrUpdate(String updated) {
    usrUpdate = updated;
    notifyListeners();
  }

  void setUsrType(String type) {
    usrType = type;
    notifyListeners();
  }

  void setUsrLevel(String level) {
    usrLevel = level;
    notifyListeners();
  }

  void setUsrMember(String member) {
    usrMember = member;
    notifyListeners();
  }

  void setUsrPurpose(String purpose) {
    usrPurpose = purpose;
    notifyListeners();
  }

  void setUsrExperience(String experience) {
    usrExperience = experience;
    notifyListeners();
  }

  void setUsrCoin(String coin) {
    usrCoin = coin;
    notifyListeners();
  }

  void setFromJson(Map<String, dynamic> json) {
    id = json["usr_id"];
    usrID = json["usr_userid"];
    usrName = json["usr_name"];
    usrEmail = json["usr_email"];
    usrAvatar = (json["usr_avatar"] as String)
        .replaceAll('https://labyrinth.laodev.info/', kBaseUrl);
    usrGender = json["usr_gender"];
    usrDOB = json["usr_dob"];
    usrCountry = json["usr_country"];
    usrRegdate = json["reg_date"];
    usrUpdate = json["update_date"];
    usrType = json["usr_type"];
    usrLevel = json["usr_level"];
    usrMember = json["usr_member"];
    usrPurpose = json["usr_purpose"];
    usrExperience = json["usr_experience"];
    usrCoin = json["usr_coin"];
    usrToken = json["token"];
    usrOther = json["other"];

    notifyListeners();
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
      "usr_id": id,
      "usr_userid": usrID,
      "usr_name": usrName,
      "usr_email": usrEmail,
      "usr_avatar": usrAvatar ?? '',
      "usr_gender": usrGender ?? '',
      "usr_dob": usrDOB ?? '',
      "usr_country": usrCountry ?? '',
      "usr_type": usrType ?? '',
      "usr_level": usrLevel ?? '',
      "usr_member": usrMember ?? '',
      "usr_purpose": usrPurpose ?? '',
    };
  }

  Widget requestItem({
    Function()? request,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: offsetXSm),
      padding: const EdgeInsets.all(offsetSm),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(offsetSm),
      ),
      child: Row(
        children: [
          LabyrinthAvatar(
            url: usrAvatar!,
            avatarSize: AvatarSize.md,
          ),
          const SizedBox(
            width: offsetBase,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                usrName!.mediumText(),
                '${usrCountry!} - ${usrGender! == '1' ? S.current.female : S.current.male}'
                    .thinText(fontSize: fontSm),
              ],
            ),
          ),
          const SizedBox(
            width: offsetBase,
          ),
          TextButton(
            onPressed: request,
            child: 'Request'.mediumText(
              fontSize: fontXSm,
              color: kAccentColor,
            ),
          )
        ],
      ),
    );
  }

  Widget inviteItem({
    Function()? accept,
    Function()? decline,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2.0),
      padding: const EdgeInsets.all(offsetSm),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(offsetSm),
      ),
      child: Row(
        children: [
          LabyrinthAvatar(
            url: usrAvatar!,
            avatarSize: AvatarSize.md,
          ),
          const SizedBox(
            width: offsetBase,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                usrName!.mediumText(),
                '${usrCountry!} - ${usrGender! == '1' ? S.current.female : S.current.male}'
                    .thinText(fontSize: fontSm),
              ],
            ),
          ),
          const SizedBox(
            width: offsetBase,
          ),
          TextButton(
            onPressed: accept,
            child: 'Accept'.mediumText(
              fontSize: fontXSm,
              color: Colors.green,
            ),
          ),
          const SizedBox(
            width: offsetSm,
          ),
          TextButton(
            onPressed: decline,
            child: 'Decline'.mediumText(
              fontSize: fontXSm,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  Widget friendItem({
    Function()? detail,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2.0),
      padding: const EdgeInsets.all(offsetSm),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(offsetSm),
      ),
      child: InkWell(
        onTap: detail,
        child: Row(
          children: [
            LabyrinthAvatar(
              url: usrAvatar!,
              avatarSize: AvatarSize.md,
            ),
            const SizedBox(
              width: offsetBase,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  usrName!.mediumText(),
                  '${usrCountry!} - ${usrGender! == '1' ? S.current.female : S.current.male}'
                      .thinText(fontSize: fontSm),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getAvatarName() {
    return 'A';
  }
}
