import 'package:flutter/material.dart';
import 'variables.dart';

class VerificationPage extends StatefulWidget {
  final ValueChanged<String> didProvideVerificationCode;

  VerificationPage({Key key, this.didProvideVerificationCode})
      : super(key: key);

  @override
  _VerificationPageState createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  TextEditingController _verificationcodecontroller = TextEditingController();

  void _verify() {
    final verificationCode = _verificationcodecontroller.text.trim();
    widget.didProvideVerificationCode(verificationCode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(0, 180, 233, 300),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Introduce el código de verificación.",
                style: farsiSimpleStyle(25, Colors.white, FontWeight.w600)),
            SizedBox(
              height: 10,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(left: 20, right: 20),
              child: TextField(
                controller: _verificationcodecontroller,
                decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    labelText: 'Verification code',
                    prefixIcon: Icon(Icons.email),
                    labelStyle: farsiSimpleStyle(16),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: () => _verify(),
              child: Container(
                width: MediaQuery.of(context).size.width / 2,
                height: 50,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(0, 59, 139, 100),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text("Verificar",
                      style:
                          farsiSimpleStyle(20, Colors.white, FontWeight.w900)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
