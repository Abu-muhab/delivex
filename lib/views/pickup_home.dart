import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:node_auth/api/search_api.dart';
import 'package:node_auth/constants/colors.dart';
import 'package:node_auth/views/pickup_summary.dart';
import 'package:node_auth/widgets/nav_drawer.dart';

String sendersDistrict;
String senderState;
String receiversDistrict;
String receiversState;

class PickUpHome extends StatefulWidget {
  @override
  State createState() => PickUpHomeState();
}

class PickUpHomeState extends State<PickUpHome> {
  final TextEditingController receiversName = TextEditingController();
  final TextEditingController receiversPhone = TextEditingController();
  final TextEditingController pickupLocationController =
      TextEditingController();
  final TextEditingController dropOffLocationController =
      TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey();

  Place pickupLocation;
  Place dropOffLocation;

  @override
  Widget build(BuildContext context) {
    GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
    return Scaffold(
      key: scaffoldKey,
      drawer: Drawer(
        child: NavDrawer(),
      ),
      body: ListView(
        padding: EdgeInsets.all(0),
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(new FocusNode());
              },
              child: Container(
                  color: kLeichtPrimaryColor,
                  child: Form(
                    key: formKey,
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                          top: MediaQuery.of(context).size.height * 0.17,
                          left: MediaQuery.of(context).size.width * 0.5 -
                              MediaQuery.of(context).size.width * 0.4,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.8,
                            height: MediaQuery.of(context).size.width * 0.8,
                            child: Image.asset("images/delivery2.png"),
                          ),
                        ),
                        SafeArea(
                          child: Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 10,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      FocusScope.of(context)
                                          .requestFocus(new FocusNode());
                                      scaffoldKey.currentState.openDrawer();
                                    },
                                    child: Icon(
                                      Icons.menu,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                      child: TextFormField(
                                    readOnly: true,
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return "Enter pickup location";
                                      }
                                      return null;
                                    },
                                    onTap: () async {
                                      Navigator.pushNamed(
                                              context, "select_location")
                                          .then((value) {
                                        Place location = value;
                                        if (location != null) {
                                          pickupLocationController.text =
                                              location.name;
                                          pickupLocation = location;
                                        }
                                      });
                                    },
                                    controller: pickupLocationController,
                                    decoration: InputDecoration(
                                        hintText: "Pickup location",
                                        prefixIcon: Icon(Icons.my_location),
                                        suffixIcon: Icon(Icons.more_vert),
                                        fillColor: Colors.white,
                                        filled: true,
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        disabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        )),
                                  )),
                                  SizedBox(
                                    width: 10,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                )),
                            child: Padding(
                              padding: EdgeInsets.all(20),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Delivery Details",
                                    style: TextStyle(
                                        color: kLeichtPrimaryColor,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 10),
                                  TextFormField(
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return "Enter dropoff location";
                                      }
                                      return null;
                                    },
                                    readOnly: true,
                                    onTap: () async {
                                      Navigator.pushNamed(
                                              context, "select_location")
                                          .then((value) {
                                        Place location = value;
                                        if (location != null) {
                                          dropOffLocationController.text =
                                              location.name;
                                          dropOffLocation = location;
                                        }
                                      });
                                    },
                                    controller: dropOffLocationController,
                                    decoration: InputDecoration(
                                        hintText: "Dropoff location",
                                        prefixIcon: Icon(Icons.location_on),
                                        suffixIcon: Icon(Icons.more_vert),
                                        fillColor: Colors.white,
                                        filled: true,
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        disabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        )),
                                  ),
                                  SizedBox(height: 10),
                                  TextFormField(
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return "Enter receiver's name";
                                      }
                                      return null;
                                    },
                                    controller: receiversName,
                                    decoration: InputDecoration(
                                        hintText: "Enter Receiver's name",
                                        prefixIcon: Icon(FontAwesomeIcons.user),
                                        fillColor: Colors.grey[100],
                                        filled: true,
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: BorderSide(
                                                color: Colors.transparent)),
                                        disabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: BorderSide(
                                                color: Colors.transparent))),
                                  ),
                                  SizedBox(height: 10),
                                  TextFormField(
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return "Enter phone number";
                                      }
                                      return null;
                                    },
                                    controller: receiversPhone,
                                    keyboardType: TextInputType.phone,
                                    decoration: InputDecoration(
                                        hintText:
                                            "Enter Receiver's phone number",
                                        prefixIcon: Icon(Icons.phone),
                                        fillColor: Colors.grey[100],
                                        filled: true,
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: BorderSide(
                                                color: Colors.transparent)),
                                        disabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: BorderSide(
                                                color: Colors.transparent))),
                                  ),
                                  SizedBox(height: 10),
                                  SizedBox(
                                    width: double.infinity,
                                    height: 60,
                                    child: RaisedButton(
                                      onPressed: () {
                                        FocusScope.of(context)
                                            .requestFocus(new FocusNode());
                                        if (formKey.currentState.validate()) {
                                          Navigator.pushNamed(
                                              context, 'overview',
                                              arguments: PickUpActivity(
                                                  pickupLocation:
                                                      pickupLocation,
                                                  dropOffLocation:
                                                      dropOffLocation,
                                                  receiversName:
                                                      receiversName.text,
                                                  receiversPhone:
                                                      receiversPhone.text));
                                        }
                                      },
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      color: kLeichtPrimaryColor,
                                      child: Text(
                                        "Next",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )),
            ),
          )
        ],
      ),
    );
  }
}
