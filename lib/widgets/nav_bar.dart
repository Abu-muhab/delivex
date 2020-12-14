import 'package:flutter/material.dart';
import 'package:node_auth/constants/colors.dart';
import 'package:node_auth/widgets/page_holder.dart' as PageHolder;

class NavBar extends StatefulWidget {
  final Function(PageHolder.Page) onPageChanged;
  NavBar({this.onPageChanged});
  State createState() => NavBarState();
}

class NavBarState extends State<NavBar> {
  PageHolder.Page selectedPage = PageHolder.Page.HOME;
  double iconSize = 30;
  Color iconColor = Colors.grey[500];
  Color iconSelectedColor = kLeichtAccentColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            NavIcon(
              onTap: () {
                setState(() {
                  selectedPage = PageHolder.Page.HOME;
                  widget.onPageChanged(selectedPage);
                });
              },
              size: iconSize,
              color: selectedPage == PageHolder.Page.HOME
                  ? iconSelectedColor
                  : iconColor,
              iconData: Icons.home_outlined,
            ),
            NavIcon(
              onTap: () {
                setState(() {
                  selectedPage = PageHolder.Page.WALLET;
                  widget.onPageChanged(selectedPage);
                });
              },
              size: iconSize,
              color: selectedPage == PageHolder.Page.WALLET
                  ? iconSelectedColor
                  : iconColor,
              iconData: Icons.account_balance_wallet_outlined,
            ),
            NavIcon(
              onTap: () {
                setState(() {
                  selectedPage = PageHolder.Page.NOTIFICATION;
                  widget.onPageChanged(selectedPage);
                });
              },
              size: iconSize,
              color: selectedPage == PageHolder.Page.NOTIFICATION
                  ? iconSelectedColor
                  : iconColor,
              iconData: Icons.notifications_none_outlined,
            ),
            NavIcon(
              onTap: () {
                Scaffold.of(context).openDrawer();
              },
              size: iconSize,
              color: iconColor,
              iconData: Icons.menu,
            ),
          ],
        ),
      ),
    );
  }
}

class NavIcon extends StatelessWidget {
  final double size;
  final Color color;
  final IconData iconData;
  final VoidCallback onTap;

  NavIcon({this.color, this.size, this.iconData, this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(
        iconData,
        size: size,
        color: color,
      ),
    );
  }
}
