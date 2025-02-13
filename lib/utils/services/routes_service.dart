import 'dart:convert';
import 'package:route_tracker_app/api_Keys.dart';
import 'package:route_tracker_app/models/routes_body_model/routes_body_model.dart';
import 'package:route_tracker_app/models/routes_model/routes_model.dart';
import 'package:http/http.dart' as http;

class RoutesService {
  final String baseUrl = ApiKeys.baseUrlRoutes;

  final String apiKey = ApiKeys.apiKeyRouts;

  Future<RoutesInfoModel> fetchRoutes(RoutesBodyModel routesBodyModel) async {
    Uri url = Uri.parse(baseUrl);

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'X-Goog-Api-Key': apiKey,
      'X-Goog-FieldMask':
          'routes.duration,routes.distanceMeters,routes.polyline.encodedPolyline'
    };

    Map<String, dynamic> body = {
      "origin": routesBodyModel.origin,
      "destination": routesBodyModel.destination,
      "travelMode": routesBodyModel.travelMode,
      "routingPreference": routesBodyModel.routingPreference,
      "computeAlternativeRoutes": routesBodyModel.computeAlternativeRoutes,
      "routeModifiers": routesBodyModel.routeModifiers,
      "languageCode": routesBodyModel.languageCode,
      "units": routesBodyModel.units,
    };

    var response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      return RoutesInfoModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('No Routes Found');
    }
  }
}
