import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:node_auth/api/payment_api.dart';
import 'package:node_auth/constants/colors.dart';
import 'package:node_auth/constants/screen_size.dart';
import 'package:node_auth/models/direction.dart';
import 'package:node_auth/views/pickup_summary.dart';
import 'package:node_auth/widgets/overview.dart';
import 'package:intl/intl.dart';

class Overview extends StatefulWidget {
  @override
  State createState() => OverviewState();
}

class OverviewState extends State<Overview> {
  PickUpActivity args;
  Direction direction;
  var deliveryFee;
  @override
  Widget build(BuildContext context) {
    args = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: DistanceOverview(
              firstLocation: LatLng(
                  args.pickupLocation.latitude, args.pickupLocation.longitude),
              secondLocation: LatLng(args.dropOffLocation.latitude,
                  args.dropOffLocation.longitude),
              onPolylineDrawn: (direction) async {
                this.direction = direction;
                PaymentApi paymentApi = await PaymentApi.getInstance();
                paymentApi.getDeliveryFee(direction.distance).then((fee) async {
                  if (fee == null) {
                    while (deliveryFee == null) {
                      if (mounted) {
                        print('getting polyline');
                        fee =
                            await paymentApi.getDeliveryFee(direction.distance);
                        if (fee != null) {
                          setState(() {
                            deliveryFee = fee;
                          });
                        }
                      } else {
                        break;
                      }
                    }
                  }
                  setState(() {
                    deliveryFee = fee;
                  });
                });
              },
            ),
          ),
          Container(
            color: Colors.white,
            child: Column(
              children: [
                SizedBox(
                  height: 15,
                ),
                Text(
                  'Details',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 10,
                ),
                Divider(),
                ListTile(
                  leading: Icon(
                    Icons.location_on_outlined,
                  ),
                  title: Text(args.pickupLocation.formattedAddress),
                  subtitle: Text('Pickup'),
                ),
                ListTile(
                  leading: Icon(
                    Icons.directions_bike_outlined,
                  ),
                  title: Text(args.dropOffLocation.formattedAddress),
                  subtitle: Text('Destination'),
                ),
                Divider(),
                deliveryFee == null
                    ? Container()
                    : ListTile(
                        leading: Icon(
                          Icons.payment,
                        ),
                        title: Text(
                            '₦ ${NumberFormat("#,###", "en_US").format(deliveryFee)}'),
                        subtitle: Text('Delivery Fee'),
                      ),
                Center(
                  child: SizedBox(
                    width: width(context) * 0.8,
                    child: RaisedButton(
                      onPressed: () {
                        if (deliveryFee != null) {
                          Navigator.pushNamed(context, 'pickup_summary',
                              arguments: {'details': args, 'fee': deliveryFee});
                        }
                      },
                      color: kLeichtPrimaryColor,
                      child: Padding(
                        padding: EdgeInsets.all(15),
                        child: deliveryFee == null
                            ? SizedBox(
                                height: 25,
                                width: 25,
                                child: CircularProgressIndicator(),
                              )
                            : Text("Next",
                                style: TextStyle(color: kLeichtAlternateColor)),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
