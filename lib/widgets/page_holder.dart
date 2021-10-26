import 'package:flutter/material.dart';
import 'package:node_auth/views/orders_view.dart';
import 'package:node_auth/views/pickup_home.dart';
import 'package:node_auth/views/wallet.dart';
import 'package:node_auth/widgets/nav_bar.dart';
import 'package:node_auth/widgets/nav_drawer.dart';

class PageHolder extends StatefulWidget {
  @override
  State createState() => PageHolderState();
}

class PageHolderState extends State<PageHolder> {
  Page selectedPage = Page.HOME;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: Drawer(
        child: NavDrawer(),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Column(
          children: [
            Expanded(
              child: selectedPage == Page.HOME
                  ? PickUpHome()
                  : selectedPage == Page.WALLET
                  ? WalletPage()
                  : selectedPage == Page.DELIVERIES
                  ? Orders()
                  : Container(),
            ),
            NavBar(
              onPageChanged: (page) {
                setState(() {
                  selectedPage = page;
                });
              },
              selectedPage: selectedPage,
            )
          ],
        ),
      ),
    );
  }
}

enum Page { HOME, WALLET, NOTIFICATION, DELIVERIES }
