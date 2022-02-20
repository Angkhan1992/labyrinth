import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:labyrinth/generated/l10n.dart';
import 'package:labyrinth/models/user_model.dart';
import 'package:labyrinth/providers/dialog_provider.dart';
import 'package:labyrinth/providers/loading_provider.dart';
import 'package:labyrinth/providers/network_provider.dart';
import 'package:labyrinth/providers/socket_provider.dart';
import 'package:labyrinth/themes/colors.dart';
import 'package:labyrinth/themes/dimens.dart';
import 'package:labyrinth/utils/constants.dart';
import 'package:labyrinth/utils/extension.dart';
import 'package:labyrinth/widgets/textfield.dart';

class RequestScreen extends StatefulWidget {
  const RequestScreen({Key? key}) : super(key: key);

  @override
  _RequestScreenState createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  final _searchController = TextEditingController();
  List<UserModel> _searchUsers = [];

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        var search = _searchController.text;
        if (search.isEmpty) {
          _searchContact(search);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 1,
          title: 'Request'.semiBoldText(
            fontSize: fontXMd,
            color: kAccentColor,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: offsetBase,
            vertical: offsetBase,
          ),
          child: Column(
            children: [
              CustomTextField(
                controller: _searchController,
                hintText: 'Search...',
                textInputAction: TextInputAction.done,
                circleConner: true,
                prefixIcon: const Icon(
                  Icons.search,
                ),
                suffixIcon: InkWell(
                  onTap: () {
                    setState(() {
                      _searchUsers.clear();
                      _searchController.text = '';
                    });
                  },
                  child: const Icon(Icons.close),
                ),
                onSubmitted: (value) {
                  if (value.isEmpty) {
                    DialogProvider.of(context).showSnackBar(
                      'The search word should be not empty.',
                      type: SnackBarType.info,
                    );
                    return;
                  }
                  _searchContact(value);
                },
              ),
              const SizedBox(
                height: offsetBase,
              ),
              Expanded(
                child: _searchUsers.isEmpty
                    ? Center(
                        child: 'Not have search result'.regularText(),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          var user = _searchUsers[index];
                          return user.requestItem(
                            request: () async {
                              var currentUser = Provider.of<UserModel>(context,
                                  listen: false);
                              LoadingProvider.of(context).show();
                              var resp = await NetworkProvider.of().post(
                                kSendRequest,
                                {
                                  'senderID': currentUser.id!,
                                  'receiverID': user.id!,
                                },
                              );
                              LoadingProvider.of(context).hide();
                              if (resp != null) {
                                if (resp['ret'] == 10000) {
                                  DialogProvider.of(context).showSnackBar(
                                    resp['msg'],
                                  );
                                  socketService!
                                      .inviteFriend(currentUser.id!, user.id!);
                                } else {
                                  DialogProvider.of(context).showSnackBar(
                                    resp['msg'],
                                    type: SnackBarType.error,
                                  );
                                }
                              } else {
                                DialogProvider.of(context).showSnackBar(
                                  S.current.server_error,
                                  type: SnackBarType.error,
                                );
                              }
                            },
                          );
                        },
                        itemCount: _searchUsers.length,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _searchContact(String value) async {
    _searchUsers.clear();
    var resp = await NetworkProvider.of().post(
      kGetContact,
      {
        'value': value,
      },
    );
    if (resp != null) {
      if (resp['ret'] == 10000) {
        _searchUsers = (resp['result'] as List)
            .map((e) => UserModel()..setFromJson(e))
            .toList();
      }
    }
    setState(() {});
  }
}
