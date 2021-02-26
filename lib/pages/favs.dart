import 'package:flutter/material.dart';
import 'package:safesale/services/auth_service.dart';

class FavsPage extends StatefulWidget {
  final AuthFlowStatus authstatus;

  const FavsPage({Key key, this.authstatus}) : super(key: key);
  @override
  _FavsPageState createState() => _FavsPageState();
}

class _FavsPageState extends State<FavsPage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
