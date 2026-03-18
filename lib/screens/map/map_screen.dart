import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {

  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  LatLng? _currentPosition;

  // 🔥 Replace with your Google API key
  final String apiKey = "AIzaSyC7dumIdvx2avYoynEzyBZVItOGf6IXYS8";

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {

    LocationPermission permission =
    await Geolocator.requestPermission();

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    _currentPosition =
        LatLng(position.latitude, position.longitude);

    _markers.add(
      Marker(
        markerId: const MarkerId("user"),
        position: _currentPosition!,
        infoWindow: const InfoWindow(title: "You"),
        icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueAzure),
      ),
    );

    setState(() {});

    _fetchNearbyTurfs();
  }

  // 🔥 Fetch REAL turfs using Places API
  Future<void> _fetchNearbyTurfs() async {

    if (_currentPosition == null) return;

    final url =
        "https://maps.googleapis.com/maps/api/place/nearbysearch/json"
        "?location=${_currentPosition!.latitude},${_currentPosition!.longitude}"
        "&radius=3000"
        "&keyword=turf"
        "&key=$apiKey";

    final response = await http.get(Uri.parse(url));

    final data = jsonDecode(response.body);

    if (data["results"] != null) {
      for (var place in data["results"]) {

        final lat = place["geometry"]["location"]["lat"];
        final lng = place["geometry"]["location"]["lng"];
        final name = place["name"];

        _markers.add(
          Marker(
            markerId: MarkerId(name),
            position: LatLng(lat, lng),
            infoWindow: InfoWindow(
              title: name,
              snippet: "Sports Turf",
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueGreen),
          ),
        );
      }

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentPosition == null
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _currentPosition!,
          zoom: 14,
        ),
        markers: _markers,
        myLocationEnabled: true,
        onMapCreated: (controller) {
          _mapController = controller;
        },
      ),
    );
  }
}