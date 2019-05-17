import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:flutter/material.dart';

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

  var points = <LatLng>[
     LatLng(-16.6298953, -49.2806259),
     LatLng(-16.7113339, -49.2387288),

  ];

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Univista - Mapa'), backgroundColor: Colors.orange,),
        body: FlutterMap(
              options: _addMapOptions(LatLng(-16.6956321, -49.2655411)),
              layers: [
                /* TileLayerOptions(
                  urlTemplate: "https://api.tiles.mapbox.com/v4/"
                      "{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}",
                  additionalOptions: {
                    'accessToken': 'pk.eyJ1IjoiYWxlZmZhYnJpY2lvIiwiYSI6ImNqdm43b3E2MzA5a2M0OXFrcHk2YnkxYmsifQ._3QyKO8eLWezgeO4NLkq3Q',
                    'id': 'mapbox.streets',
                  },
                ),*/
                //Mapa OpenStreetMaps
                TileLayerOptions(
                  urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c'],
                ),
                // Adiciona o KML image com suas coordenadas
                OverlayImageLayerOptions(
                    overlayImages: [
                      _addKml()
                    ]
                ),
                //Adiciona marcador
                MarkerLayerOptions(
                    markers: [
                      _addMarker(LatLng(-16.6298953, -49.2806259)),
                      _addMarker(LatLng(-16.7113339, -49.2387288))
                    ]
                ),
                PolylineLayerOptions(
                    polylines: [
                      _addPolyline()
                    ]
                )
              ]
          ),
        );
    }

  Marker _addMarker(LatLng _coord){
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
                    Card(
                      color: Colors.orange,
                    );
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

  OverlayImage _addKml(){
    return OverlayImage(
      bounds: LatLngBounds(LatLng(-16.6956321, -49.2655411)),
      imageProvider: AssetImage("assets/images/kmlfazenda.png")
    );
  }

  MapOptions _addMapOptions(LatLng _coord){
    return MapOptions(
            center: _coord,
            minZoom: 5.0,
            maxZoom: 18.0
    );
  }

}
