import 'package:flutter/material.dart';
import 'package:node_auth/widgets/nav_drawer.dart';
import 'package:responsive_builder/responsive_builder.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        return Scaffold(
          appBar: sizingInformation.isDesktop || sizingInformation.isTablet
              ? null
              : AppBar(
                  title: Text("Home"),
                ),
          drawer: sizingInformation.isDesktop || sizingInformation.isTablet
              ? null
              : Drawer(
                  child: NavDrawer(),
                ),
          body: ScreenTypeLayout(
            desktop: Row(
              children: [
                SizedBox(
                  width: 300,
                  height: MediaQuery.of(context).size.height,
                  child: NavDrawer(),
                ),
                Expanded(child: HomeBody())
              ],
            ),
            tablet: Row(
              children: [
                SizedBox(
                  width: 300,
                  height: MediaQuery.of(context).size.height,
                  child: NavDrawer(),
                ),
                Expanded(child: HomeBody())
              ],
            ),
            mobile: HomeBody(),
          ),
        );
      },
    );
  }
}

class HomeBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text("HOME"),
      ),
    );
  }
}
