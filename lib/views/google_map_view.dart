import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:route_tracker_app/models/place_autocomplete_model/place_autocomplete_model.dart';
import 'package:route_tracker_app/models/routes_model/routes_model.dart';
import 'package:route_tracker_app/utils/services/location_service.dart';
import 'package:route_tracker_app/utils/services/map_services.dart';
import 'package:route_tracker_app/widgets/custom_list_view.dart';
import 'package:route_tracker_app/widgets/custom_text_field.dart';
import 'package:route_tracker_app/widgets/floating_action_button.dart';
import 'package:route_tracker_app/widgets/route_details_info.dart';
import 'package:uuid/uuid.dart';

class GoogleMapView extends StatefulWidget {
  const GoogleMapView({super.key});

  @override
  State<GoogleMapView> createState() => _GoogleMapViewState();
}

class _GoogleMapViewState extends State<GoogleMapView> {
  late CameraPosition initialCameraPosition;
  late GoogleMapController googleMapController;
  late TextEditingController textEditingController;
  late Uuid uuid;
  late MapServices mapServices;
  late LatLng destinationLocation;
  late RoutesInfoModel routesInfoModel;

  Timer? debounce;
  String? sessionToken;

  Set<Marker> markers = {};
  Set<Polyline> polylines = {};
  List<PlaceModel> places = [];

  @override
  void initState() {
    initialCameraPosition = const CameraPosition(target: LatLng(0, 0));
    textEditingController = TextEditingController();
    uuid = const Uuid();
    mapServices = MapServices();
    routesInfoModel = RoutesInfoModel();

    fetchPredictions();
    super.initState();
  }

  void fetchPredictions() {
    textEditingController.addListener(() async {
      if (debounce?.isActive ?? false) {
        debounce?.cancel();
      }

      debounce = Timer(Duration(milliseconds: 100), () async {
        sessionToken ??= uuid.v4();
        await mapServices.getPredictions(
            input: textEditingController.text,
            sessionToken: sessionToken!,
            places: places);
        setState(() {});
      });
    });
  }

  @override
  void dispose() {
    textEditingController.dispose();
    debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: [
            GoogleMap(
              polylines: polylines,
              markers: markers,
              onMapCreated: (controller) {
                googleMapController = controller;
                updateCurrentLocation();
              },
              zoomControlsEnabled: false,
              mapType: MapType.hybrid,
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
                    onPlaceSelect: onPlaceSelect,
                  ),
                  const SizedBox(height: 16),
                  CustomListView(
                    onPlaceSelect: (placeDetailsModel) async {
                      onPlaceSelect();

                      destinationLocation = LatLng(
                        placeDetailsModel.geometry!.location!.lat!,
                        placeDetailsModel.geometry!.location!.lng!,
                      );

                      var points = await mapServices.getRouteData(
                          destinationLocation: destinationLocation,
                          routes: routesInfoModel.routes!
                      );

                      mapServices.displayRoute(points,
                          polylines: polylines,
                          googleMapController: googleMapController);
                      setState(() {});
                    },
                    places: places,
                    mapServices: mapServices,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      bottomSheet: routesInfoModel.routes == null
          ? null
          : RouteDetailsInfo(
        duration: routesInfoModel.routes!.first.duration!,
        distanceMeters: routesInfoModel.routes!.first.distanceMeters!,
        cancelRouteFun: () {
          polylines = {};
          routesInfoModel.routes = null;
          setState(() {});
          updateCurrentLocation();
        },
        startRouteFun: () {
          updateCurrentLocation();
          setState(() {});
        },
      ),
      floatingActionButton: routesInfoModel.routes == null
          ? FloatingActionButtonWidget(
        getCurrentLocationFun: () {
          updateCurrentLocation();
        },
      )
          : null,
    );
  }

  void onPlaceSelect() {
    FocusManager.instance.primaryFocus?.unfocus();
    textEditingController.clear();
    places.clear();
    sessionToken = null;
    setState(() {});
  }

  void updateCurrentLocation() {
    try {
      mapServices.updateCurrentLocation(
        googleMapController: googleMapController,
        markers: markers,
        onUpdateCurrentLocation: () {
          setState(() {});
        });

    } on LocationServiceException catch (e) {
      // TODO:
    } on LocationPermissionException catch (e) {
      // TODO:
    } catch (e) {
      throw Exception();
    }
  }
}