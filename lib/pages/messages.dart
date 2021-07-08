import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safesale/models/conversation.dart';

import 'package:safesale/pages/chats.dart';
import 'package:safesale/painters/softpaint.dart';
import 'package:safesale/services/auth_service.dart';

import 'package:safesale/services/user_service.dart';
import 'package:safesale/variables.dart';
import 'package:safesale/widgets/converList.dart';

class NotificationBadge extends StatelessWidget {
  final int totalNotifications;

  const NotificationBadge({@required this.totalNotifications});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40.0,
      height: 40.0,
      decoration: new BoxDecoration(
        color: Colors.red,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            '$totalNotifications',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ),
    );
  }
}

class MessagesPage extends StatefulWidget {
  final AuthFlowStatus authstatus;
  final String conversationid;

  final void Function() resetNoti;

  const MessagesPage(
      {Key key, this.authstatus, this.conversationid, this.resetNoti})
      : super(key: key);
  @override
  _MessagesPageState createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  String userId;

  List<Conversation> result;
  final _userService = UserService();

  @override
  void initState() {
    super.initState();
  }

  bool _iaminchat = false;

  void setiaminchat(bool iaminchat) {
    _iaminchat = iaminchat;
    widget.resetNoti();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromRGBO(67, 73, 75, 0.8),
      child: CustomPaint(
          painter: PainterSoft(
              Color.fromRGBO(52, 57, 59, 0.5),
              Color.fromRGBO(0, 59, 139, 0.5),
              Color.fromRGBO(52, 57, 59, 0.5),
              0,
              20),
          child: Column(children: [
            Container(
                padding: EdgeInsets.all(factorPaddingSpace * 100),
                height:
                    MediaQuery.of(context).size.height * factorPropertyTitle,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                        child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: SizedBox(
                                height: MediaQuery.of(context).size.height *
                                    factorPropertyTitle,
                                child: Align(
                                    alignment: Alignment.bottomLeft,
                                    child: Text(
                                      "Mis Mensajes",
                                      style: GoogleFonts.raleway(
                                          textStyle: TextStyle(
                                        color: Colors.white,
                                        fontSize:
                                            MediaQuery.of(context).size.height <
                                                    800
                                                ? 24
                                                : 32,
                                        fontWeight: FontWeight.bold,
                                      )),
                                    ))))),
                  ],
                )),
            StreamBuilder<UserState>(
                stream: _userService.getUserStreamController().stream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData ||
                      snapshot.data.userFlowStatus == UserFlowStatus.started) {
                    return Container(); // LoadingPage();
                  } else if (snapshot.data.userFlowStatus ==
                      UserFlowStatus.empty) {
                    return Stack(
                      children: [
                        Container(),
                      ],
                    );
                  } else if (snapshot.connectionState ==
                      ConnectionState.active) {
                    result = _userService.getUser().convs;
                    userId = _userService.getUser().id;
                    return SingleChildScrollView(
                      child: Container(
                        height: MediaQuery.of(context).size.height *
                            (1 -
                                (factorBottonHeigh +
                                    factorPropertyTitle +
                                    factorVerticalSpace)),
                        child: SingleChildScrollView(
                          child: ConverList(
                              list: result,
                              conversationid: widget.conversationid,
                              userId: userId,
                              iaminchat: _iaminchat,
                              setiaminchat: setiaminchat),
                        ),
                      ),
                    );
                  } else {
                    return Container();
                  }
                })
          ])),
    );
  }
}
