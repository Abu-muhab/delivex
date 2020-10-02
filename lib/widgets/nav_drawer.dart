import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:node_auth/constants/colors.dart';
import 'package:node_auth/models/user.dart';
import 'package:node_auth/providers/auth.dart';
import 'package:node_auth/widgets/custom_indicator.dart';
import 'package:node_auth/widgets/option_tile.dart';
import 'package:provider/provider.dart';

class NavDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      child: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Divider(color: kLeichtPrimaryColor),
            ListTile(
              onTap: () {
                Provider.of<AuthProvider>(context, listen: false).signOut();
              },
              leading: Icon(Icons.power_settings_new),
              title: Text("Log out"),
            )
          ],
        ),
      ),
      builder: (context, loginModel, child) {
        return Container(
          width: 300,
          height: MediaQuery.of(context).size.height,
          color: kLeichtPrimaryColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SafeArea(
                child: Container(
                  color: kLeichtPrimaryColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Center(
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.account_circle,
                                color: Colors.white,
                                size: 80,
                              ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Container(
                                    child: Consumer<AuthProvider>(
                                      builder: (context, authProvider, _) {
                                        return Text(
                                          authProvider.user.firstName,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: _DrawerMenuOptions(),
              ),
              child
            ],
          ),
        );
      },
    );
  }
}

class _DrawerMenuOptions extends StatelessWidget {
  void _onNameOptionPressed(BuildContext context) {
    GlobalKey<CustomProgressIndicatorState> key = GlobalKey();
    User user = Provider.of<AuthProvider>(context, listen: false).user;
    showDialog(
        context: context,
        builder: (context) {
          TextEditingController firstNameController =
              TextEditingController(text: user.firstName);
          TextEditingController lastNameController =
              TextEditingController(text: user.lastName);
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
                  decoration: InputDecoration(
                      hintText: "First Name", border: UnderlineInputBorder()),
                  controller: firstNameController,
                ),
                TextField(
                  decoration: InputDecoration(
                      hintText: "Last Name", border: UnderlineInputBorder()),
                  controller: lastNameController,
                )
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
                  user
                      .updateName(context, firstNameController.text,
                          lastNameController.text)
                      .then((result) {
                    key.currentState.setState(() {
                      key.currentState.opacity = 0.0;
                    });
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
    TextEditingController phoneController =
        TextEditingController(text: user.phoneNumber);
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
                  controller: phoneController,
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
                  user
                      .updatePhone(context, phoneController.text)
                      .then((result) {
                    key.currentState.setState(() {
                      key.currentState.opacity = 0.0;
                    });
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

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListView(
        padding: EdgeInsets.all(0),
        children: <Widget>[
          Column(
            children: <Widget>[
              Consumer<AuthProvider>(
                builder: (context, authProvider, _) {
                  return OptionTile(
                    photo: "images/name.png",
                    title: "Name",
                    subtitle: authProvider.user.firstName +
                        " " +
                        authProvider.user.lastName,
                    addForwardIcon: true,
                    onTap: () {
                      _onNameOptionPressed(context);
                    },
                  );
                },
              ),
              Consumer<AuthProvider>(
                builder: (context, authProvider, _) {
                  return OptionTile(
                    photo: "images/phone.png",
                    title: "Phone",
                    subtitle: authProvider.user.phoneNumber,
                    addForwardIcon: true,
                    onTap: () {
                      _onPhoneOptionPressed(context);
                    },
                  );
                },
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Divider(),
                  OptionTile(
                    icon: FontAwesomeIcons.boxOpen,
                    title: "Your Orders",
                    subtitle: "Manage",
                    addForwardIcon: true,
                    onTap: () {
                      Navigator.pushNamed(context, "orders");
                    },
                  ),
                  OptionTile(
                    photo: "images/address.png",
                    title: "Saved Addresses",
                    subtitle: "Manage Addresses",
                    addForwardIcon: true,
                    onTap: () {
                      Navigator.pushNamed(context, "addresses");
                    },
                  ),
                  Divider(),
                  OptionTile(
                    photo: "images/faq.png",
                    title: "FAQ",
                    subtitle: "Frequently asked questions",
                    addForwardIcon: true,
                    onTap: () {},
                  ),
                  OptionTile(
                    photo: "images/help.png",
                    title: "Help Center",
                    subtitle: "support.leicht@gmail.com",
                    addForwardIcon: false,
                    onTap: () {},
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
