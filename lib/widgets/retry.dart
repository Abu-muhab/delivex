import 'package:flutter/material.dart';
import 'package:node_auth/constants/colors.dart';

class RetryWidget extends StatefulWidget {
  final String errorMessage;
  final Future<bool> Function() onTap;
  final VoidCallback onTapSync;
  RetryWidget({this.onTap, this.errorMessage, this.onTapSync, key})
      : super(key: key);
  @override
  State createState() => RetryWidgetState();
}

class RetryWidgetState extends State<RetryWidget> {
  Future<bool> Function() onTap;
  String errorMessage;
  VoidCallback onTapSync;
  bool retrying = false;

  @override
  void initState() {
    onTap = widget.onTap;
    errorMessage = widget.errorMessage;
    onTapSync = widget.onTapSync;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: retrying == true
          ? SizedBox(
              height: 25,
              width: 25,
              child: CircularProgressIndicator(),
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  errorMessage,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                ),
                RaisedButton(
                  onPressed: () async {
                    setState(() {
                      retrying = true;
                    });
                    if (onTap != null) {
                      bool success = await onTap();
                      if (success == false) {
                        setState(() {
                          retrying = false;
                        });
                      }
                    } else {
                      onTapSync();
                    }
                  },
                  color: kLeichtPrimaryColor,
                  child: Text(
                    "Try again",
                    style: TextStyle(color: kLeichtAlternateColor),
                  ),
                )
              ],
            ),
    );
  }
}
