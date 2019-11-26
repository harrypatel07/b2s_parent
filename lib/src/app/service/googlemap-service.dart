import 'dart:convert';
import 'dart:typed_data';

import 'package:b2s_parent/src/app/core/app_setting.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:ui' as ui;
import 'dart:math' as math;

class GoogleMapService {
  GoogleMapService();

  static Future<Uint8List> _getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        .buffer
        .asUint8List();
  }

  static Future<BitmapDescriptor> getMarkerIcon(String imageAsset,
      {int width: 100}) async {
    final Uint8List markerIcon = await _getBytesFromAsset(imageAsset, width);
    return BitmapDescriptor.fromBytes(markerIcon);
  }

  static Future<List<LatLng>> directionGetListStep(
      LatLng from, LatLng to) async {
    var tripInfo = await directionGetTripInfo(from, to);
    List<LatLng> listLatLng = new List();
    for (var t in tripInfo.steps) {
      listLatLng
          .add(LatLng(t.startLocation.latitude, t.startLocation.longitude));
      listLatLng.add(LatLng(t.endLocation.latitude, t.endLocation.longitude));
    }
    return listLatLng;
  }

  static Future<TripInfoRes> directionGetTripInfo(
      LatLng from, LatLng to) async {
    String strOrigin =
        "origin=" + from.latitude.toString() + "," + from.longitude.toString();
    // Destination of route
    String strDest =
        "destination=" + to.latitude.toString() + "," + to.longitude.toString();
    // Sensor enabled
    String sensor = "sensor=false";
    String mode = "mode=driving";
    // Building the parameters to the web service
    String parameters = strOrigin + "&" + strDest + "&" + sensor + "&" + mode;
    // Output format
    String output = "json";
    // Building the url to the web service
    String url = "https://maps.googleapis.com/maps/api/directions/" +
        output +
        "?" +
        parameters +
        "&key=" +
        ggKey;

    print(url);
    final JsonDecoder _decoder = new JsonDecoder();
    return http.get(url).then((http.Response response) {
      String res = response.body;
      int statusCode = response.statusCode;
//      print("API Response: " + res);
      if (statusCode < 200 || statusCode > 400 || json == null) {
        res = "{\"status\":" +
            statusCode.toString() +
            ",\"message\":\"error\",\"response\":" +
            res +
            "}";
        throw new Exception(res);
      }

      TripInfoRes tripInfoRes;
      try {
        var json = _decoder.convert(res);
        int distance = json["routes"][0]["legs"][0]["distance"]["value"];
        List<StepsRes> steps =
            _parseSteps(json["routes"][0]["legs"][0]["steps"]);

        tripInfoRes = new TripInfoRes(distance, steps);
      } catch (e) {
        throw new Exception(res);
      }

      return tripInfoRes;
    });
  }

  static List<StepsRes> _parseSteps(final responseBody) {
    var list = responseBody
        .map<StepsRes>((json) => new StepsRes.fromJson(json))
        .toList();

    return list;
  }

  ///Hàm xác định xe đã gần tới trạm
  ///true <=> cách trạm <= distance
  ///false <=> cách trạm > distance
  static bool checkTwoPointCloserDistance(
      LatLng latLngCurrent, LatLng latLngStation, double distance) {
    double dLat =
        (latLngStation.latitude - latLngCurrent.latitude) * (math.pi / 180);
    double dLon =
        (latLngStation.longitude - latLngCurrent.longitude) * (math.pi / 180);
    double la1ToRad = latLngCurrent.latitude * (math.pi / 180);
    double la2ToRad = latLngStation.latitude * (math.pi / 180);
    double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(la1ToRad) *
            math.cos(la2ToRad) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);
    double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    double d = 6371000 * c;
    if (distance >= d) return true;
    return false;
  }
}

class TripInfoRes {
  final int distance; // met
  final List<StepsRes> steps;

  TripInfoRes(this.distance, this.steps);
}

class StepsRes {
  LatLng startLocation;
  LatLng endLocation;
  StepsRes({this.startLocation, this.endLocation});
//  Steps();
  factory StepsRes.fromJson(Map<String, dynamic> json) {
    return new StepsRes(
        startLocation: new LatLng(
            json["start_location"]["lat"], json["start_location"]["lng"]),
        endLocation: new LatLng(
            json["end_location"]["lat"], json["end_location"]["lng"]));
  }
}
