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

  final position = MapPosition(bounds: LatLngBounds(LatLng(-16.6956321, -49.2655411)),zoom: 10.0,center: LatLng(-16.6956321, -49.2655411));

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Univista - Mapa'), backgroundColor: Colors.orange,),
        body: FlutterMap(

            options: MapOptions(center: LatLng(-16.6956321, -49.2655411), minZoom: 5.0,),
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

             // KML
              OverlayImageLayerOptions(
                overlayImages: [
                  OverlayImage(
                      bounds: LatLngBounds(LatLng(-16.6956321, -49.2655411)),
                      imageProvider: AssetImage("assets/images/kmlfazenda.png")
                  ),
                ]
              ),


              //Marcador
              MarkerLayerOptions(
                  markers: [
                    Marker(
                        width: 45.0,
                        height: 45.0,
                        point: LatLng(-16.6956321, -49.2655411),
                        builder: (context) => Container(
                          child: IconButton(
                            icon: Icon(Icons.location_on,),
                            color: Colors.red,
                            iconSize: 45.0,
                            onPressed: () {
                              print('Criar ação');
                            },
                          ),
                        )
                    ),
                  ])

                  ]));
    }

    void addMarker(){
      MarkerLayerOptions(
          markers: [
            Marker(
                width: 45.0,
                height: 45.0,
                point: LatLng(-16.6956321, -49.2655411),
                builder: (context) => Container(
                  child: IconButton(
                    icon: Icon(Icons.location_on,),
                    color: Colors.red,
                    iconSize: 45.0,
                    onPressed: () {
                      print('Criar ação');
                    },
                  ),
                )
            ),
          ]);
    }

  void addKml(){

      OverlayImage(
        bounds: LatLngBounds(LatLng(-16.6956321, -49.2655411)),
        imageProvider: AssetImage("assets/images/kmlfazenda.png")
      );
    }




}
