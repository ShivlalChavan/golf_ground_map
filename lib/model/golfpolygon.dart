class GolfPolygon{
  double lat;
  double long;

  GolfPolygon({required this.lat,required this.long});

  factory GolfPolygon.fromJson(Map<String,dynamic> json) => GolfPolygon(lat:json['lat'], long:json['long']);

}