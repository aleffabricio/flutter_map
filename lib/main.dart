import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:flutter/material.dart';
import 'package:leaftlet_map/src/model/kml.dart';
import 'package:livemap/livemap.dart';
import 'package:sensors/sensors.dart';
import 'package:location/location.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  var center = [];
  var points = <LatLng>[
    LatLng(-16.6298953, -49.2806259),
    LatLng(-16.7113339, -49.2387288),
  ];

  _MyHomePageState() {
    mapController = MapController();
    liveMapController = LiveMapController(mapController: mapController);
  }

  MapController mapController;
  LiveMapController liveMapController;

  @override
  void dispose() {
    liveMapController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: LiveMap(
          mapController: mapController,
          liveMapController: liveMapController,
          mapOptions: MapOptions(
            center: LatLng(51.0, 0.0),
            zoom: 17.0,
          ),
          titleLayer: TileLayerOptions(
              urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
              subdomains: ['a', 'b', 'c']),
        ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Padding(padding: EdgeInsets.all(10.0),),
          FloatingActionButton(backgroundColor: Colors.orange,
            child: Icon(Icons.label_outline, color: Colors.red, size: 30.0,),
            onPressed: (){
              mapController.move(LatLng(center[0],center[1]), 13.5);
            },
          ),
        ],
      ),);
  }

  Marker buildMarker(String name, LatLng point) {
    return Marker(
        anchorPos: AnchorPos.align(AnchorAlign.bottom),
        width: 180.0,
        height: 250.0,
        point: point,
        builder: (context) => Container(
          child: Container(),
        ));
  }

   getKml(){
    Kml obj = _getKml2();
     OverlayImage(
        bounds: LatLngBounds(LatLng(obj.south, obj.west), LatLng(obj.north, obj.east)),
        opacity: 1.0,
        imageProvider: AssetImage("assets/images/fazenda.png")
    );
  }

  Kml _getKml2() {
    var objectKml = Kml(
        1,
        "teste",
        -54.5904758912788,
        -20.6517650974851,
        -20.6819818271086,
        -54.6118412556591,
        "assets/images/kmlfazenda.png"
    );

    return objectKml;
  }




}
