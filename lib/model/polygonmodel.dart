
import 'dart:ui';

import 'package:syncfusion_flutter_maps/maps.dart';

class PolygonModel{
  PolygonModel(this.points,this.color);
  final List<MapLatLng> points;
  final Color color;


}