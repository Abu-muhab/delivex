import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math' as Math;

class LocationMathApi {
  static LatLng calcNorthEastBound(LatLng pos1, LatLng pos2) {
    double lat;
    double lng;
    if (pos1.latitude > pos2.latitude) {
      lat = pos1.latitude;
    } else {
      lat = pos2.latitude;
    }

    if (pos1.longitude > pos2.longitude) {
      lng = pos1.longitude;
    } else {
      lng = pos2.longitude;
    }
    return LatLng(lat, lng);
  }

  static LatLng calcSouthWestBound(LatLng pos1, LatLng pos2) {
    double lat;
    double lng;
    if (pos1.latitude < pos2.latitude) {
      lat = pos1.latitude;
    } else {
      lat = pos2.latitude;
    }

    if (pos1.longitude < pos2.longitude) {
      lng = pos1.longitude;
    } else {
      lng = pos2.longitude;
    }
    return LatLng(lat, lng);
  }

  static double getDistanceFromLatLonInKm(
      double lat1, double lon1, double lat2, double lon2) {
    var R = 6371; // Radius of the earth in km
    var dLat = deg2rad(lat2 - lat1); // deg2rad below
    var dLon = deg2rad(lon2 - lon1);
    var a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
        Math.cos(deg2rad(lat1)) *
            Math.cos(deg2rad(lat2)) *
            Math.sin(dLon / 2) *
            Math.sin(dLon / 2);
    var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
    var d = R * c; // Distance in km
    return d;
  }

  static double deg2rad(deg) {
    return deg * (Math.pi / 180);
  }
}
