import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_maps/maps.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}



class _HomeScreenState extends State<HomeScreen> {

  late MapZoomPanBehavior _zoomPanBehavior;
  late List<MapLatLng> _polygon;
  late MapShapeSource _mapSource;


  @override
  void initState() {

    _polygon = <MapLatLng>[
      MapLatLng(38.8026, -116.4194),
      MapLatLng(46.8797, -110.3626),
      MapLatLng(41.8780, -93.0977),
    ];

    _mapSource = MapShapeSource.asset(
      'assets/usa.json',
      shapeDataField: 'name',
    );

    _zoomPanBehavior = MapZoomPanBehavior();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Polygon shape')),
      body: SfMaps(layers: [
        MapShapeLayer(
          source: _mapSource,
          sublayers: [
            MapPolygonLayer(
              polygons: List<MapPolygon>.generate(
                1,
                    (int index) {
                  return MapPolygon(
                    points: _polygon,
                  );
                },
              ).toSet(),
            ),
          ],
          zoomPanBehavior: _zoomPanBehavior,
        ),
      ]),
    );
  }
}
