import 'package:flutter/material.dart';
import 'package:node_auth/constants/colors.dart';
import 'package:node_auth/widgets/page_holder.dart' as PageHolder;

class NavBar extends StatefulWidget {
  final Function(PageHolder.Page) onPageChanged;
  final PageHolder.Page selectedPage;
  NavBar({this.onPageChanged, this.selectedPage});
  State createState() => NavBarState();
}

class NavBarState extends State<NavBar> {
  double iconSize = 30;
  Color iconColor = Colors.grey[500];
  Color iconSelectedColor = kLeichtAccentColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            NavIcon(
              onTap: () {
                widget.onPageChanged(PageHolder.Page.HOME);
              },
              size: iconSize,
              color: widget.selectedPage == PageHolder.Page.HOME
                  ? iconSelectedColor
                  : iconColor,
              iconData: Icons.home_outlined,
            ),
            NavIcon(
              onTap: () {
                widget.onPageChanged(PageHolder.Page.DELIVERIES);
              },
              size: iconSize,
              color: widget.selectedPage == PageHolder.Page.DELIVERIES
                  ? iconSelectedColor
                  : iconColor,
              iconData: Icons.directions_bike_outlined,
            ),
            NavIcon(
              onTap: () {
                widget.onPageChanged(PageHolder.Page.WALLET);
              },
              size: iconSize,
              color: widget.selectedPage == PageHolder.Page.WALLET
                  ? iconSelectedColor
                  : iconColor,
              iconData: Icons.account_balance_wallet_outlined,
            ),
            NavIcon(
              onTap: () {
                widget.onPageChanged(PageHolder.Page.NOTIFICATION);
              },
              size: iconSize,
              color: widget.selectedPage == PageHolder.Page.NOTIFICATION
                  ? iconSelectedColor
                  : iconColor,
              iconData: Icons.notifications_none_outlined,
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
