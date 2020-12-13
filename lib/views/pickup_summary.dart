import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:node_auth/api/payment_api.dart';
import 'package:node_auth/api/search_api.dart';
import 'package:node_auth/constants/colors.dart';
import 'package:node_auth/providers/auth.dart';
import 'package:node_auth/widgets/loading_modal.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

PickUpActivity args;

class PickUpSummaryPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PickUpSummaryPageState();
}

class PickUpSummaryPageState extends State<PickUpSummaryPage> {
  final TextEditingController pickup = TextEditingController();
  final TextEditingController dropOff = TextEditingController();
  bool showLoadingModal = false;
  @override
  Widget build(BuildContext context) {
    Map map = ModalRoute.of(context).settings.arguments;
    args = map['details'];
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            elevation: 1,
            title: Text("Pickup details",
                style: TextStyle(
                  color: Colors.black,
                )),
            centerTitle: true,
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Colors.black),
          ),
          body: Container(
            width: double.infinity,
            color: Colors.white,
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: ListView(
                    physics: BouncingScrollPhysics(),
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                            left: 50, right: 50, top: 20, bottom: 20),
                        child: Column(
                          children: <Widget>[
                            CustomTile(
                              title: "from",
                              subTitle:
                                  "${Provider.of<AuthProvider>(context).user.firstName} ${Provider.of<AuthProvider>(context).user.lastName}",
                              content: args.pickupLocation.name,
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            CustomTile(
                              title: "to",
                              subTitle: args.receiversName,
                              content: args.dropOffLocation.name,
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            CustomTile(
                              title: "Receiver's contact",
                              subTitle: args.receiversPhone,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 20,
                  color: Colors.grey[200],
                ),
                Expanded(
                  child: Container(
                    color: Colors.white,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.12,
                        color: Colors.white,
                        child: Center(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.75,
                            height: MediaQuery.of(context).size.height * 0.08,
                            child: RaisedButton(
                              color: kLeichtPrimaryColor,
                              onPressed: () {
                                setState(() {
                                  showLoadingModal = true;
                                });
                                PaymentApi.getInstance()
                                    .then((paymentApi) async {
                                  paymentApi
                                      .initializeTransaction(
                                          context, args, map['fee'])
                                      .then((ref) async {
                                    setState(() {
                                      showLoadingModal = false;
                                    });
                                    CheckoutResponse response =
                                        await paymentApi.beginTransaction(
                                            context, ref, map['fee']);
                                    if (response.status) {
                                      Navigator.pushReplacementNamed(
                                          context, 'orders');
                                    }
                                  }).catchError((err) {
                                    setState(() {
                                      showLoadingModal = false;
                                    });
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            content: Text(err.toString()),
                                            actions: [
                                              FlatButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text("CLOSE"))
                                            ],
                                          );
                                        });
                                  });
                                });
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Text(
                                      "₦ ${NumberFormat("#,###", "en_US").format(map['fee'])}",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Text(
                                      "Checkout",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        showLoadingModal ? LoadingModal() : Container()
      ],
    );
  }
}

class CustomTile extends StatelessWidget {
  final String title;
  final String subTitle;
  final String content;
  CustomTile({this.title, this.subTitle, this.content});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title.toUpperCase(),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            subTitle,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: TextStyle(
                color: kLeichtPrimaryColor,
                fontSize: 17,
                fontWeight: FontWeight.w600),
          ),
          content != null
              ? SizedBox(
                  height: 5,
                )
              : Container(),
          content != null
              ? Text(
                  content,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                      color: kLeichtAccentColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                )
              : Container(),
        ],
      ),
    );
  }
}

class PickUpActivity {
  Place pickupLocation;
  Place dropOffLocation;
  String receiversName;
  String receiversPhone;
  PickUpActivity(
      {this.dropOffLocation,
      this.pickupLocation,
      this.receiversName,
      this.receiversPhone});
}
