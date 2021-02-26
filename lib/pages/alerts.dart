import 'package:flutter/material.dart';
import 'package:safesale/services/auth_service.dart';

class AlertsPage extends StatefulWidget {
  final AuthFlowStatus authstatus;

  const AlertsPage({Key key, this.authstatus}) : super(key: key);
  @override
  _AlertsPageState createState() => _AlertsPageState();
}

class _AlertsPageState extends State<AlertsPage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
