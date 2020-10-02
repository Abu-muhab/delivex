import 'package:flutter/material.dart';
import 'package:node_auth/constants/colors.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraint) {
      return Container(
        height: constraint.maxHeight,
        width: constraint.maxWidth,
        color: kLeichtPrimaryColor,
        child: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.4,
            height: MediaQuery.of(context).size.width * 0.4,
            child: Column(
              children: [
                Expanded(child: Image.asset("images/delivery2.png")),
                SizedBox(
                  height: 15,
                ),
                LinearProgressIndicator(
                  minHeight: 3,
                  backgroundColor: kLeichtPrimaryColor,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(kLeichtAlternateColor),
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
