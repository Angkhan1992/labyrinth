import 'package:flutter/material.dart';

class WhyJoinScreen extends StatefulWidget {
  final String userid;
  final Function() next;
  final Function() previous;
  final Function(bool) progress;

  const WhyJoinScreen({
    Key? key,
    required this.userid,
  }) : super(key: key);

  @override
  _WhyJoinScreenState createState() => _WhyJoinScreenState();
}

class _WhyJoinScreenState extends State<WhyJoinScreen> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
