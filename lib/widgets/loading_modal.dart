import 'package:flutter/material.dart';

class LoadingModal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraint) {
      return Container(
        height: constraint.maxHeight,
        width: constraint.maxWidth,
        color: Color.fromARGB(100, 255, 255, 255),
        child: Center(
          child: SizedBox(
            width: 200,
            height: 50,
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
