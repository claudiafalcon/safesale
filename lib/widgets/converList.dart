import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safesale/models/conversation.dart';
import 'package:safesale/pages/chats.dart';
import 'package:safesale/variables.dart';

class ConverList extends StatefulWidget {
  final List<Conversation> list;
  final bool iaminchat;
  final void Function(bool) setiaminchat;
  final conversationid;
  final String userId;
  const ConverList({
    this.list,
    this.conversationid,
    this.userId,
    Key key,
    this.iaminchat,
    this.setiaminchat,
  }) : super(key: key);

  @override
  _ConverListState createState() => _ConverListState();
}

class _ConverListState extends State<ConverList> {
  Conversation conv;

  List<Widget> _createConvoList(List<Conversation> list) {
    conv = null;
    return new List<Widget>.generate(list.length, (index) {
      Conversation item = list[index];
      if (widget.conversationid == item.id) conv = list[index];

      return GestureDetector(
        onTap: () {
          print("Si entra al tap");
          Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
              builder: (_) => ChatPage(
                    conv: item,
                    userid: widget.userId,
                    iaminchat: widget.setiaminchat,
                  )));
        },
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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (conv != null && !widget.iaminchat) {
        if (Navigator.of(context, rootNavigator: true).canPop())
          Navigator.of(context, rootNavigator: true).pop(context);
        Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
            builder: (_) => ChatPage(
                conv: conv,
                userid: widget.userId,
                iaminchat: widget.setiaminchat)));
      }
    });
    return Column(children: _createConvoList(widget.list));
  }
}
