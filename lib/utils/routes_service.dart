import 'package:route_tracker_app/models/routes_model/routes_model.dart';

class RoutesService {

  final String baseUrl = 'https://routes.googleapis.com/directions/v2:computeRoutes';

  final String apiKey = 'AIzaSyCQuBDXocPVuelRzdiVtcLnwUHo-mqA2gE';

  Future<RoutesModel> fetchRoutes() {
    Uri url = Uri.parse(baseUrl);

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'X-Goog-Api-Key': apiKey,
      'X-Goog-FieldMask': 'routes.duration,routes.distanceMeters,routes.polyline.encodedPolyline'
    };
  }
}