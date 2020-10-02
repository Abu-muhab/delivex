import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:node_auth/models/order.dart';

class PickupDetail extends StatelessWidget {
  final Order order;
  PickupDetail({this.order});
  final TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
      Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10),
            child: Icon(
              FontAwesomeIcons.boxOpen,
              color: Colors.black,
              size: 20,
            ),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
      SizedBox(
        width: 10,
      ),
      Expanded(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 5,
          ),
          Text(
            "From: ",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.w400, fontSize: 20),
          ),
          Row(
            children: <Widget>[
              Icon(
                Icons.location_on,
                color: Colors.grey,
                size: 20,
              ),
              SizedBox(width: 5),
              Text(
                order.fromLocationName,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w300,
                  fontSize: 15,
                ),
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "To: ",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.w400, fontSize: 20),
          ),
          Text(
            order.to,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.w300, fontSize: 20),
          ),
          Text(
            order.toContact,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.w200, fontSize: 15),
          ),
          Row(
            children: <Widget>[
              Icon(
                Icons.location_on,
                color: Colors.grey,
                size: 20,
              ),
              SizedBox(width: 5),
              Text(
                order.toLocationName,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w300,
                  fontSize: 15,
                ),
              )
            ],
          ),
        ],
      ))
    ]);
  }
}

class CustomArrow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 3,
          height: 10,
          decoration: BoxDecoration(color: Colors.black),
        )
      ],
    );
  }
}
