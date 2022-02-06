import 'package:flutter/material.dart';

class PasswordScreen extends StatefulWidget {
  final Function() next;
  final Function() previous;

  const PasswordScreen({
    Key? key,
    required this.next,
    required this.previous,
  }) : super(key: key);

  @override
  _PasswordScreenState createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
