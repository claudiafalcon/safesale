import 'package:flutter/material.dart';
import 'package:safesale/auth_credentials.dart';
import 'package:safesale/policy.dart';
import 'package:safesale/variables.dart';

class SignUp extends StatefulWidget {
  final ValueChanged<SignUpCredentials> didProvideCredentials;
  final VoidCallback shouldShowLogin;
  SignUp({Key key, this.didProvideCredentials, this.shouldShowLogin})
      : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();

  registeruser() {
    final username = emailcontroller.text.trim();
    final password = passwordcontroller.text.trim();
    print('Successfully configured Amplify  222🎉');
    final credentials =
        SignUpCredentials(username: username, password: password);

    print('Successfully configured Amplify  333🎉');

    widget.didProvideCredentials(credentials);
    print('AAA ${credentials.username}');
    return;
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
            Text("Registrate",
                style: farsiSimpleStyle(25, Colors.white, FontWeight.w600)),
            SizedBox(
              height: 10,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(left: 20, right: 20),
              child: TextField(
                controller: emailcontroller,
                decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                    labelStyle: farsiSimpleStyle(16),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(left: 20, right: 20),
              child: TextField(
                controller: passwordcontroller,
                decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock),
                    labelStyle: farsiSimpleStyle(16),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(left: 20, right: 20),
              child: TextField(
                decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    labelText: 'Repite tu Password',
                    prefixIcon: Icon(Icons.lock),
                    labelStyle: farsiSimpleStyle(16),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: () => registeruser(),
              child: Container(
                width: MediaQuery.of(context).size.width / 2,
                height: 50,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(0, 59, 139, 100),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text("Registrate",
                      style:
                          farsiSimpleStyle(20, Colors.white, FontWeight.w900)),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Estoy de acuuerdo con ", style: farsiSimpleStyle(16)),
                SizedBox(width: 10),
                InkWell(
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => TermsofPolicy())),
                  child: Text("Politicas de Privacidad",
                      style: farsiSimpleStyle(16,
                          Color.fromRGBO(0, 59, 139, 100), FontWeight.bold)),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
