import 'package:flutter/material.dart';
import 'package:node_auth/constants/colors.dart';
import 'package:intl/intl.dart';

class WalletPage extends StatefulWidget {
  State createState() => WalletPageState();
}

class WalletPageState extends State<WalletPage> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraint) {
        return Container(
          color: kLeichtPrimaryColor,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  height: constraint.maxHeight * 0.3,
                  child: SafeArea(
                    child: Padding(
                      padding: EdgeInsets.only(top: 15, bottom: 15),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Wallet Balance',
                                style: TextStyle(
                                    color: Colors.grey[300],
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500)),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                                '₦ ${NumberFormat("#,###.##", "en_US").format(2000000)}',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold))
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: constraint.maxHeight * 0.7,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      )),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
