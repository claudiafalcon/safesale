import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safesale/models/conversation.dart';

import 'package:safesale/models/pushnotification.dart';
import 'package:safesale/pages/chats.dart';
import 'package:safesale/painters/softpaint.dart';
import 'package:safesale/services/auth_service.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:safesale/services/notification_service.dart';
import 'package:safesale/services/user_service.dart';
import 'package:safesale/variables.dart';

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

Future<dynamic> _firebaseMessagingBackgroundHandler(
  Map<String, dynamic> message,
) async {
  // Initialize the Firebase app
  await Firebase.initializeApp();
  print('onBackgroundMessage received: $message');
}

class MessagesPage extends StatefulWidget {
  final AuthFlowStatus authstatus;

  const MessagesPage({Key key, this.authstatus}) : super(key: key);
  @override
  _MessagesPageState createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  static final FirebaseMessaging _messaging = FirebaseMessaging();
  int _totalNotifications;
  PushNotification _notificationInfo;

  String userId;

  List<Conversation> result;
  final _userService = UserService();
  final _notiService = NotificationService();

  @override
  void initState() {
    _totalNotifications = 0;
    registerNotification();
    super.initState();
    subscribeConversations();
  }

  void subscribeConversations() async {
    userId = await _userService.getUser().id;
    //await _notiService.subscribeConvos(userId);
  }

  void registerNotification() async {
    // Initialize the Firebase app

    // On iOS, this helps to take the user permissions
    await _messaging.requestNotificationPermissions(
      IosNotificationSettings(
        alert: true,
        badge: true,
        provisional: false,
        sound: true,
      ),
    );

    // For handling the received notifications
    _messaging.configure(
      onMessage: (message) async {
        print('onMessage received: $message');

        PushNotification notification = PushNotification.fromJson(message);

        setState(() {
          _notificationInfo = notification;
          _totalNotifications++;
        });

        // For displaying the notification as an overlay
        /*  showSimpleNotification(
          Text(_notificationInfo.title),
          leading: NotificationBadge(totalNotifications: _totalNotifications),
          subtitle: Text(_notificationInfo.body),
          background: Colors.cyan[700],
          duration: Duration(seconds: 2),
        );*/
      },
      onBackgroundMessage: _firebaseMessagingBackgroundHandler,
      onLaunch: (message) async {
        print('onLaunch: $message');

        PushNotification notification = PushNotification.fromJson(message);

        setState(() {
          _notificationInfo = notification;
          _totalNotifications++;
        });
      },
      onResume: (message) async {
        print('onResume: $message');

        PushNotification notification = PushNotification.fromJson(message);

        setState(() {
          _notificationInfo = notification;
          _totalNotifications++;
        });
      },
    );

    // Used to get the current FCM token
    _messaging.getToken().then((token) {
      print('Token: $token');
    }).catchError((e) {
      print(e);
    });
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
                  } else {
                    result = _userService.getUser().convs;
                    return SingleChildScrollView(
                      child: Container(
                        height: MediaQuery.of(context).size.height *
                            (1 -
                                (factorBottonHeigh +
                                    factorPropertyTitle +
                                    factorVerticalSpace)),
                        child: SingleChildScrollView(
                          child: Column(
                            children: _createConvoList(result),
                          ),
                        ),
                      ),
                    );
                  }
                })
          ])),
    );
  }

  List<Widget> _createConvoList(List<Conversation> list) {
    return new List<Widget>.generate(list.length, (index) {
      Conversation item = list[index];
      StringBuffer text = StringBuffer();
      return GestureDetector(
        onTap: () => Navigator.of(context, rootNavigator: true).push(
            MaterialPageRoute(
                builder: (_) => ChatPage(conv: item, userid: userId))),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 5,
                  ),
                  color: Colors.white,
                  height: MediaQuery.of(context).size.height / 12 * 1,
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width / 10 * 1.5,
                        height: MediaQuery.of(context).size.width / 10 * 1.5,
                        padding: EdgeInsets.all(2),
                        decoration: item.unreadMessage
                            ? BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50)),
                                border: Border.all(
                                    width: 2,
                                    color: Theme.of(context).primaryColor),
                                //  shape: BoxShape.circle,
                                boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                    )
                                  ])
                            : BoxDecoration(shape: BoxShape.circle, boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                )
                              ]),
                        child: CircleAvatar(
                          radius: 35,
                          backgroundImage: NetworkImage(cloudfronturl +
                              'images/' +
                              item.property.id +
                              "/" +
                              item.property.id +
                              "0.jpg"),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 10 * 7,
                        padding: EdgeInsets.only(left: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                                width: MediaQuery.of(context).size.width /
                                    10 *
                                    4.5,
                                child: Text(
                                  item.name,
                                  style: GoogleFonts.raleway(
                                      color: Color.fromRGBO(0, 59, 139, 1),
                                      fontSize:
                                          MediaQuery.of(context).size.height *
                                              factorFontSmall,
                                      fontWeight: FontWeight.w600),
                                  textAlign: TextAlign.start,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                )),
                            Text(
                              item.dateUnreadMessage,
                              textAlign: TextAlign.end,
                              style: GoogleFonts.raleway(
                                  color: Colors.black54,
                                  fontSize: MediaQuery.of(context).size.height *
                                      factorFontSmall,
                                  fontWeight: FontWeight.w300),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )),
            ),
          ),
        ),
      );
    });
  }
}
