
import 'dart:async';
import 'dart:convert';
import 'dart:io' as Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:golf_demo/model/golfmodel.dart';
import 'package:golf_demo/model/polygonmodel.dart';
import 'package:syncfusion_flutter_maps/maps.dart';
import 'package:webview_flutter/webview_flutter.dart';



class CustomGolf extends StatefulWidget {
  const CustomGolf({Key? key}) : super(key: key);

  @override
  _CustomGolfState createState() => _CustomGolfState();

}


class _CustomGolfState extends State<CustomGolf> {

  var data;
  late List<PolygonModel> polygons;
  late List<GolfPolygon> golfPolygons;
  late List<MapLatLng> polygonGreen;
  bool isLoding = true;
  final Completer<WebViewController> _controller = Completer<WebViewController>();


  String webJs = '''
    <!DOCTYPE html><html>
      <head><title>Navigation Delegate Example</title></head>
      <body> 
      <h1>Local demo page</h1>
       <p>
        This is an example page used to demonstrate how to load a local file or HTML 
        string using the <a href="https://pub.dev/packages/webview_flutter">Flutter 
        webview</a> plugin. 
       </p>
      </body>
      </html>
    ''';


  CustomPaint customPaint = new CustomPaint(
    size: Size(400.0,400.0),
    painter: new Line(),
  );



  @override
  void initState() {
    loadJsonData();
    if(Platform.Platform.isAndroid){
      WebView.platform = SurfaceAndroidWebView();
    }
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: GestureDetector(
         child: Container(
          alignment: FractionalOffset.center,
           child: customPaint,
         ),
      ),
    );
  }



  Future<String> loadJsonData() async {
    var jsonText = await rootBundle.loadString('assets/golf.json');
    var resultData = json.decode(jsonText);
    showPolygonView(resultData['resources']);
    return 'success';
  }

  void showPolygonView(var golfData){

    List<GolfModel> data = golfDataModelFromJson(golfData);
    golfPolygons = data[0].golfPolygon;
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
    });
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


}

class Line extends CustomPainter{
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawLine(new Offset(100.0, -50).translate(0.0, 100.0), new Offset(100.0, -50).translate(0.0, 100.0), new Paint());
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    
    throw UnimplementedError();
  }

}
