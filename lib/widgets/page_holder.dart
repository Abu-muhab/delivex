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
  @override
  Widget build(BuildContext context) {
    GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
    return Scaffold(
      key: scaffoldKey,
      drawer: Drawer(
        child: NavDrawer(),
      ),
      body: ListView(
        padding: EdgeInsets.all(0),
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            child: GestureDetector(
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
          )
        ],
      ),
    );
  }
}

enum Page { HOME, WALLET, NOTIFICATION, DELIVERIES }
