import 'package:flutter/material.dart';

class LoadingModal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraint) {
      return Container(
        height: constraint.maxHeight,
        width: constraint.maxWidth,
        color: Color.fromARGB(100, 0, 0, 0),
        child: Center(
          child: SizedBox(
            width: 250,
            height: 70,
            child: Card(
              child: Center(
                child: SizedBox(
                  height: 25,
                  width: 25,
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
