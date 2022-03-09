import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';

import 'package:labyrinth/models/game_model.dart';
import 'package:labyrinth/models/user_model.dart';
import 'package:labyrinth/themes/colors.dart';
import 'package:labyrinth/themes/dimens.dart';
import 'package:labyrinth/themes/shadows.dart';
import 'package:labyrinth/utils/extension.dart';

class RoomModel extends ChangeNotifier {
  String id = '';
  String name = '';
  String amount = '';
  String regDate = '';

  List<UserModel> _users = [];
  List<UserModel> _invites = [];
  List<UserModel> _tours = [];

  var _status = RoomStatus.waiting;

  RoomModel();

  void setFromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['rm_name'];
    amount = json['rm_user_amount'];
    regDate = json['regdate'];
    var status = json['rm_status'];
    _status = RoomStatus.waiting;
    switch (status) {
      case 'prepare':
        _status = RoomStatus.prepare;
        break;
      case 'play':
        _status = RoomStatus.play;
        break;
      case 'result':
        _status = RoomStatus.result;
        break;
    }

    if (json['users'] != null) {
      _users = (json['users'] as List)
          .map((e) => UserModel()..setFromJson(e))
          .toList();
    }
    if (json['invites'] != null) {
      _invites = (json['invites'] as List)
          .map((e) => UserModel()..setFromJson(e))
          .toList();
    }
    if (json['tours'] != null) {
      _tours = (json['tours'] as List)
          .map((e) => UserModel()..setFromJson(e))
          .toList();
    }

    notifyListeners();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'rm_name': name,
      'rm_user_amount': amount,
      'regdate': regDate,
      'users': _users.map((x) => x.toJson()).toList(),
      'invites': _invites.map((x) => x.toJson()).toList(),
      'tours': _tours.map((x) => x.toJson()).toList(),
      'rm_status': _status.rawValue,
    };
  }

  void addUser(UserModel user) {
    for (var listUser in _users) {
      if (listUser.id! == user.id!) {
        return;
      }
    }
    _users.add(user);
    notifyListeners();
  }

  List<UserModel> getUsers() {
    return _users;
  }

  UserModel? getUser(int index) {
    if (index > _users.length - 1) return null;
    return _users[index];
  }

  bool isContainedByUser(UserModel selectedUser) {
    for (var user in _users) {
      if (user.id! == selectedUser.id!) {
        return true;
      }
    }
    return false;
  }

  void removeUser(String userid) {
    for (var user in _users) {
      if (user.id! == userid) {
        _users.remove(user);
        break;
      }
    }
    notifyListeners();
  }

  void addInvites(UserModel viewer) {
    _invites.add(viewer);
    notifyListeners();
  }

  UserModel getInviteUser(int index) {
    return _invites[index];
  }

  List<UserModel> getTours() {
    return _tours;
  }

  bool isContainedByTour(UserModel selectedUser) {
    for (var user in _tours) {
      if (user.id! == selectedUser.id!) {
        return true;
      }
    }
    return false;
  }

  void addTour(UserModel tour) {
    _tours.add(tour);
    notifyListeners();
  }

  List<int> heroPositions() {
    return amount == '4' ? [0, 6, 42, 48] : [0, 48];
  }

  UserModel getTourUser(int index) {
    return _tours[index];
  }

  void setStatus(RoomStatus status) {
    _status = status;
    notifyListeners();
  }

  RoomStatus getStatus() {
    return _status;
  }

  Widget listWidget({
    Function()? detail,
  }) {
    return Bounceable(
      onTap: detail,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: offsetBase,
          vertical: offsetSm,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(offsetSm),
          boxShadow: [
            kTopLeftShadow,
            kBottomRightShadow,
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                amount == '2'
                    ? const Icon(
                        Icons.looks_two_outlined,
                        color: Colors.green,
                        size: 18.0,
                      )
                    : const Icon(
                        Icons.looks_4_outlined,
                        color: Colors.red,
                        size: 18.0,
                      ),
                const SizedBox(
                  width: offsetSm,
                ),
                name.thinText(
                  color: kAccentColor,
                  fontSize: fontSm,
                ),
                const SizedBox(
                  width: offsetBase,
                ),
                for (var index = 0; index < int.parse(amount); index++) ...{
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 1.0),
                    width: 24.0,
                    height: 24.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: heroColors[index],
                    ),
                    child: Center(
                      child: (index < _users.length
                              ? _users[index].getAvatarName()
                              : '?')
                          .boldText(
                        fontSize: fontXSm,
                        color: Colors.white,
                      ),
                    ),
                  ),
                },
              ],
            ),
            const SizedBox(
              height: offsetSm,
            ),
            Row(
              children: [
                'Amount   :   '.regularText(fontSize: fontXSm),
                '${_users.length}/$amount'.mediumText(fontSize: fontXSm),
              ],
            ),
            Row(
              children: [
                'Created   :   '.regularText(fontSize: fontXSm),
                regDate.getFullDate.getUTCFullTime.formatDay
                    .mediumText(fontSize: fontXSm),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

enum RoomStatus {
  waiting,
  prepare,
  play,
  result,
}

extension ERoomStatus on RoomStatus {
  String get rawValue {
    switch (this) {
      case RoomStatus.waiting:
        return 'waiting';
      case RoomStatus.prepare:
        return 'prepare';
      case RoomStatus.play:
        return 'play';
      case RoomStatus.result:
        return 'result';
    }
  }

  bool get isWaiting {
    return this == RoomStatus.waiting;
  }

  bool get isPrepare {
    return this == RoomStatus.prepare;
  }

  bool get isPlay {
    return this == RoomStatus.play;
  }

  bool get isResult {
    return this == RoomStatus.result;
  }
}
