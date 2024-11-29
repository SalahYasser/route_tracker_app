import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:route_tracker_app/models/place_autocomplete_model/place_autocomplete_model.dart';
import 'package:route_tracker_app/models/place_details_model/place_details_model.dart';
import 'package:route_tracker_app/models/routes_body_model/destination.dart';
import 'package:route_tracker_app/models/routes_body_model/lat_lng.dart';
import 'package:route_tracker_app/models/routes_body_model/location.dart';
import 'package:route_tracker_app/models/routes_body_model/origin.dart';
import 'package:route_tracker_app/models/routes_body_model/routes_body_model.dart';
import 'package:route_tracker_app/models/routes_model/routes_model.dart';
import 'package:route_tracker_app/utils/location_service.dart';
import 'package:route_tracker_app/utils/place_service.dart';
import 'package:route_tracker_app/utils/routes_service.dart';

class MapServices {
  PlacesService placeService = PlacesService();

  LocationService locationService = LocationService();

  RoutesService routesService = RoutesService();

  Future<void> getPredictions(
      {required String input,
      required String sessionToken,
      required List<PlaceModel> places}) async {
    if (input.isNotEmpty) {
      var result = await placeService.getPredictions(
          sessionToken: sessionToken, input: input);

      places.clear();
      places.addAll(result);
    } else {
      places.clear();
    }
  }

  Future<List<LatLng>> getRouteData(
      {required LatLng currentLocation,
      required LatLng destinationLocation}) async {
    Origin origin = Origin(
      location: LocationModel(
        latLng: LatLngModel(
            latitude: currentLocation.latitude,
            longitude: currentLocation.longitude),
      ),
    );

    Destination destination = Destination(
      location: LocationModel(
        latLng: LatLngModel(
            latitude: destinationLocation.latitude,
            longitude: destinationLocation.longitude),
      ),
    );

    RoutesInfoModel routes = await routesService.fetchRoutes(
      RoutesBodyModel(origin: origin, destination: destination),
    );

    PolylinePoints polylinePoints = PolylinePoints();
    List<LatLng> points = getDecodedRoute(polylinePoints, routes);
    return points;
  }

  List<LatLng> getDecodedRoute(
      PolylinePoints polylinePoints, RoutesInfoModel routes) {
    List<PointLatLng> result = polylinePoints.decodePolyline(
      routes.routes!.first.polyline!.encodedPolyline!,
    );

    List<LatLng> points =
        result.map((e) => LatLng(e.latitude, e.longitude)).toList();
    return points;
  }

  void displayRoute(List<LatLng> points,
      {required Set<Polyline> polylines,
      required GoogleMapController googleMapController}) {
    Polyline route = Polyline(
      color: Colors.blue,
      width: 5,
      polylineId: PolylineId('route'),
      points: points,
    );
    polylines.add(route);

    LatLngBounds bounds = getLatLngBounds(points);

    googleMapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 32));
  }

  LatLngBounds getLatLngBounds(List<LatLng> points) {
    var southwestLatitude = points.first.latitude;
    var southwestLongitude = points.first.longitude;
    var northeastLatitude = points.first.latitude;
    var northeastLongitude = points.first.longitude;

    for (var point in points) {
      southwestLatitude = min(southwestLatitude, point.latitude);
      southwestLongitude = min(southwestLongitude, point.longitude);
      northeastLatitude = max(northeastLatitude, point.latitude);
      northeastLongitude = max(northeastLongitude, point.longitude);
    }
    return LatLngBounds(
      southwest: LatLng(southwestLatitude, southwestLongitude),
      northeast: LatLng(northeastLatitude, northeastLongitude),
    );
  }

  Future<LatLng> updateCurrentLocation(
      {required GoogleMapController googleMapController,
      required Set<Marker> markers}) async {
    var locationData = await locationService.getLocation();

    var currentLocation =
        LatLng(locationData.latitude!, locationData.longitude!);

    Marker currentLocationMarker = Marker(
      markerId: const MarkerId('my location'),
      position: currentLocation,
    );

    CameraPosition myCurrentCameraPosition = CameraPosition(
      target: currentLocation,
      zoom: 17,
    );

    googleMapController
        .animateCamera(CameraUpdate.newCameraPosition(myCurrentCameraPosition));
    markers.add(currentLocationMarker);

    return currentLocation;
  }

  Future<PlaceDetailsModel> getPlaceDetails({required String placeId}) async {
    return await placeService.getPlaceDetails(placeId: placeId);
  }
}
