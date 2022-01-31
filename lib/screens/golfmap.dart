

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:golf_demo/model/golfmodel.dart';
import 'package:golf_demo/model/polygonmodel.dart';
import 'package:syncfusion_flutter_maps/maps.dart';


class GolfMapScreen extends StatefulWidget {
  const GolfMapScreen({Key? key}) : super(key: key);

  @override
  _GolfMapScreenState createState() => _GolfMapScreenState();
}

class _GolfMapScreenState extends State<GolfMapScreen> {

   var data;
   late List<PolygonModel> polygons;
   late List<GolfPolygon> golfPolygons;
   late List<MapLatLng> polygonGreen;
   late List<MapLatLng> polygonWhite;
   late List<MapLatLng> polygonSand;
   late MapShapeSource dataSource;
   late MapZoomPanBehavior _zoomPanBehavior;
   bool isLoding = true;

  @override
  void initState() {

    this.loadJsonData();

    dataSource = MapShapeSource.asset(
      'assets/custom.geo.json',
      shapeDataField: 'continent',
    );

    _zoomPanBehavior = MapZoomPanBehavior();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(isLoding){
      return Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child:Text(
                'Loading...',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                ),
              ) ,
            ),

          ],
        ),
      );
    }
    else {
      return Scaffold(
        body: SfMaps(
          layers: [
            MapShapeLayer(
              source: dataSource,
              sublayers: [
                MapPolygonLayer(
                    polygons: List<MapPolygon>.generate(
                      polygons.length,
                          (int index) {
                        return MapPolygon(
                            points: polygons[index].points,
                            color: polygons[index].color
                        );
                      },
                    ).toSet()
                ),
              ],
              zoomPanBehavior: _zoomPanBehavior,
            ),
          ],
        ),
      );
     }
  }

  Future<String> loadJsonData() async {
    var jsonText = await rootBundle.loadString('assets/golf.json');
    var resultData = json.decode(jsonText);
    print("JsonData-${resultData}");

     setState(() => data  = resultData);

     showPolygonView(resultData['resources']);
    return 'success';
  }

  void showPolygonView(var golfData){

    List<GolfModel> data = golfDataModelFromJson(golfData);
   // golfPolygons = data[0].golfPolygon;

    List<GolfPolygon> resultList=[];

    for(int i=0;i<data.length;i++){
      var item = data[i];
      if(item.surfacetype=='Green'){
        resultList = data[i].golfPolygon;
      }
    }
    golfPolygons = resultList;
    List<MapLatLng> mapList=[];
    for(var i=0;i<golfPolygons.length;i++){
       var mapModel = MapLatLng(golfPolygons[i].lat,golfPolygons[i].long);
        mapList.add(mapModel);
    }
    polygonGreen = mapList;

    polygons = <PolygonModel>[
       PolygonModel(mapList, Colors.green)
    ];


    setState(() {
      isLoding = false;
      print("isLoding-false");
    });
  }

  List<GolfModel> golfDataModelFromJson(jsom) {
    List<GolfModel> golfList=[];
    List <PolygonModel>? polygonList = null;

      var golfModel  = GolfModel.fromJson(jsom[0]);
      print("GolfList-${golfModel.surfacetype}");
      golfList.add(golfModel as GolfModel);

  return golfList;
  }

}


