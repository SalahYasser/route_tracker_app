import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:route_tracker_app/models/place_autocomplete_model/place_autocomplete_model.dart';
import 'package:route_tracker_app/models/routes_body_model/destination.dart';
import 'package:route_tracker_app/models/routes_body_model/lat_lng.dart';
import 'package:route_tracker_app/models/routes_body_model/location.dart';
import 'package:route_tracker_app/models/routes_body_model/origin.dart';
import 'package:route_tracker_app/models/routes_body_model/routes_body_model.dart';
import 'package:route_tracker_app/models/routes_model/route.dart';
import 'package:route_tracker_app/models/routes_model/routes_model.dart';
import 'package:route_tracker_app/utils/google_maps_place_service.dart';
import 'package:route_tracker_app/utils/location_service.dart';
import 'package:route_tracker_app/utils/routes_service.dart';
import 'package:route_tracker_app/widgets/custom_list_view.dart';
import 'package:route_tracker_app/widgets/custom_text_field.dart';
import 'package:uuid/uuid.dart';

class GoogleMapView extends StatefulWidget {
  const GoogleMapView({super.key});

  @override
  State<GoogleMapView> createState() => _GoogleMapViewState();
}

class _GoogleMapViewState extends State<GoogleMapView> {
  late CameraPosition initialCameraPosition;
  late LocationService locationService;
  late GoogleMapController googleMapController;
  late TextEditingController textEditingController;
  late GoogleMapsPlacesService googleMapsPlaceService;
  late Uuid uuid;
  late RoutesService routesService;
  late LatLng currentLocation;
  late LatLng destinationLocation;

  String? sessionToken;

  Set<Marker> markers = {};
  List<PlaceModel> places = [];

  @override
  void initState() {
    initialCameraPosition = const CameraPosition(target: LatLng(0, 0));
    locationService = LocationService();
    textEditingController = TextEditingController();
    googleMapsPlaceService = GoogleMapsPlacesService();
    uuid = const Uuid();
    routesService = RoutesService();

    fetchPredictions();
    super.initState();
  }

  void fetchPredictions() {
    textEditingController.addListener(() async {
      sessionToken ??= uuid.v4();

      if (textEditingController.text.isNotEmpty) {
        var result = await googleMapsPlaceService.getPredictions(
            sessionToken: sessionToken!, input: textEditingController.text);

        places.clear();
        places.addAll(result);
        setState(() {});
      } else {
        places.clear();
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          markers: markers,
          onMapCreated: (controller) {
            googleMapController = controller;
            updateCurrentLocation();
          },
          zoomControlsEnabled: false,
          initialCameraPosition: initialCameraPosition,
        ),
        Positioned(
          top: 16,
          left: 16,
          right: 16,
          child: Column(
            children: [
              CustomTextField(
                textEditingController: textEditingController,
              ),
              const SizedBox(height: 16),
              CustomListView(
                onPlaceSelect: (placeDetailsModel) {
                  textEditingController.clear();
                  places.clear();

                  sessionToken = null;
                  setState(() {});

                  destinationLocation = LatLng(
                    placeDetailsModel.geometry!.location!.lat!,
                    placeDetailsModel.geometry!.location!.lng!,
                  );

                  getRouteData();
                },
                places: places,
                googleMapsPlacesService: googleMapsPlaceService,
              )
            ],
          ),
        ),
      ],
    );
  }

  void updateCurrentLocation() async {
    try {
      var locationData = await locationService.getLocation();

      currentLocation = LatLng(locationData.latitude!, locationData.longitude!);

      Marker currentLocationMarker = Marker(
        markerId: const MarkerId('my location'),
        position: currentLocation,
      );

      CameraPosition myCurrentCameraPosition = CameraPosition(
        target: currentLocation,
        zoom: 17,
      );

      googleMapController.animateCamera(
          CameraUpdate.newCameraPosition(myCurrentCameraPosition));
      markers.add(currentLocationMarker);
      setState(() {});
      // } on LocationServiceException catch (e) {
      //   TODO:
      // } on LocationPermissionException catch (e) {
      //   TODO:
    } catch (e) {
      // TODO:
    }
  }

  Future<List<LatLng>> getRouteData() async {
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

    List<LatLng> points = getDecodedRoute(routes);

    return points;
  }

  List<LatLng> getDecodedRoute(RoutesInfoModel routes) {
    PolylinePoints polylinePoints = PolylinePoints();

    List<PointLatLng> result = polylinePoints.decodePolyline(
      routes.routes!.first.polyline!.encodedPolyline!,
    );

    List<LatLng> points = result.map((e) => LatLng(e.latitude, e.longitude)).toList();
    return points;
  }
}
