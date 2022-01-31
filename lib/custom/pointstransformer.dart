
import 'package:golf_demo/model/golfmodel.dart';
import 'package:golf_demo/utils/polygonlist.dart';

class PointsTransformer {

  var minLat  = 90.0;
  var maxLat  = -90.0;
  var minLong = 180.0;
  var maxLong = -180.0;
  var padding = 10.0;
  double? width;
  double? height;
  var scale = 2.0;

  PointsTransformer({required this.minLat,required this.maxLat,required this.minLong,
                     required this.maxLong, required this.padding });




  List<GolfModel> getTransformedPolygon(List<GolfModel> polygonList){
    List<GolfModel> resultList=[];

     polygonList.forEach((item) {
       item.golfPolygon.forEach((point) {
         if(point.lat < minLat) {
           minLat = point.lat;
         }
         if(point.lat > maxLat) {
           maxLat = point.lat;
         }
         if(point.long < minLong) {
           minLong = point.long;
         }
         if(point.lat > maxLong) {
           maxLong = point.long;
         }

       });
     });

    var longDiff = maxLong - minLong;
    var latDiff = maxLat - minLat;

    var coOrdinateRatio = latDiff/longDiff;
    var screenRatio = width!/height!;

     if(coOrdinateRatio > screenRatio) {
       scale = (width! - 2 * padding) / latDiff;
     }
     else {
       scale = (height !- 2 * padding) / longDiff;
     }

     GolfModel model;
     GolfPolygon polyModel;
     List<GolfPolygon> polyList=[];
     for (int i =0 ;i<polygonList.length;i++){
       var data = polygonList[i];

       for(int j=0;j<data.golfPolygon.length;j++){
         var polydata = data.golfPolygon[j];
         polydata = GolfPolygon(
             lat: getTransformedLat(polydata.lat),
             long: getTransformedLong(polydata.long)
         );
         polyList.add(polydata);
       }

       model = GolfModel(
           holeid: data.holeid,
           surfacetype: data.surfacetype,
           golfPolygon: polyList
       );

       resultList.add(model);
     }

    return resultList;
  }






  double getTransformedLat(double value){
    return ((value - maxLat) * -1 * scale  + padding);
  }

  double getTransformedLong(double value){
    return ((value - minLong) * scale  + padding);
  }

}