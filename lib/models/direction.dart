import 'package:google_maps_flutter/google_maps_flutter.dart';

class Direction {
  var distance;
  LatLng origin;
  LatLng destination;
  String overviewPolylineString;
  Polyline polyline;

  Direction(
      {this.destination,
      this.origin,
      this.distance,
      this.overviewPolylineString,
      this.polyline});
}
