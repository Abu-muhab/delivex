import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:node_auth/models/direction.dart';
import 'package:node_auth/views/pickup_summary.dart';
import 'package:node_auth/widgets/overview.dart';

class Overview extends StatefulWidget {
  @override
  State createState() => OverviewState();
}

class OverviewState extends State<Overview> {
  PickUpActivity args;
  Direction direction;
  @override
  Widget build(BuildContext context) {
    args = ModalRoute.of(context).settings.arguments;
    return Column(
      children: [
        Expanded(
          child: DistanceOverview(
            firstLocation: LatLng(
                args.pickupLocation.latitude, args.pickupLocation.longitude),
            secondLocation: LatLng(
                args.dropOffLocation.latitude, args.dropOffLocation.longitude),
            onPolylineDrawn: (direction) {
              setState(() {
                this.direction = direction;
              });
            },
          ),
        ),
        Container(
          height: 200,
          color: Colors.white,
          child: Column(
            children: [

            ],
          ),
        )
      ],
    );
  }

  Widget applyGradient(Widget child) {
    return ShaderMask(
      shaderCallback: (bounds) {
        return LinearGradient(
                colors: direction == null
                    ? [
                        // Colors.grey[400],
                        Colors.grey[300],
                        Colors.grey[200],
                        Colors.grey[100],
                      ]
                    : [Colors.black, Colors.black],
                tileMode: TileMode.mirror)
            .createShader(bounds);
      },
      child: child,
    );
  }
}
