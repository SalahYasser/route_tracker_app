import 'package:route_tracker_app/models/place_autocomplete_model/place_autocomplete_model.dart';
import 'package:route_tracker_app/utils/location_service.dart';
import 'package:route_tracker_app/utils/place_service.dart';
import 'package:route_tracker_app/utils/routes_service.dart';

class MapServices {
  PlacesService placeService = PlacesService();

  LocationService locationService = LocationService();

  RoutesService routesService = RoutesService();

  getPredictions(
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
}
