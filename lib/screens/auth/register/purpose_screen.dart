import 'package:flutter/material.dart';

class PurposeScreen extends StatefulWidget {
  final String userid;
  final Function() next;
  final Function() previous;
  final Function(bool) progress;

  const PurposeScreen({
    Key? key,
    required this.userid,
    required this.next,
    required this.previous,
    required this.progress,
  }) : super(key: key);

  @override
  _PurposeScreenState createState() => _PurposeScreenState();
}

class _PurposeScreenState extends State<PurposeScreen> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
