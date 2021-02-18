import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ListItem extends StatefulWidget {
  final String parametro;
  final String texto;

  final Color bulletcolor;
  final Color textcolor;
  final double fontsize;

  const ListItem(
      {this.parametro,
      this.texto,
      this.bulletcolor,
      this.textcolor,
      this.fontsize});

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
        Text(widget.parametro,
            style: GoogleFonts.raleway(
              textStyle: TextStyle(
                color: widget.textcolor,
                fontSize: widget.fontsize,
                fontWeight: FontWeight.w600,
              ),
            )),
        Flexible(
          fit: FlexFit.loose,
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: Text(widget.texto,
                textAlign: TextAlign.left,
                style: GoogleFonts.raleway(
                  textStyle: TextStyle(
                    color: widget.textcolor,
                    fontSize: widget.fontsize,
                  ),
                )),
          ),
        )
      ],
    );
  }
}
