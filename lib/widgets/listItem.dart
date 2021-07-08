import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safesale/variables.dart';

class ListItem extends StatefulWidget {
  final String parametro;
  final String texto;

  final Color bulletcolor;
  final Color textcolor;
  final double fontsize;
  final bool special;

  const ListItem(
      {this.parametro,
      this.texto,
      this.bulletcolor,
      this.textcolor,
      this.fontsize,
      this.special});

  @override
  _ListItemState createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
          child: Icon(
            Icons.fiber_manual_record,
            color: widget.bulletcolor,
            size: 12.0,
          ),
        ),
        Flexible(
          fit: FlexFit.loose,
          child: RichText(
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            text: TextSpan(
              text: widget.parametro,
              style: GoogleFonts.raleway(
                  textStyle: TextStyle(
                color: Colors.white,
                fontSize: widget.fontsize,
                fontWeight: FontWeight.w800,
              )),
              children: <TextSpan>[
                TextSpan(
                  text: widget.texto,
                  style: GoogleFonts.raleway(
                      color: widget.textcolor,
                      fontSize: widget.fontsize,
                      fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
