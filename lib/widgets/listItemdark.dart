import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ListItemBold extends StatefulWidget {
  final String parametro;
  final String texto;

  final Color bulletcolor;
  final Color textcolor;
  final double fontsize;

  const ListItemBold({
    this.parametro,
    this.texto,
    this.bulletcolor,
    this.textcolor,
    this.fontsize,
  });

  @override
  _ListItemBoldState createState() => _ListItemBoldState();
}

class _ListItemBoldState extends State<ListItemBold> {
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
                      fontStyle: FontStyle.italic)),
              children: <TextSpan>[
                TextSpan(
                  text: widget.texto,
                  style: GoogleFonts.raleway(
                      color: widget.textcolor,
                      fontSize: widget.fontsize,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
