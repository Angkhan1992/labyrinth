import 'package:flutter/material.dart';
import 'package:labyrinth/generated/l10n.dart';
import 'package:labyrinth/themes/colors.dart';
import 'package:labyrinth/themes/dimens.dart';
import 'package:labyrinth/utils/extension.dart';

class BlogScreen extends StatefulWidget {
  const BlogScreen({
    Key? key,
  }) : super(key: key);

  @override
  _BlogScreenState createState() => _BlogScreenState();
}

class _BlogScreenState extends State<BlogScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: S.current.blog.semiBoldText(
          fontSize: fontXMd,
          color: kAccentColor,
        ),
        leading: Container(),
      ),
    );
  }
}
