import 'package:flutter/material.dart';
import 'package:safesale/auth_credentials.dart';
import 'variables.dart';

class LoginPage extends StatefulWidget {
  final ValueChanged<LoginCredentials> didProvideCredentials;
  final VoidCallback shouldShowsSingUp;

  LoginPage({Key key, this.didProvideCredentials, this.shouldShowsSingUp})
      : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();

  void _login() {
    final username = emailcontroller.text.trim();
    final password = passwordcontroller.text.trim();
    print('Successfully configured Amplify2 🎉');

    final credentials =
        LoginCredentials(username: username, password: password);
    widget.didProvideCredentials(credentials);
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
            Text("Bienvenido a Safe Sale",
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
            InkWell(
              onTap: () => _login(),
              child: Container(
                width: MediaQuery.of(context).size.width / 2,
                height: 50,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(0, 59, 139, 100),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text("Login",
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
                Text("¿No tienes cuenta?", style: farsiSimpleStyle(16)),
                SizedBox(width: 10),
                InkWell(
                  onTap: widget.shouldShowsSingUp,
                  child: Text("Registrate",
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
