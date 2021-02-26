import 'package:flutter/material.dart';
import 'package:safesale/services/auth_service.dart';

class ProfilePage extends StatefulWidget {
  final AuthFlowStatus authstatus;

  const ProfilePage({Key key, this.authstatus}) : super(key: key);
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
