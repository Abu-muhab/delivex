import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:node_auth/providers/auth.dart';
import 'package:node_auth/widgets/action_button.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';

TextEditingController emailController = TextEditingController();
TextEditingController passwordController = TextEditingController();

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        color: Color(0xFF730099),
        child: ListView(
          children: <Widget>[
            SizedBox(
              width: size.width,
              height: size.height,
              child: Stack(
                children: <Widget>[
                  Container(
                    color: Colors.white,
                  ),
                  ClipPath(
                    clipper: CustomPath(style: 3),
                    child: Container(color: Color(0xFF730099)),
                  ),
                  Positioned(
                    top: size.height / 2.2 - size.height * 0.4 / 2,
                    left: size.width / 2 - size.height * 0.4 / 2,
                    child: SizedBox(
                      width: size.height * 0.4,
                      height: size.height * 0.4,
                      child: Image.asset("images/delivery2.png"),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.only(left: 20, right: 20, bottom: 50),
                      child: LoginForm(
                        size: size,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  final Size size;
  LoginForm({this.size});
  @override
  State createState() => LoginFormState();
}

class LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  Size size;
  @override
  void initState() {
    size = widget.size;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: getValueForScreenType<double>(
          context: context, mobile: double.infinity, tablet: 500, desktop: 500),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Card(
              elevation: 4,
              color: Color.fromARGB(170, 255, 255, 255),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(5),
                      child: TextFormField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Enter email";
                          }
                          return null;
                        },
                        controller: emailController,
                        decoration: InputDecoration(
                            border: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black)),
                            hintText: "Email",
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black))),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(5),
                      child: TextFormField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Enter password";
                          }
                          return null;
                        },
                        obscureText: true,
                        controller: passwordController,
                        decoration: InputDecoration(
                            border: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black)),
                            hintText: "Password",
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black))),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(5),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "Sign in",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.w500),
                          ),
                          ActionButtonOval(
                            onClick: () async {
                              if (_formKey.currentState.validate()) {
                                return Provider.of<AuthProvider>(context,
                                        listen: false)
                                    .login(emailController.text.trim(),
                                        passwordController.text.trim())
                                    .catchError((err) {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          content: Text(err.toString()),
                                          actions: [
                                            FlatButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text("CLOSE"))
                                          ],
                                        );
                                      });
                                });
                              }
                            },
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: size.height * 0.08),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  SizedBox(
                    width: 130,
                    height: 50,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      color: Colors.deepPurple,
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, "signUp");
                      },
                      child: Center(
                        child: Text(
                          "Sign up",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Text(
                      "Forgot Password",
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Colors.black,
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CustomPath extends CustomClipper<Path> {
  int style = 1;
  CustomPath({this.style});
  @override
  Path getClip(Size size) {
    final path = Path();
    if (style == 1) {
      path.moveTo(0, size.height / 2);
      path.cubicTo(size.width / 2, size.height / 1.3, size.width * 0.8,
          size.height / 3, size.width * 1.2, size.height / 2.5);
      path.lineTo(size.width, 0);
      path.lineTo(0, 0);
    } else if (style == 2) {
      path.moveTo(0, size.height / 2);
      path.cubicTo(size.width / 2, size.height / 2.3, size.width * 0.8,
          size.height / 2, size.width * 1.2, size.height / 1.5);
      path.lineTo(size.width, 0);
      path.lineTo(0, 0);
    } else if (style == 3) {
      path.moveTo(0, size.height / 2);
      path.cubicTo(size.width / 2, size.height / 2.3, size.width * 0.1,
          size.height / 2, size.width * 1.2, size.height / 1.3);
      path.lineTo(size.width, 0);
      path.lineTo(0, 0);
    } else if (style == 4) {
      path.moveTo(0, size.height / 1.5);
      path.quadraticBezierTo(
          size.width / 2, size.height * 0.9, size.width, size.height / 1.5);
      path.lineTo(size.width, 0);
      path.lineTo(0, 0);
    } else if (style == 5) {
      path.moveTo(0, 45);
      path.lineTo(45, 0);
      path.lineTo(size.width, 0);
      path.lineTo(size.width, size.height);
      path.lineTo(0, size.height);
    }
    return path;
  }

  @override
  bool shouldReclip(CustomPath oldClipper) {
    return true;
  }
}
