import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapApp extends StatelessWidget {
  final double? latitude;
  final double? longitude;

  const MapApp({super.key, this.latitude, this.longitude});

  @override
  Widget build(BuildContext context) {
    final lat = (latitude != null && latitude!.isFinite) ? latitude! : -0.1807;
    final lng = (longitude != null && longitude!.isFinite)
        ? longitude!
        : -78.4678;
    final center = LatLng(lat, lng);

    return Container(
      height: 300,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: FlutterMap(
        options: MapOptions(
          initialCenter: center,
          initialZoom: 13,
          minZoom: 3,
          maxZoom: 18,
          interactionOptions: const InteractionOptions(
            flags: InteractiveFlag.all,
          ),
        ),
        children: [
          TileLayer(
            urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
            userAgentPackageName: 'com.telearseg.zentinel',
            maxZoom: 18,
            minZoom: 3,
          ),

          // ✅ Guard: solo renderiza si las coordenadas son válidas
          if (center.latitude.isFinite && center.longitude.isFinite)
            MarkerLayer(
              markers: [
                Marker(
                  point: center,
                  width: 40,
                  height: 40,
                  child: const Icon(
                    Icons.location_on,
                    size: 40,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
