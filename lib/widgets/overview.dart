import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:node_auth/api/directions_api.dart';
import 'package:node_auth/api/location_math_api.dart';
import 'package:node_auth/models/direction.dart';

class DistanceOverview extends StatefulWidget {
  final LatLng firstLocation;
  final InfoWindow firstLocationInfoWindow;
  final LatLng secondLocation;
  final Function(Direction) onPolylineDrawn;

  DistanceOverview(
      {this.firstLocation,
      this.secondLocation,
      this.firstLocationInfoWindow,
      this.onPolylineDrawn});
  @override
  State createState() => DistanceOverviewState();
}

class DistanceOverviewState extends State<DistanceOverview> {
  LatLng firstLocation;
  LatLng secondLocation;
  List<Marker> markers = new List();
  List<Polyline> polyLine = [];
  GoogleMapController mapController;
  String mapStyle;
  Direction direction;

  Future<List<Polyline>> getPolyline() async {
    direction = await DirectionApi.getDirection(firstLocation, secondLocation);
    List<Polyline> line;
    if (direction != null) {
      line = [direction.polyline];
    }
    return line;
  }

  void getMapStyle() async {
    String style = await rootBundle.loadString("assets/grey.json");
    if (mounted) {
      setState(() {
        mapStyle = style;
      });
    } else {
      mapStyle = style;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    firstLocation = widget.firstLocation;
    secondLocation = widget.secondLocation;
    getMapStyle();

    Marker pickupMarker = new Marker(
        markerId: MarkerId("pickupMarker"),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        position: LatLng(firstLocation.latitude, firstLocation.longitude));

    Marker dropOffMarker = new Marker(
        markerId: MarkerId("drop"),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        position: LatLng(secondLocation.latitude, secondLocation.longitude));

    markers.add(pickupMarker);
    markers.add(dropOffMarker);
    super.initState();
  }

  void focusMapOnBound(GoogleMapController controller) {
    LatLngBounds bounds = new LatLngBounds(
        southwest:
            LocationMathApi.calcSouthWestBound(firstLocation, secondLocation),
        northeast:
            LocationMathApi.calcNorthEastBound(firstLocation, secondLocation));
    CameraUpdate update = CameraUpdate.newLatLngBounds(bounds, 5);
    controller.animateCamera(update);
  }

  @override
  Widget build(BuildContext context) {
    if (mapStyle == null) {
      return Container();
    }

    return GoogleMap(
      key: new GlobalKey(),
      onMapCreated: (controller) {
        mapController = controller;
        controller.setMapStyle(mapStyle);
        if (polyLine.length < 1) {
          getPolyline().then((poly) async {
            if (poly == null) {
              while (polyLine.length == 0) {
                if (mounted) {
                  print('getting polyline');
                  poly = await getPolyline();
                  if (poly != null) {
                    setState(() {
                      polyLine = poly;
                    });
                  }
                } else {
                  break;
                }
              }
            }
            setState(() {
              polyLine = poly;
              focusMapOnBound(controller);
              if (direction != null) {
                widget.onPolylineDrawn(direction);
              }
            });
          });
        }
      },
      initialCameraPosition: CameraPosition(
          target: LatLng(firstLocation.latitude, firstLocation.longitude),
          zoom: 11.0),
      compassEnabled: false,
      trafficEnabled: false,
      myLocationEnabled: false,
      zoomControlsEnabled: false,
      rotateGesturesEnabled: false,
      mapToolbarEnabled: true,
      polylines: polyLine.length > 0 ? polyLine.toSet() : null,
      markers: polyLine.length > 0 ? Set<Marker>.of(markers) : null,
    );
  }
}
