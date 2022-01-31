import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:golf_demo/model/golfmodel.dart';
import 'package:golf_demo/screens/polygonlist.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoGolfMap extends StatefulWidget {
  const GoGolfMap({Key? key}) : super(key: key);

  @override
  _GoGolfMapState createState() => _GoGolfMapState();
}

class _GoGolfMapState extends State<GoGolfMap> {

  Set<Polygon> _polygons = HashSet<Polygon>();
  late GoogleMapController _googleMapController;
  Completer<GoogleMapController> _controller = Completer();

  //List<LatLng> polygonLatLngs = PolyList().getPloyList();
//  List<LatLng> polygonLatLngs = [];
//   List<LatLng> woodsLatLngs = [];
//   List<LatLng> polygonLatLngs = [];
  List<LatLng> polygonLatLngs = PolyList().getGreenList();
  List<LatLng> woodsLatLngs = PolyList().getPloyList();
  List<LatLng> sandsLatLngs = PolyList().getWoodsList();
  List<LatLng> fairyLatLngs = PolyList().getFairyList();

  bool _isPolygon = false;
  int _polygonIdCounter = 1;
  Set<Marker> _markers = HashSet<Marker>();
  late List<GolfPolygon> golfPolygons;
  late List<GolfPolygon> woodsPolygons;

  bool isLoading= false;
  late BitmapDescriptor markerIcon;

  @override
  void initState() {
    //loadJsonData();
    customMarker();
    super.initState();
  }

  Set<Polygon>_setPolygon() {
    final String polygonIdVal = 'polygon_id_$_polygonIdCounter';
    final String polygonWoodIdVal = 'polygon_id_$_polygonIdCounter';
    _polygons.add(
      Polygon(
      polygonId: PolygonId(polygonIdVal),
      points: polygonLatLngs,
      strokeWidth: 2,
      strokeColor: Colors.deepOrange,
      fillColor: Colors.green,
     ),);

    _polygons.add(Polygon(
      polygonId: PolygonId(polygonWoodIdVal),
      points: woodsLatLngs,
      strokeWidth: 2,
      strokeColor: Colors.amberAccent,
      fillColor: Colors.yellow.shade100,
    ),);

    _polygons.add(Polygon(
      polygonId: PolygonId(polygonWoodIdVal+"1"),
      points: sandsLatLngs,
      strokeWidth: 2,
      strokeColor: Colors.greenAccent,
      fillColor: Colors.blue,
    ),);

    _polygons.add(Polygon(
      polygonId: PolygonId(polygonWoodIdVal+"3"),
      points: fairyLatLngs,
      strokeWidth: 2,
      strokeColor: Colors.deepOrange.shade100,
      fillColor: Colors.green,
    ),);

    return _polygons;
  }

  void _onMapCreated(GoogleMapController controller) {
    _googleMapController = controller;

    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId('0'),
          position: LatLng(47.3838280088967, -122.2652605175972),
          infoWindow:
          InfoWindow(title: 'GolfMap'),
          icon:  markerIcon,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    if(isLoading){
      return Scaffold(
        body: Container(

        ),
      );
    }else {
      return Scaffold(
        body: Stack(
          children: <Widget>[
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(47.383097939669625, -122.26424396038055),
                zoom: 16,
              ),
              onMapCreated:(GoogleMapController controller){
                _onMapCreated(controller);
                //_controller.complete(controller);
              },
              mapType: MapType.hybrid,
              markers: _markers,
              polygons: _setPolygon(),
              myLocationEnabled: true,
            ),
            // Align(
            // alignment: Alignment.bottomCenter,
            //   child: Row(
            //     children: [
            //       RaisedButton(
            //           color: Colors.black54,
            //           onPressed: () {
            //             _isPolygon = true;
            //
            //           },
            //           child: Text(
            //             'Polygon',
            //             style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            //           )),
            //     ],
            //   ),
            // )
          ],
        ),
      );
    }
  }

  Future<void> loadJsonData() async {
    var jsonText = await rootBundle.loadString('assets/golf.json');
    var resultData = json.decode(jsonText);
    print("JsonData-${resultData}");


   await  showPolygonView(resultData['resources']);
   final GoogleMapController controller = await _controller.future;
  //  controller.animateCamera(CameraUpdate.newCameraPosition())
  }

  Future<void> showPolygonView(var golfData) async{

    List<GolfModel> data =   golfDataModelFromJson(golfData);
   // golfPolygons = data[0].golfPolygon;

    List<GolfPolygon> resultList=[];
    List<GolfPolygon> woodsList=[];

    for(int i=0;i<data.length;i++){
      var item = data[i];
      if(item.surfacetype=='Green'){
        resultList = data[i].golfPolygon;
      }
      if(item.surfacetype=='Woods'){
        woodsList = data[i].golfPolygon;
      }
    }
    golfPolygons = resultList;


    polygonLatLngs.clear();
    woodsLatLngs.clear();
    for(var i=0;i<golfPolygons.length;i++){
      var mapModel = LatLng(golfPolygons[i].lat,golfPolygons[i].long);
     polygonLatLngs.add(mapModel);
    }

    woodsPolygons =  woodsList;
    for(var i=0;i<woodsList.length;i++){
      var mapModel = LatLng(woodsList[i].lat,woodsList[i].long);
      woodsLatLngs.add(mapModel);
    }


    // setState(() {
    //   isLoading = false;
    // });

  }

  List<GolfModel> golfDataModelFromJson(jsom) {
    List<GolfModel> golfList=[];
    final List<dynamic>? list = jsom as List<dynamic>;

    if (list != null && list.isNotEmpty) {
      golfList = list
          .map((dynamic i) => GolfModel.fromJson(i as Map<String, dynamic>))
          .toList();
    }
    // var golfModel  = GolfModel.fromJson(jsom[0]);
    // golfList.add(golfModel as GolfModel);
    return golfList;
  }

  void customMarker(){
    BitmapDescriptor.fromAssetImage(
        ImageConfiguration(),
        'assets/images/icon_flag.png').
         then((value) =>
            markerIcon = value
       );
  }
}
