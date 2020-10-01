import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:node_auth/constants/colors.dart';

class CustomProgressIndicator extends StatefulWidget {
  final Color color;
  CustomProgressIndicator({Key key, this.color = kLeichtPrimaryColor})
      : super(key: key);
  @override
  State createState() => CustomProgressIndicatorState();
}

class CustomProgressIndicatorState extends State<CustomProgressIndicator> {
  double opacity = 0.0;
  Color color;
  @override
  void initState() {
    color = widget.color;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (opacity == 0) {
      return Container();
    }
    return Opacity(
      opacity: opacity,
      child: SpinKitDualRing(
        size: 25,
        color: color,
        lineWidth: 4,
      ),
    );
  }
}
