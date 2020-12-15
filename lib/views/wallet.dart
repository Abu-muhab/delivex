import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:node_auth/api/payment_api.dart';
import 'package:node_auth/constants/colors.dart';
import 'package:intl/intl.dart';
import 'package:node_auth/providers/auth.dart';
import 'package:node_auth/widgets/loading_modal.dart';
import 'package:provider/provider.dart';

GlobalKey<WalletPageState> walletKey = GlobalKey();

class WalletPage extends StatefulWidget {
  WalletPage() : super(key: walletKey);
  State createState() => WalletPageState();
}

class WalletPageState extends State<WalletPage> {
  bool showLoadingModal = false;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraint) {
        return RefreshIndicator(
          onRefresh: () async {
            return Future.delayed(Duration(seconds: 2), () async {
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(Provider.of<AuthProvider>(context, listen: false)
                      .firebaseUser
                      .uid)
                  .get();
            });
          },
          child: ListView(
            padding: EdgeInsets.all(0),
            children: [
              SizedBox(
                height: constraint.maxHeight,
                child: Stack(
                  children: [
                    Container(
                      color: kLeichtPrimaryColor,
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.topCenter,
                            child: Container(
                              height: constraint.maxHeight * 0.25,
                              width: constraint.maxWidth,
                              child: SafeArea(
                                child: Padding(
                                  padding: EdgeInsets.only(bottom: 15),
                                  child: Center(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Align(
                                          alignment: Alignment.topRight,
                                          child: GestureDetector(
                                            onTap: () {
                                              showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    GlobalKey<FormState>
                                                        formKey = GlobalKey();
                                                    TextEditingController
                                                        amountController =
                                                        TextEditingController();
                                                    return AlertDialog(
                                                      title:
                                                          Text('Fund Wallet'),
                                                      content: Form(
                                                        key: formKey,
                                                        child: TextFormField(
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          validator: (value) {
                                                            if (value.length ==
                                                                0) {
                                                              return "Enter an amount";
                                                            }
                                                            try {
                                                              double.parse(
                                                                  value);
                                                            } catch (err) {
                                                              return "Not a valid amount";
                                                            }

                                                            return null;
                                                          },
                                                          controller:
                                                              amountController,
                                                          decoration:
                                                              InputDecoration(
                                                                  border:
                                                                      OutlineInputBorder(),
                                                                  hintText:
                                                                      'Amount'),
                                                        ),
                                                      ),
                                                      actions: [
                                                        FlatButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: Text('Cancel',
                                                              style: TextStyle(
                                                                  color:
                                                                      kLeichtAlternateColor)),
                                                        ),
                                                        RaisedButton(
                                                          onPressed: () {
                                                            if (formKey
                                                                .currentState
                                                                .validate()) {
                                                              Navigator.pop(
                                                                  context,
                                                                  double.parse(
                                                                      amountController
                                                                          .text));
                                                            }
                                                          },
                                                          color:
                                                              kLeichtPrimaryColor,
                                                          child: Text('Next',
                                                              style: TextStyle(
                                                                  color:
                                                                      kLeichtAlternateColor)),
                                                        )
                                                      ],
                                                    );
                                                  }).then((fee) {
                                                if (fee == null) {
                                                  return;
                                                }
                                                walletKey.currentState
                                                    .setState(() {
                                                  walletKey.currentState
                                                      .showLoadingModal = true;
                                                });
                                                PaymentApi.getInstance()
                                                    .then((paymentApi) async {
                                                  paymentApi
                                                      .initializeWalletTransaction(
                                                          context, fee)
                                                      .then((ref) async {
                                                    walletKey.currentState
                                                        .setState(() {
                                                      walletKey.currentState
                                                              .showLoadingModal =
                                                          false;
                                                    });
                                                    CheckoutResponse response =
                                                        await paymentApi
                                                            .beginTransaction(
                                                                context,
                                                                ref,
                                                                fee);
                                                    if (response.status) {
                                                      Navigator.popUntil(
                                                          context,
                                                          ModalRoute.withName(
                                                              'home'));
                                                    }
                                                  }).catchError((err) {
                                                    walletKey.currentState
                                                        .setState(() {
                                                      walletKey.currentState
                                                              .showLoadingModal =
                                                          false;
                                                    });
                                                    showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return AlertDialog(
                                                            content: Text(
                                                                err.toString()),
                                                            actions: [
                                                              FlatButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  child: Text(
                                                                      "CLOSE"))
                                                            ],
                                                          );
                                                        });
                                                  });
                                                });
                                              });
                                            },
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  'Fund Wallet',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.all(10),
                                                  child: Icon(
                                                    Icons.add_circle_outline,
                                                    size: 30,
                                                    color: kLeichtAccentColor,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text('Wallet Balance',
                                                  style: TextStyle(
                                                      color: Colors.grey[300],
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.w500)),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              StreamBuilder<DocumentSnapshot>(
                                                stream: FirebaseFirestore
                                                    .instance
                                                    .collection('users')
                                                    .doc(Provider.of<
                                                                AuthProvider>(
                                                            context,
                                                            listen: false)
                                                        .firebaseUser
                                                        .uid)
                                                    .snapshots(),
                                                builder: (context, snapshot) {
                                                  if (snapshot.hasData ==
                                                      false) {
                                                    return SizedBox(
                                                      height: 25,
                                                      width: 25,
                                                      child:
                                                          CircularProgressIndicator(
                                                        strokeWidth: 3,
                                                      ),
                                                    );
                                                  }

                                                  if (snapshot.data.data()[
                                                          'walletBalance'] ==
                                                      null) {
                                                    return Text(
                                                        '₦ ${NumberFormat("#,###.##", "en_US").format(0)}',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 40,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold));
                                                  }
                                                  return Text(
                                                      '₦ ${NumberFormat("#,###.##", "en_US").format(snapshot.data.data()['walletBalance'])}',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 40,
                                                          fontWeight:
                                                              FontWeight.bold));
                                                },
                                              ),
                                            ],
                                          ),
                                        )
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
                              height: constraint.maxHeight * 0.75,
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
                    ),
                    showLoadingModal ? LoadingModal() : Container()
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
