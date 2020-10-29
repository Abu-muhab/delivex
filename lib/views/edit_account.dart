import 'package:flutter/material.dart';
import 'package:node_auth/constants/colors.dart';
import 'package:node_auth/constants/screen_size.dart';
import 'package:node_auth/models/user.dart';
import 'package:node_auth/providers/auth.dart';
import 'package:node_auth/views/login.dart';
import 'package:node_auth/widgets/custom_indicator.dart';
import 'package:provider/provider.dart';

class EditAccount extends StatefulWidget {
  @override
  _EditAccountState createState() => _EditAccountState();
}

class _EditAccountState extends State<EditAccount> {
  int buildCount = 0;
  TextEditingController firstNameController = new TextEditingController();
  TextEditingController lastNameController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            expandedHeight: 100.0,
            floating: true,
            pinned: true,
            snap: true,
            elevation: 20,
            backgroundColor: kLeichtPrimaryColor,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: false,
              title: Text(
                'Edit Account',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Consumer<AuthProvider>(
                builder: (context, authProvider, _) {
                  if (buildCount == 0) {
                    firstNameController.text =
                        authProvider.user.firstName == null
                            ? ''
                            : authProvider.user.firstName;
                    lastNameController.text = authProvider.user.lastName == null
                        ? ''
                        : authProvider.user.lastName;
                    phoneController.text = authProvider.user.phoneNumber == null
                        ? ''
                        : authProvider.user.phoneNumber;
                    emailController.text = authProvider.user.email == null
                        ? ''
                        : authProvider.user.email;
                  }
                  if (buildCount < 1) {
                    buildCount++;
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 12, top: 18, bottom: 8),
                        child: Text(
                          'First Name',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 12, bottom: 12),
                        child: TextField(
                          controller: firstNameController,
                          onTap: () {
                            _onNameOptionPressed(context, true);
                          },
                          readOnly: true,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              hintText: '---',
                              hintStyle:
                                  TextStyle(fontSize: 18, color: Colors.grey)),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 12, top: 18, bottom: 8),
                        child: Text(
                          ' Surname',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 12, bottom: 12),
                        child: TextField(
                          readOnly: true,
                          controller: lastNameController,
                          onTap: () {
                            _onNameOptionPressed(context, false);
                          },
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              hintText: '----',
                              hintStyle:
                                  TextStyle(fontSize: 18, color: Colors.grey)),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 12, top: 18, bottom: 8),
                        child: Text(
                          'Phone Number',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(left: 12, bottom: 12, right: 12),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: width(context) * 0.6,
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    height: 25,
                                    width: 25,
                                    child: Image.asset(
                                      'images/nigeria.png',
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(left: 5),
                                    width: width(context) * 0.5,
                                    child: TextField(
                                      readOnly: true,
                                      onTap: () {
                                        _onPhoneOptionPressed(context);
                                      },
                                      controller: phoneController,
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                          hintText: '0800000000',
                                          hintStyle: TextStyle(
                                              fontSize: 18,
                                              color: Colors.grey)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              '',
                              style:
                                  TextStyle(color: Colors.green, fontSize: 18),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 12, top: 18, bottom: 8),
                        child: Text(
                          'Email',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(left: 12, bottom: 12, right: 12),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                                child: TextField(
                              readOnly: true,
                              controller: emailController,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  hintText: 'example@gmail.com',
                                  hintStyle: TextStyle(
                                      fontSize: 18, color: Colors.grey)),
                            )),
                            Text(
                              authProvider.firebaseUser.emailVerified
                                  ? 'Verified'
                                  : 'Unverified',
                              style: TextStyle(
                                  color: authProvider.firebaseUser.emailVerified
                                      ? Colors.green
                                      : Colors.red,
                                  fontSize: 18),
                            )
                          ],
                        ),
                      ),
                    ],
                  );
                },
              )
            ]),
          )
        ],
      ),
    );
  }

  void _onNameOptionPressed(BuildContext context, bool isFirstName) {
    GlobalKey<CustomProgressIndicatorState> key = GlobalKey();
    User user = Provider.of<AuthProvider>(context, listen: false).user;
    showDialog(
        context: context,
        builder: (context) {
          String text;
          if (isFirstName) {
            text = user.firstName == null ? '' : user.firstName;
          } else {
            text = user.lastName == null ? '' : user.lastName;
          }
          TextEditingController nameController =
              TextEditingController(text: text);
          return AlertDialog(
            title: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(isFirstName ? "First Name" : "Last Name"),
                Padding(
                  padding: EdgeInsets.all(5),
                  child: CustomProgressIndicator(
                    key: key,
                  ),
                )
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(
                      hintText: isFirstName ? "First Name" : "LastName",
                      border: UnderlineInputBorder()),
                  controller: nameController,
                ),
              ],
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "CANCEL",
                  style: TextStyle(color: kLeichtPrimaryColor),
                ),
              ),
              RaisedButton(
                onPressed: () async {
                  FocusScope.of(context).requestFocus(new FocusNode());
                  key.currentState.setState(() {
                    key.currentState.opacity = 1.0;
                  });
                  String firstName;
                  String lastName;
                  if (isFirstName) {
                    firstName = nameController.text.trim();
                    lastName = lastNameController.text.trim();
                  } else {
                    firstName = firstNameController.text.trim();
                    lastName = nameController.text.trim();
                  }
                  user.updateName(context, firstName, lastName).then((result) {
                    key.currentState.setState(() {
                      key.currentState.opacity = 0.0;
                    });
                    Navigator.pop(context);
                    firstNameController.text = firstName;
                    lastNameController.text = lastName;
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            content: Text("Saved"),
                            actions: <Widget>[
                              FlatButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  "CLOSE",
                                  style:
                                      TextStyle(color: kLeichtAlternateColor),
                                ),
                              )
                            ],
                          );
                        });
                  }).catchError((err) {
                    key.currentState.setState(() {
                      key.currentState.opacity = 0.0;
                    });
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
                  ;
                },
                child: Text(
                  "SAVE",
                  style: TextStyle(color: kLeichtAlternateColor),
                ),
                color: kLeichtPrimaryColor,
              )
            ],
          );
        });
  }

  void _onPhoneOptionPressed(BuildContext context) {
    GlobalKey<CustomProgressIndicatorState> key = GlobalKey();
    User user = Provider.of<AuthProvider>(context, listen: false).user;
    TextEditingController controller = TextEditingController(
        text: user.phoneNumber == null ? '' : user.phoneNumber);
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Name"),
                Padding(
                  padding: EdgeInsets.all(5),
                  child: CustomProgressIndicator(
                    key: key,
                  ),
                )
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: controller,
                  decoration: InputDecoration(
                      hintText: "Phone Number", border: UnderlineInputBorder()),
                ),
              ],
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "CANCEL",
                  style: TextStyle(color: kLeichtPrimaryColor),
                ),
              ),
              RaisedButton(
                onPressed: () async {
                  FocusScope.of(context).requestFocus(new FocusNode());
                  key.currentState.setState(() {
                    key.currentState.opacity = 1.0;
                  });
                  user.updatePhone(context, controller.text).then((result) {
                    key.currentState.setState(() {
                      key.currentState.opacity = 0.0;
                    });
                    phoneController.text = controller.text;
                    Navigator.pop(context);
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            content: Text("Saved"),
                            actions: <Widget>[
                              FlatButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  "CLOSE",
                                  style:
                                      TextStyle(color: kLeichtAlternateColor),
                                ),
                              )
                            ],
                          );
                        });
                  }).catchError((err) {
                    key.currentState.setState(() {
                      key.currentState.opacity = 0.0;
                    });
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
                },
                child: Text(
                  "SAVE",
                  style: TextStyle(color: kLeichtAlternateColor),
                ),
                color: kLeichtPrimaryColor,
              )
            ],
          );
        });
  }
}
