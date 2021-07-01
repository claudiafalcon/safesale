import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:safesale/models/conversation.dart';
import 'package:safesale/models/message.dart';
import 'package:safesale/painters/softpaint.dart';
import 'package:safesale/services/notification_service.dart';
import 'package:safesale/services/user_service.dart';
import 'package:safesale/variables.dart';

class ChatPage extends StatefulWidget {
  final Conversation conv;
  final String userid;

  const ChatPage({Key key, this.conv, this.userid}) : super(key: key);
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _notiService = NotificationService();
  final _userService = UserService();
  List<Message> messages = <Message>[];
  TextEditingController _message = new TextEditingController();

  Future<bool> initMessages() async {
    messages = await _notiService.getMessageByConvoId(widget.conv.id);
    return true;
  }

  @override
  void dispose() {
    super.dispose();
    _userService.updateUser(widget.userid);
  }

  @override
  void initState() {
    super.initState();
    initMessages();
  }

  void _sendMessage() async {
    if (_message.text != null && _message.text != '') {
      await _notiService.createMessage(
          widget.conv.id, widget.userid, _message.text, '');
      setState(() {
        _message.clear();
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      });
    }
    return null;
  }

  _sendMessageArea() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 8),
        height: 70,
        color: Colors.white,
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _message,
                decoration: InputDecoration.collapsed(
                  hintText: 'Enviar mensaje ...',
                ),
                textCapitalization: TextCapitalization.sentences,
              ),
            ),
            IconButton(
              icon: Icon(Icons.send),
              iconSize: 25,
              color: Theme.of(context).primaryColor,
              onPressed: () => _sendMessage(),
            )
          ],
        ));
  }

  _chatBubble(Message message, bool isMe, bool isSameUser) {
    String stringDate = DateFormat.MMMd('es_MX')
        .add_Hm()
        .format(DateTime.parse(message.createdAt));
    if (isMe) {
      return Column(
        children: [
          Container(
            alignment: Alignment.topRight,
            child: Container(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.8),
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.symmetric(vertical: 5),
              decoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.white.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5)
                  ]),
              child: Text(message.content,
                  style: GoogleFonts.raleway(
                      color: Colors.white,
                      fontSize:
                          MediaQuery.of(context).size.height * factorFontSmall,
                      fontWeight: FontWeight.w600)),
            ),
          ),
          !isSameUser
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(stringDate,
                        style: GoogleFonts.raleway(
                            color: Colors.white54,
                            fontSize: MediaQuery.of(context).size.height *
                                factorFontSmall /
                                1.2,
                            fontWeight: FontWeight.w600)),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      decoration:
                          BoxDecoration(shape: BoxShape.circle, boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                        )
                      ]),
                      child: CircleAvatar(
                        radius: 15,
                        backgroundColor: Colors.white,
                        child: Text('Yo',
                            style: GoogleFonts.raleway(
                                color: Colors.lightBlue,
                                fontSize: MediaQuery.of(context).size.height *
                                    factorFontSmall /
                                    1.2,
                                fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ],
                )
              : Container(child: null)
        ],
      );
    } else {
      if (message.unread) _notiService.updateUnreadMessage(message.id);
      return Column(
        children: [
          Container(
            alignment: Alignment.topLeft,
            child: Container(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.8),
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.symmetric(vertical: 5),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.white.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5)
                  ]),
              child: Text(message.content,
                  style: GoogleFonts.raleway(
                      color: Colors.black54,
                      fontSize:
                          MediaQuery.of(context).size.height * factorFontSmall,
                      fontWeight: FontWeight.w600)),
            ),
          ),
          !isSameUser
              ? Row(
                  children: [
                    Container(
                      decoration:
                          BoxDecoration(shape: BoxShape.circle, boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                        )
                      ]),
                      child: CircleAvatar(
                        radius: 15,
                        backgroundImage: NetworkImage(cloudfronturl +
                            'images/' +
                            widget.conv.property.id +
                            "/" +
                            widget.conv.property.id +
                            "0.jpg"),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(stringDate,
                        style: GoogleFonts.raleway(
                            color: Colors.white54,
                            fontSize: MediaQuery.of(context).size.height *
                                factorFontSmall /
                                1.2,
                            fontWeight: FontWeight.w600))
                  ],
                )
              : Container(child: null)
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        centerTitle: true,
        backgroundColor: Color(0xff003b8b).withOpacity(0.7),
        title: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(children: [
            TextSpan(
                text: widget.conv.name,
                style: GoogleFonts.raleway(
                    color: Colors.white,
                    fontSize:
                        MediaQuery.of(context).size.height * factorFontSmall,
                    fontWeight: FontWeight.w600)),
            TextSpan(text: '\n'),
          ]),
        ),
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            color: Colors.white,
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: (Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Color.fromRGBO(67, 73, 75, 0.8),
          child: CustomPaint(
              painter: PainterSoft(
                  Color.fromRGBO(52, 57, 59, 0.5),
                  Color.fromRGBO(0, 59, 139, 0.5),
                  Color.fromRGBO(52, 57, 59, 0.5),
                  0,
                  20),
              child: Container(
                child: FutureBuilder<void>(
                    future: initMessages(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        String prevUserId = '';
                        return Column(
                          children: [
                            Expanded(
                                child: ListView.builder(
                              reverse: false,
                              padding: EdgeInsets.all(20),
                              itemCount: messages.length,
                              itemBuilder: (BuildContext context, int index) {
                                final Message message = messages[index];
                                final bool isMe =
                                    message.authorId == widget.userid;
                                final isSameUser =
                                    (index == messages.length - 1)
                                        ? false
                                        : (messages[index + 1].authorId ==
                                            message.authorId);
                                return _chatBubble(message, isMe, isSameUser);
                              },
                            )),
                            _sendMessageArea()
                          ],
                        );
                      } else
                        return Container(child: null);
                    }),
              )))),
    );
  }
}
