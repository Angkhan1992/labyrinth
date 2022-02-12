import 'package:flutter/material.dart';
import 'package:labyrinth/generated/l10n.dart';
import 'package:labyrinth/themes/colors.dart';
import 'package:labyrinth/themes/dimens.dart';
import 'package:labyrinth/utils/extension.dart';
import 'package:line_icons/line_icons.dart';

class CoinModel {
  String? id;
  String? title;
  String? desc;
  String? purchaseKey;
  String? value;
  String? price;
  String? regDate;
  String? other;

  CoinModel({
    this.id,
    this.title,
    this.desc,
    this.purchaseKey,
    this.value,
    this.price,
    this.regDate,
    this.other,
  });

  factory CoinModel.fromJson(Map<String, dynamic> json) {
    return CoinModel(
      id: json["cin_id"],
      title: json["cin_title"],
      desc: json["cin_desc"],
      purchaseKey: json["cin_purchase_key"],
      value: json["cin_value"],
      price: json["cin_price"],
      regDate: json["reg_date"],
      other: json["other"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "cin_id": id,
      "cin_title": title,
      "cin_desc": desc,
      "cin_purchase_key": purchaseKey,
      "cin_value": value,
      "cin_price": price,
      "reg_date": regDate,
      "other": other,
    };
  }

  Widget inAppWidget({
    Function()? buy,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(offsetSm),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: offsetBase,
          vertical: offsetSm,
        ),
        child: InkWell(
          onTap: buy,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    title!.semiBoldText(color: kAccentColor),
                    desc!.thinText(
                      fontSize: fontXSm,
                      textAlign: TextAlign.start,
                    ),
                    const SizedBox(
                      height: offsetXSm,
                    ),
                    '${S.current.price} : \$${double.parse(price!) / 100}'
                        .boldText(
                      color: Colors.red,
                      fontSize: fontSm,
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 48.0,
                child: Column(
                  children: [
                    const Icon(
                      LineIcons.coins,
                      color: kAccentColor,
                      size: 28.0,
                    ),
                    value!.mediumText(
                      color: kAccentColor,
                      fontSize: fontSm,
                    ),
                    S.current.coins.thinText(
                      color: kAccentColor,
                      fontSize: fontXSm,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
