import 'package:flutter/material.dart';
import 'package:node_auth/providers/auth.dart';

import 'package:node_auth/views/login.dart';
import 'package:node_auth/widgets/action_button.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';

class SignUp extends StatelessWidget {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        Size size = MediaQuery.of(context).size;
        return Scaffold(
          body: Container(
            color: Color(0xFF5FA986),
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
                        clipper: CustomPath(style: 2),
                        child: Container(
                          color: Color(0xFF5FA986),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: EdgeInsets.all(20),
                              child: InkWell(
                                onTap: () {
                                  Navigator.pushReplacementNamed(
                                      context, "home");
                                },
                                child: Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: size.height / 2.75 - size.height * 0.3 / 1.4,
                        left: size.width / 2 - size.height * 0.3 / 2,
                        child: SizedBox(
                          width: size.height * 0.3,
                          height: size.height * 0.3,
                          child: Card(
                            shape: CircleBorder(),
                            color: Colors.white,
                            elevation: 3,
                            child: ClipOval(
                              child: Image.asset("images/signup.png"),
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding:
                              EdgeInsets.only(left: 20, right: 20, bottom: 50),
                          child: SizedBox(
                            width: getValueForScreenType<double>(
                                mobile: double.infinity,
                                tablet: 500,
                                desktop: 500,
                                context: context),
                            child: Form(
                              key: formKey,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Expanded(
                                          child: Padding(
                                        padding: EdgeInsets.all(5),
                                        child: TextFormField(
                                          controller: firstNameController,
                                          validator: (value) {
                                            if (value.isEmpty) {
                                              return "Enter First Name";
                                            }
                                            return null;
                                          },
                                          decoration: InputDecoration(
                                              border: UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.black)),
                                              hintText: "First Name",
                                              focusedBorder:
                                                  UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color:
                                                              Colors.black))),
                                        ),
                                      )),
                                      Expanded(
                                          child: Padding(
                                        padding: EdgeInsets.all(5),
                                        child: TextFormField(
                                          controller: lastNameController,
                                          validator: (value) {
                                            if (value.isEmpty) {
                                              return "Enter Last Name";
                                            }
                                            return null;
                                          },
                                          decoration: InputDecoration(
                                              border: UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.black)),
                                              hintText: "Last Name",
                                              focusedBorder:
                                                  UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color:
                                                              Colors.black))),
                                        ),
                                      ))
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(5),
                                    child: TextFormField(
                                      controller: phoneController,
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return "Enter phone number";
                                        }

                                        if (value.length < 10) {
                                          return "Phone number not valid";
                                        }
                                        if (value.length == 11 &&
                                            value[0] != "0") {
                                          return "Phone number not valid";
                                        }

                                        if (value.length > 11) {
                                          return "Phone number not valid";
                                        }
                                        return null;
                                      },
                                      keyboardType: TextInputType.phone,
                                      decoration: InputDecoration(
                                          prefixText: "+234 ",
                                          prefixStyle:
                                              TextStyle(color: Colors.grey),
                                          border: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.black)),
                                          hintText: "Phone",
                                          focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.black))),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(5),
                                    child: SizedBox(
                                      height: 50,
                                      child: TextFormField(
                                        controller: emailController,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return "Enter email";
                                          }

                                          if (!validateEmail(value.trim())) {
                                            return "Email not valid";
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                            border: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.black)),
                                            hintText: "Email",
                                            focusedBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.black))),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(5),
                                    child: TextFormField(
                                      obscureText: true,
                                      controller: passwordController,
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return "Enter password";
                                        }

                                        if (value.length < 6) {
                                          return "Password must be more than 6 or more charcters long";
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                          border: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.black)),
                                          hintText: "Password",
                                          focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.black))),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(5),
                                    child: TextFormField(
                                      obscureText: true,
                                      controller: confirmPasswordController,
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return "Confirm password";
                                        }

                                        if (value != passwordController.text) {
                                          return "Password does not match";
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                          border: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.black)),
                                          hintText: "Confirm password",
                                          focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.black))),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          "Sign up",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        ActionButtonOval(
                                          onClick: () async {
                                            if (formKey.currentState
                                                .validate()) {
                                              return Provider.of<AuthProvider>(
                                                      context,
                                                      listen: false)
                                                  .signUp(
                                                      emailController.text,
                                                      passwordController.text,
                                                      firstNameController.text,
                                                      lastNameController.text,
                                                      phoneController.text)
                                                  .then((val) {
                                                if (val != null) {
                                                  Navigator
                                                      .pushReplacementNamed(
                                                          context, "home");
                                                }
                                              }).catchError((err) {
                                                showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return AlertDialog(
                                                        content: Text(
                                                            err.toString()),
                                                        actions: [
                                                          FlatButton(
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child:
                                                                  Text("CLOSE"))
                                                        ],
                                                      );
                                                    });
                                              });
                                            }
                                          },
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
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
      },
    );
  }
}

bool validateEmail(String value) {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = new RegExp(pattern);
  if (!regex.hasMatch(value)) {
    return false;
  } else {
    return true;
  }
}
