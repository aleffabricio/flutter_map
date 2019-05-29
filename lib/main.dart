import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:flutter/material.dart';
import 'package:leaftlet_map/src/model/kml.dart';
import 'package:livemap/livemap.dart';
import 'package:sensors/sensors.dart';
import 'dart:math' as math;

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
  var coords = [];
  var sliderValue = 0.0;
  var points = <LatLng>[
    LatLng(-16.6298953, -49.2806259),
    LatLng(-16.7113339, -49.2387288),
  ];
  double ax,ay,az;
  double gx,gy,gz;
  double angulo;

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
  void initState() {
    super.initState();
    gyroscopeEvents.listen((GyroscopeEvent event){
      setState(() {
        gx = event.x;
        gy = event.y;
        gz = event.z;
       // calcularAngulo(gx,gy,gz);
      });
    });
    /*setState(() {
      angulo = _anguloDaRotacao(LatLng(-16.6298953, -49.2806259),LatLng(-16.7113339, -49.2387288));
    });*/
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
          Padding(
            padding: EdgeInsets.all(10.0),
          ),
          FloatingActionButton(
            backgroundColor: Colors.orange,
            child: Icon(
              Icons.label_outline,
              color: Colors.red,
              size: 30.0,
            ),
            onPressed: () {
              mapController.move(LatLng(-16.6298953, -49.2806259), 13.5);
              liveMapController.addMarker(marker: buildMarker(LatLng(-16.6298953, -49.2806259)), name: "kml");
            },
          ),
        ],
      ),
    );
  }

  Marker buildMarker(LatLng point) {
    return Marker(
        anchorPos: AnchorPos.align(AnchorAlign.bottom),
        width: 180.0,
        height: 250.0,
        point: point,
        builder: (context) => Transform.rotate(
              angle: angulo * math.pi/180.0,
              child: Icon(
                Icons.navigation,
                size: 70.0,
              ),
        ));
  }

  getKml() {
    Kml obj = _getKml2();
    OverlayImage(
        bounds: LatLngBounds(
            LatLng(obj.south, obj.west),
            LatLng(obj.north, obj.east)
        ),
        opacity: 1.0,
        imageProvider: AssetImage("assets/images/fazenda.png")
    );
  }

  Kml _getKml2() {
    var objectKml = Kml(1, "teste", -54.5904758912788, -20.6517650974851,
        -20.6819818271086, -54.6118412556591, "assets/images/kmlfazenda.png");

    return objectKml;
  }

  double _anguloDaRotacao(@required LatLng latLngInicial, @required LatLng latLngFinal){

    LatLng ptTmp = LatLng(latLngInicial.latitude,latLngFinal.longitude);

    var distOrigemAoTmp  = _distanciaEntrePontos(latLngInicial, ptTmp);
    var distTmpAoDestino = _distanciaEntrePontos(ptTmp, latLngFinal);
    var angle  = math.atan(distTmpAoDestino / distOrigemAoTmp) / math.pi * 180;

    /* 1º quadrante */
    if (latLngFinal.latitude < latLngInicial.latitude && latLngFinal.longitude < latLngInicial.longitude)
      return 90 - angle + 180;
    /* 2º quadrante */
    if (latLngFinal.latitude < latLngInicial.latitude && latLngFinal.longitude > latLngInicial.longitude)
      return 90 + angle;
    /* 3º quadrante */
    if (latLngFinal.latitude > latLngInicial.latitude && latLngFinal.longitude > latLngInicial.longitude)
      return 90 - angle;
    /* 4º quadrante */
    if (latLngFinal.latitude > latLngInicial.latitude && latLngFinal.longitude < latLngInicial.longitude)
      return 90 + angle + 180;
    return angle;
  }

  double _distanciaEntrePontos(LatLng latLngInicial, LatLng latLngFinal){

    var lat1 = latLngInicial.latitude;
    var lon1 = latLngInicial.longitude;
    var lat2 = latLngFinal.latitude;
    var lon2 = latLngFinal.longitude;
    var RADIUSKILOMETERS = 6371;
    var latR1 = calcularRadiano(lat1);
    var lonR1 = calcularRadiano(lon1);
    var latR2 = calcularRadiano(lat2);
    var lonR2 = calcularRadiano(lon2);
    var latDifference = latR2 - latR1;
    var lonDifference = lonR2 - lonR1;
    var a = math.pow(math.sin(latDifference / 2), 2) + math.cos(latR1) * math.cos(latR2) * math.pow(math.sin(lonDifference / 2), 2);
    var c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    var dk = c * RADIUSKILOMETERS;
    var m = (dk) * 1000;

    return m;
  }

  double calcularRadiano(deg){
    var rad = deg * math.pi / 180;
    return rad;
  }


  void calcularAngulo(double ax, double ay, double az){
    const const_calib = 16071.82;
    const const_gravid = 9.81;
    const G_GAIN = 0.00875;
/*
    var acelx = ax * const_gravid / const_calib;
    var acely = ay * const_gravid / const_calib;
    var acelz = az * const_gravid / const_calib;


    var AccXangle = (math.atan2(ax, math.sqrt(math.pow(ay,2) + math.pow(az,2)))*180) / math.pi;
    var AccYangle = (math.atan2(ay, math.sqrt(math.pow(ax,2) + math.pow(az,2)))*180) / math.pi;
    var AccZangle = (math.atan2(az, math.sqrt(math.pow(ax,2) + math.pow(ay,2)))*180) / math.pi;
 */

    var rate_gyr_x = ax*G_GAIN;
    var rate_gyr_y = ay*G_GAIN;
    var rate_gyr_z = az*G_GAIN;


    setState(() {
      angulo = gz;
    });
    print("valor angulo X : $rate_gyr_x ");
  }



}
