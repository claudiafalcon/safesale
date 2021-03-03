import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safesale/auth/formvalidator.dart';

final double factorFooterIconSize = 0.03;
final double factorRighBarVideoIconSize = 0.03;
final double factorRighBarFilterIconSize = 0.05;
final double factorBottonHeigh = 0.1;
final double factorAuthLogoWd = 0.16;

final double factorPropertyTitle = 0.15;
final double factorVerticalSpace = 0.05;
final double factorPaddingSpace = 0.08;

final String cloudfronturl = 'https://didsugvpn60.cloudfront.net/public/';

farsiSimpleStyle(double size, [Color color, FontWeight fw = FontWeight.w400]) {
  return TextStyle(
      fontFamily: 'Farsi', fontSize: size, color: color, fontWeight: fw);
}

getInputGetStyle() {
  return GoogleFonts.raleway(
      textStyle: TextStyle(
    color: Color(0xff003b8b),
    fontSize: 22,
    fontWeight: FontWeight.w600,
  ));
}

getInputDecoration(String hintText) {
  return InputDecoration(
      contentPadding: const EdgeInsets.only(left: 0.0, top: 15, bottom: 15),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: Colors.white, width: 0.0),
      ),
      fillColor: Color.fromRGBO(255, 255, 255, 0.9),
      filled: true,
      hintText: hintText,
      hintStyle: GoogleFonts.raleway(
          textStyle: TextStyle(
        color: Color(0xff003b8b),
        fontSize: 22,
        fontWeight: FontWeight.w600,
      )),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
      ));
}

class InputDecorationPass extends StatefulWidget {
  final controller;
  final text;
  final isPassword;
  final validator;

  const InputDecorationPass(
      {Key key,
      this.controller,
      this.text,
      this.isPassword = false,
      this.validator})
      : super(key: key);

  @override
  _InputDecorationPassState createState() => _InputDecorationPassState();
}

class _InputDecorationPassState extends State<InputDecorationPass> {
  bool _isObscure;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isObscure = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    double _padding = widget.isPassword == true ? 60.0 : 15;
    return TextFormField(
      obscureText: _isObscure,
      style: GoogleFonts.raleway(
          textStyle: TextStyle(
        color: Color(0xff003b8b),
        fontSize: 22,
        fontWeight: FontWeight.w600,
      )),
      controller: widget.controller,
      validator: (String value) {
        if (widget.validator == "email")
          return FormValidator().validateEmail(value);
        if (widget.validator == "password")
          return FormValidator().validatePassword(value);
        return FormValidator().validateNull();
      },
      decoration: InputDecoration(
          contentPadding: EdgeInsets.only(left: 15, top: 15, bottom: 15),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: Colors.white, width: 0.0),
          ),
          fillColor: Color.fromRGBO(255, 255, 255, 0.9),
          filled: true,
          hintText: widget.text,
          hintStyle: GoogleFonts.raleway(
              textStyle: TextStyle(
            color: Color(0xff003b8b),
            fontSize: 22,
            fontWeight: FontWeight.w600,
          )),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          suffixIcon: widget.isPassword == true
              ? IconButton(
                  icon: Icon(
                      _isObscure ? Icons.visibility : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      _isObscure = !_isObscure;
                    });
                  })
              : null),
      textAlign: TextAlign.center,
    );
  }
}
