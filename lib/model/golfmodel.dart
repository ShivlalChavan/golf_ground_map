import 'dart:convert';

import 'package:golf_demo/model/golfpolygon.dart';

class GolfModel {
  int holeid;
  String surfacetype;
  List<GolfPolygon> golfPolygon;

  GolfModel(
      {required this.holeid,
      required this.surfacetype,
      required this.golfPolygon});

  factory GolfModel.fromJson(Map<String, dynamic> json) {
    List<GolfPolygon>? polyList;
    final List<dynamic>? list = json['polygon'] as List<dynamic>;
    if (list != null && list.isNotEmpty) {
      polyList = list
          .map((dynamic i) => GolfPolygon.fromJson(i as Map<String, dynamic>))
          .toList();
    }

    return GolfModel(
        holeid: json['holeid'],
        surfacetype: json['surfacetype'],
        golfPolygon: polyList!);
  }
}

class GolfPolygon {
  double lat;
  double long;

  GolfPolygon({required this.lat, required this.long});

  factory GolfPolygon.fromJson(Map<String, dynamic> json) =>
      GolfPolygon(lat: json['lat'], long: json['long']);
}
