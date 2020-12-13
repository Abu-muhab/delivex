import 'package:flutter/material.dart';
import 'package:node_auth/models/order.dart';
import 'package:intl/intl.dart';

class PickupDetail extends StatelessWidget {
  final Order order;
  PickupDetail({this.order});
  final TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 15,
        ),
        Center(
          child: Text('Delivery Details', style: TextStyle(fontSize: 17)),
        ),
        SizedBox(
          height: 10,
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.contact_phone),
          title: Text(order.to),
          subtitle: Text(order.toContact),
        ),
        ListTile(
          leading: Icon(
            Icons.location_on_outlined,
          ),
          title: Text(order.toLocationName),
        ),
        ListTile(
          leading: Icon(
            Icons.date_range_outlined,
          ),
          title: Text(order.date),
        ),
        ListTile(
          leading: Icon(
            Icons.payment,
          ),
          title:
              Text('₦ ${NumberFormat("#,###", "en_US").format(order.amount)}'),
        )
      ],
    );
  }
}
