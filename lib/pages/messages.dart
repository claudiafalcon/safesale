import 'package:flutter/material.dart';
import 'package:safesale/services/auth_service.dart';

class MessagesPage extends StatefulWidget {
  final AuthFlowStatus authstatus;

  const MessagesPage({Key key, this.authstatus}) : super(key: key);
  @override
  _MessagesPageState createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
