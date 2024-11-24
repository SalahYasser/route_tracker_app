import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:route_tracker_app/utils/location_service.dart';

class GoogleMapView extends StatefulWidget {
  const GoogleMapView({super.key});

  @override
  State<GoogleMapView> createState() => _GoogleMapViewState();
}

class _GoogleMapViewState extends State<GoogleMapView> {
  late CameraPosition initialCameraPosition;
  late LocationService locationService;
  late GoogleMapController googleMapController;
  Set<Marker> markers = {};

  @override
  void initState() {
    initialCameraPosition = const CameraPosition(target: LatLng(0, 0));
    locationService = LocationService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      markers: markers,
      onMapCreated: (controller) {
        googleMapController = controller;
        updateCurrentLocation();
      },
      zoomControlsEnabled: false,
      initialCameraPosition: initialCameraPosition,
    );
  }

  void updateCurrentLocation() async {
    try {
      var locationData = await locationService.getLocation();

      LatLng currentPosition =
          LatLng(locationData.latitude!, locationData.longitude!);

      var currentLocationMarker = Marker(
        markerId: MarkerId('My Location'),
        position: currentPosition,
      );

      CameraPosition myCurrentCameraPosition = CameraPosition(
        target: currentPosition,
        zoom: 16,
      );
      markers.add(currentLocationMarker);

      setState(() {});
      googleMapController.animateCamera(
        CameraUpdate.newCameraPosition(myCurrentCameraPosition),
      );
    } on LocationServiceException catch (e) {
      // TODO
    }on LocationPermissionException catch (e) {
      // TODO
    }on Exception catch (e) {
      // TODO
    }
  }
}
