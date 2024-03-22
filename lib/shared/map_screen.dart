import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(

        title: const Text("Location"),
      ),

      body: FlutterMap(
        options: const MapOptions(
          center: LatLng(51.509364, -0.128928),
          zoom: 3.2,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.city_guide',
          ),
          PolygonLayer(
            polygons: [
              Polygon(
                points: [
                  const LatLng(51.509364, -0.128928),
                  const LatLng(51.509364, -0.128928),
                  const LatLng(51.509364, -0.128928),
                  const LatLng(51.509364, -0.128928),
                ],
                color: Colors.red,

              ),
            ],
          ),
        ],
      ),
    );

  }
}
