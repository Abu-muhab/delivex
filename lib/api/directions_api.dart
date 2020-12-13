import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:polyline/polyline.dart' as poly;
import 'package:node_auth/api/search_api.dart';
import 'package:node_auth/models/direction.dart';

class DirectionApi {
  static Future<Direction> getDirection(
      LatLng origin, LatLng destination) async {
    String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&key=$api_key';
    http.Response response = await http.get(url);
    if (response.statusCode == 200) {
      Map data = JsonDecoder().convert(response.body);
      if (data['status'] == 'OK') {
        var distance = data['routes'][0]['legs'][0]['distance']['value'];
        LatLng ori = LatLng(
            data['routes'][0]['legs'][0]['start_location']['lat'],
            data['routes'][0]['legs'][0]['start_location']['lng']);
        LatLng des = LatLng(data['routes'][0]['legs'][0]['end_location']['lat'],
            data['routes'][0]['legs'][0]['end_location']['lng']);
        String overveiwPolylineString =
            data['routes'][0]['overview_polyline']['points'];

        print('${ori.latitude},${ori.longitude}');
        print('${des.latitude},${des.longitude}');
        print(overveiwPolylineString);

        Polyline polyline = Polyline(
            width: 4,
            polylineId: PolylineId('distance_overview'),
            points: coordinatesConverter(poly.Polyline.Decode(
                precision: 5, encodedString: overveiwPolylineString)));

        return Direction(
            distance: distance,
            origin: ori,
            destination: des,
            overviewPolylineString: overveiwPolylineString,
            polyline: polyline);
      }
      print(data);
      return null;
    }
    print(response.body);
    return null;
  }

  static List<LatLng> coordinatesConverter(poly.Polyline polyline) {
    var points = polyline.decodedCoords;
    List<LatLng> coordinates = new List();
    points.forEach((element) {
      coordinates.add(LatLng(element[0], element[1]));
    });
    return coordinates;
  }
}
