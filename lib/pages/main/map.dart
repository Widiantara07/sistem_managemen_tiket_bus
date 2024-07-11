import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:sistem_managemen_tiket_bus/pages/main/scan_qr.dart';
import 'package:sistem_managemen_tiket_bus/pages/main/settings.dart';
import 'package:sistem_managemen_tiket_bus/pages/main/wallet.dart';
import 'package:sistem_managemen_tiket_bus/providers/map_provider.dart';
import 'package:sistem_managemen_tiket_bus/services/api_map_service.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  List listOfPoints = [];
  List<LatLng> points = [];
  List<Map<String, dynamic>> busStations = [];
  int selectedIndex = -1;
  LatLng start = const LatLng(0, 0);
  bool loadingPath = false;

  @override
  void initState() {
    super.initState();
    getStations();
  }

  Future<Position> locateUser() async {
    return Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Future<void> getStations() async {
    final provider = Provider.of<MapProvider>(context, listen: false);
    setState(() {
      loadingPath = true;
    });
    Position currentPosition = await locateUser();

    if (!mounted) return;

    setState(() {
      loadingPath = false;
      start = LatLng(
        currentPosition.latitude,
        currentPosition.longitude,
      );
    });

    final stations = await provider.stations(start);

    if (!mounted) return;

    setState(() {
      busStations = stations;
    });
  }

  Future<void> getCoordinates(LatLng start, LatLng end) async {
    setState(() {
      loadingPath = true;
    });

    var response = await http.get(
      getRouteUrl(
        "${start.longitude},${start.latitude}",
        '${end.longitude},${end.latitude}',
      ),
    );

    setState(() {
      loadingPath = false;
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        listOfPoints = data['features'][0]['geometry']['coordinates'];
        points = listOfPoints
            .map((p) => LatLng(p[1].toDouble(), p[0].toDouble()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Nearby Bus Stations'),
        // drawer possible?
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.money_dollar_circle),
          onPressed: () {
            Navigator.push(
              context,
              CupertinoDialogRoute(
                builder: (context) => const MyWalletPage(),
                context: context,
              ),
            );
          },
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.gear),
          onPressed: () {
            Navigator.push(
              context,
              CupertinoDialogRoute(
                builder: (context) => const SettingsPage(),
                context: context,
              ),
            );
          },
        ),
      ),
      child: SafeArea(
        child: Stack(
          children: [
            FlutterMap(
              options: const MapOptions(
                initialZoom: 15.0,
              ),
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      points.clear();
                      selectedIndex = -1;
                    });
                  },
                  child: TileLayer(
                    urlTemplate:
                        "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                  ),
                ),
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: points,
                      color: const Color.fromRGBO(81, 128, 240, 1),
                      strokeWidth: 5,
                    ),
                  ],
                ),
                MarkerLayer(
                  markers: [
                    for (int i = 0; i < busStations.length; i++)
                      Marker(
                        point: LatLng(
                          (busStations[i]['location'] as GeoPoint).latitude,
                          (busStations[i]['location'] as GeoPoint).longitude,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              getCoordinates(
                                start,
                                LatLng(
                                  (busStations[i]['location'] as GeoPoint)
                                      .latitude,
                                  (busStations[i]['location'] as GeoPoint)
                                      .longitude,
                                ),
                              );
                              selectedIndex = i;
                            });
                          },
                          child: Stack(
                            children: [
                              Image.asset('lib/assets/images/marker.png'),
                              Positioned.fill(
                                bottom: 10,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    String.fromCharCode(i + 65),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
                CurrentLocationLayer(
                  alignPositionOnUpdate: AlignOnUpdate.once,
                  alignDirectionOnUpdate: AlignOnUpdate.never,
                  style: const LocationMarkerStyle(
                    marker: DefaultLocationMarker(
                      child: Icon(
                        Icons.navigation,
                        color: Colors.white,
                      ),
                    ),
                    markerSize: Size(40, 40),
                    markerDirection: MarkerDirection.heading,
                  ),
                ),
              ],
            ),
            selectedIndex == -1
                ? Positioned.fill(
                    bottom: 16,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => const ScanQRPage(),
                            ),
                          );
                        },
                        child: Image.asset('lib/assets/images/qr.png'),
                      ),
                    ),
                  )
                : Positioned.fill(
                    bottom: 16,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: const BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.all(
                            Radius.circular(16),
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              busStations[selectedIndex]['alamat'],
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
            if (loadingPath)
              Positioned.fill(
                child: Container(
                  color: Colors.white.withOpacity(0.5),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
            Positioned(
              left: 16,
              top: 16,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (int i = 0; i < busStations.length; i++) ...[
                      CupertinoButton(
                        onPressed: () => setState(() {
                          getCoordinates(
                            start,
                            LatLng(
                              (busStations[i]['location'] as GeoPoint).latitude,
                              (busStations[i]['location'] as GeoPoint)
                                  .longitude,
                            ),
                          );
                          selectedIndex = i;
                        }),
                        padding: EdgeInsets.zero,
                        color: selectedIndex == i
                            ? const Color.fromARGB(255, 57, 162, 249)
                            : const Color.fromARGB(183, 255, 255, 255),
                        borderRadius: BorderRadius.circular(8),
                        child: Text(
                          String.fromCharCode(i + 65),
                          style: TextStyle(
                            color: selectedIndex == i
                                ? Colors.white
                                : const Color.fromARGB(255, 3, 70, 125),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                    ]
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
