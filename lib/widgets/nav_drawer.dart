import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:node_auth/constants/colors.dart';
import 'package:node_auth/providers/auth.dart';
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
                    onTap: () {},
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
                    onTap: () {},
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
                      Navigator.pushNamed(context, "parcels_page");
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
