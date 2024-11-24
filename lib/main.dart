import 'package:flutter/material.dart';
import 'package:route_tracker_app/views/google_map_view.dart';

void main() {
  runApp(const RouteTrackerApp());
}

class RouteTrackerApp extends StatelessWidget {
  const RouteTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GoogleMapView(),
    );
  }
}
