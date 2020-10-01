import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:node_auth/constants/colors.dart';

class ActionButtonOval extends StatefulWidget {
  final AsyncValueGetter<void> onClick;
  ActionButtonOval({@required this.onClick});

  @override
  State createState() => ActionButtonOvalState();
}

class ActionButtonOvalState extends State<ActionButtonOval> {
  bool isExecuting = false;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      height: 50,
      child: InkWell(
        onTap: () async {
          setState(() {
            isExecuting = true;
          });
          await widget.onClick();
          setState(() {
            isExecuting = false;
          });
        },
        child: Card(
          color: Color(0xFFF56634),
          shape: CircleBorder(),
          child: isExecuting
              ? Center(
                  child: SizedBox(
                    height: 25,
                    width: 25,
                    child: SpinKitDualRing(
                      color: kLeichtPrimaryColor,
                      lineWidth: 2,
                    ),
                  ),
                )
              : Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                  size: 30,
                ),
        ),
      ),
    );
  }
}
