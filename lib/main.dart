import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:flutter/material.dart';
import 'kml.dart';
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
  MapController mapController;

  var points = <LatLng>[
    LatLng(-16.6298953, -49.2806259),
    LatLng(-16.7113339, -49.2387288),
  ];

  @override
  void initState() {
    super.initState();
    mapController = MapController();
    _getLocation();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Univista - Mapa'),
        backgroundColor: Colors.orange,
      ),
      body: FlutterMap(
          mapController: mapController,
          options: _addMapOptions(LatLng(-13.776471219494596, -55.6400638224566)),
          layers: [
             TileLayerOptions(
                  urlTemplate: "https://api.tiles.mapbox.com/v4/"
                      "{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}",
                  additionalOptions: {
                    'accessToken': 'pk.eyJ1IjoiYWxlZmZhYnJpY2lvIiwiYSI6ImNqdm43b3E2MzA5a2M0OXFrcHk2YnkxYmsifQ._3QyKO8eLWezgeO4NLkq3Q',
                    'id': 'mapbox.satellite',
                  },
                ),
            //Mapa OpenStreetMaps
            /*TileLayerOptions(
              urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
              subdomains: ['a', 'b', 'c'],
            ),*/
            // Adiciona o KML image com suas coordenadas
            OverlayImageLayerOptions(
                overlayImages: [
                  _addKml()
                ]
            ),
            PolylineLayerOptions(
                polylines: [
                  _addPolyline()
                ]
            ),
            MarkerLayerOptions(
                markers: [
                  _addMarker(LatLng(-16.7113339, -49.2387288)),

                ]
            ),
            CircleLayerOptions(
                circles: [
                  CircleMarker(
                      point: LatLng(-16.6298953, -49.2806259),
                      color: Colors.blue.withOpacity(0.3),
                      borderStrokeWidth: 3.0,
                      borderColor: Colors.blue,
                      radius: 100 //radius
                  )
                ],
            ),

          ]
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(backgroundColor: Colors.orange,
            child: Icon(Icons.location_on, color: Colors.red, size: 30.0,),
            onPressed: (){
              mapController.move(LatLng(-16.7113339, -49.2387288), 13.5);
            },
          ),
          Padding(padding: EdgeInsets.all(10.0),),
          FloatingActionButton(backgroundColor: Colors.orange,
            child: Icon(Icons.label_outline, color: Colors.red, size: 30.0,),
            onPressed: (){
              mapController.move(LatLng(center[0],center[1]), 13.5);
            },
          ),
        ],
      ),
    );
  }

  Marker _addMarker(LatLng _coord,){
    return  Marker(
        width: 45.0,
        height: 45.0,
        point: _coord,
        builder: (context) => Container(
          child: IconButton(
            icon: Icon(Icons.location_on,size: 70.0,),
            color: Colors.red,
            iconSize: 45.0,
            onPressed: () {
              print('Criar card para trazer os dados da ocorrencia');
            },
          ),
        )
    );
  }

  Polyline _addPolyline(){
    return Polyline(
        isDotted: true,
        points: points,
        strokeWidth: 7.0,
        color: Colors.red
    );
  }
//var coordscenter = [(parseFloat(object.east) + parseFloat(object.west)) / 2, (parseFloat(object.north) + parseFloat(object.south)) / 2];
  OverlayImage _addKml(){
    //Kml obj = _getKml();
    Kml obj = _getKml2();
    return OverlayImage(
        bounds: LatLngBounds(LatLng(obj.south, obj.west), LatLng(obj.north, obj.east)),
        opacity: 1.0,
        imageProvider: AssetImage("assets/images/fazenda.png")
    );
/*
    North: -13.757677476543392
    south: -13.776471219494596
    east: -55.6171044176215
    West: -55.6400638224566
*/
  }

  MapOptions _addMapOptions(LatLng _coord){
    //Kml obj = _getKml();
    Kml obj = _getKml2();
    setState(() {
      center = [(obj.north + obj.south) / 2,(obj.east + obj.west) / 2]; //Calculo para abrir o mapa com o centro do kml
    });
    print(center);
    return MapOptions(
        zoom: 13.5,
        center: LatLng(center[0],center[1]),
        minZoom: 5.0,
        maxZoom: 18.0,
    );
  }

  void coords(){
    Kml objKml = _getKml();

  }

  Kml _getKml() {
    var objectKml = Kml(
        1,
        "teste",
        -55.6171044176215,
        -13.757677476543392,
        -13.776471219494596,
        -55.6400638224566,
        "assets/images/kmlfazenda.png"
    );

    return objectKml;
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


  void gyroscope(){
    accelerometerEvents.listen((AccelerometerEvent event) {
      // Do something with the event.
    });

    gyroscopeEvents.listen((GyroscopeEvent event) {
      setState(() {
        print("valor do gyroscopio");
        print(event.x);
        print(event.y);
        print(event.z);
      });
    });

  }

  _getLocation(){
    var location = new Location();

    location.onLocationChanged().listen((LocationData currentLocation) {
        print(currentLocation.latitude);
        print(currentLocation.longitude);
    });
  }



}
