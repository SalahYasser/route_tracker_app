import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:route_tracker_app/api_Keys.dart';
import 'package:route_tracker_app/models/place_autocomplete_model/place_autocomplete_model.dart';
import 'package:route_tracker_app/models/place_details_model/place_details_model.dart';

class PlacesService {
  final String baseUrl = ApiKeys.baseUrlPlace;
  final String apiKey = ApiKeys.apiKeyPlace;

  Future<List<PlaceModel>> getPredictions(
      {required String input, required String sessionToken}) async {

    var response = await http.get(Uri.parse(
        '$baseUrl/autocomplete/json?key=$apiKey&input=$input&sessiontoken=$sessionToken'));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['predictions'];
      List<PlaceModel> places = [];

      for (var item in data) {
        places.add(PlaceModel.fromJson(item));
      }
      return places;
    } else {
      throw Exception();
    }
  }

  Future<PlaceDetailsModel> getPlaceDetails({required String placeId}) async {
    var response = await http.get(Uri.parse('$baseUrl/details/json?key=$apiKey&place_id=$placeId'));

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);

      if (jsonResponse['result'] != null) {
        var data = jsonResponse['result'];
        return PlaceDetailsModel.fromJson(data);
      } else {
        throw Exception('No results found in the response');
      }
    } else {
      throw Exception('Failed to load data: ${response.statusCode}');
    }
  }
}