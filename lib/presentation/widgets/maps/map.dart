import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

// Coordenadas de Quito como fallback
const _kDefaultLat = -0.1807;
const _kDefaultLng = -78.4678;

class MapApp extends StatelessWidget {
  final double? latitude;
  final double? longitude;

  const MapApp({super.key, this.latitude, this.longitude});

  /// Devuelve true solo si el valor es un double real y finito
  static bool _isValid(double? v) => v != null && v.isFinite;

  @override
  Widget build(BuildContext context) {
    // Validación centralizada ANTES de tocar LatLng
    final bool hasValidCoords = _isValid(latitude) && _isValid(longitude);

    final LatLng center = hasValidCoords
        ? LatLng(latitude!, longitude!)
        : const LatLng(_kDefaultLat, _kDefaultLng);

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

          // El marker solo aparece si hay coordenadas reales
          if (hasValidCoords)
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
