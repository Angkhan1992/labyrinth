import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';

import 'package:labyrinth/models/game_model.dart';
import 'package:labyrinth/models/user_model.dart';
import 'package:labyrinth/themes/colors.dart';
import 'package:labyrinth/themes/dimens.dart';
import 'package:labyrinth/themes/shadows.dart';
import 'package:labyrinth/utils/constants.dart';
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

  final List<List<List<int>>> _boardData = [];
  int _playCounter = 0;
  List<List<int>> _freeCard = kCard3Type[0];
  int _moveIndex = -1;

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

  void addUser(
    UserModel user, {
    Function(UserModel)? joinAll,
  }) {
    for (var listUser in _users) {
      if (listUser.id! == user.id!) {
        return;
      }
    }
    _users.add(user);
    if ('${_users.length}' == amount) {
      if (joinAll != null) joinAll(_users.first);
    }
    notifyListeners();
  }

  List<UserModel> getUsers() {
    return _users;
  }

  int getUserIndex(UserModel user) {
    for (var value in _users) {
      if (value.id == user.id) {
        return _users.indexOf(value);
      }
    }
    return 0;
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

  bool isOwner(UserModel user) {
    if (_users.isEmpty) return false;
    return _users.first.id! == user.id!;
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

  List<int> heroPlayPositions() {
    return amount == '4' ? [0, 8, 72, 80] : [0, 80];
  }

  List<int> emptyPositions() {
    return [
      0,
      1,
      3,
      5,
      7,
      8,
      9,
      27,
      45,
      63,
      72,
      17,
      35,
      53,
      71,
      80,
      73,
      75,
      77,
      79
    ];
  }

  List<int> navTopPositions() {
    return [2, 4, 6];
  }

  List<int> navLeftPositions() {
    return [18, 36, 54];
  }

  List<int> navRightPositions() {
    return [26, 44, 62];
  }

  List<int> navBottomPositions() {
    return [74, 76, 78];
  }

  List<int> startPositions() {
    return [10, 16, 70, 64];
  }

  List<int> fixedPositions() {
    return [12, 14, 28, 30, 32, 34, 46, 48, 50, 52, 66, 68];
  }

  List<int> flexiblePositions() {
    return [
      11,
      13,
      15,
      19,
      20,
      21,
      22,
      23,
      24,
      25,
      29,
      31,
      33,
      37,
      38,
      39,
      40,
      41,
      42,
      43,
      47,
      49,
      51,
      55,
      56,
      57,
      58,
      59,
      60,
      61,
      65,
      67,
      69,
    ];
  }

  UserModel getTourUser(int index) {
    return _tours[index];
  }

  void setStatus(RoomStatus status) {
    _status = status;
    notifyListeners();
  }

  void initBoard() {
    _boardData.clear();
    for (var i = 0; i < 5; i++) {
      var length = kCard3Type.length;
      var index = Random().nextInt(length - 1);
      _boardData.add(kCard3Type[index]);
    }
    for (var i = 0; i < 12; i++) {
      var length = kCard21Type.length;
      var index = Random().nextInt(length - 1);
      _boardData.add(kCard21Type[index]);
    }
    for (var i = 0; i < 16; i++) {
      var length = kCard22Type.length;
      var index = Random().nextInt(length - 1);
      _boardData.add(kCard22Type[index]);
    }

    for (var i = 0; i < 330; i++) {
      var first = Random().nextInt(32);
      var second = Random().nextInt(32);
      var value = _boardData[first];
      _boardData[first] = _boardData[second];
      _boardData[second] = value;
    }
    notifyListeners();
  }

  void setPlayCounter(int counter) {
    _playCounter = counter;
    notifyListeners();
  }

  int getPlayCounter() {
    return _playCounter;
  }

  void setMoveIndex(int index) {
    _moveIndex = index;
    notifyListeners();
  }

  int getMoveIndex() {
    return _moveIndex;
  }

  void setBoardData(List<dynamic> data) {
    _boardData.clear();
    for (var a in data) {
      List<List<int>> groupA = [];
      for (var b in (a as List<dynamic>)) {
        List<int> groupB = [];
        for (var c in (b as List<dynamic>)) {
          groupB.add(int.parse(c.toString()));
        }
        groupA.add(groupB);
      }
      _boardData.add(groupA);
    }
    notifyListeners();
  }

  List<List<List<int>>> getBoardData() {
    return _boardData;
  }

  List<List<int>> getFreeCard() {
    return _freeCard;
  }

  void setFreeCard(List<List<int>> data) {
    _freeCard = data;
    notifyListeners();
  }

  RoomStatus getStatus() {
    return _status;
  }

  Widget listWidget({
    Function()? detail,
    bool isStatus = false,
  }) {
    String status = _status.rawValue.toUpperCase();
    Color color = Colors.white;

    switch (_status) {
      case RoomStatus.waiting:
        color = Colors.white;
        break;
      case RoomStatus.prepare:
        color = Colors.blue;
        break;
      case RoomStatus.play:
        color = Colors.red;
        break;
      case RoomStatus.result:
        color = Colors.green;
        break;
    }

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
                const Spacer(),
                if (isStatus)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4.0,
                      vertical: 2.0,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: color,
                      ),
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: status.thinText(
                      fontSize: fontXSm,
                      color: color,
                    ),
                  ),
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
