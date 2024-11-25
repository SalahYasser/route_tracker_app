import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:route_tracker_app/models/place_autocomplete_model/place_autocomplete_model.dart';

class GoogleMapsPlaceService {

  final String baseUrl = 'https://maps.googleapis.com/maps/api/place';
  final String apiKey = 'AIzaSyC87Tt3tfO6aYids0BZStXXbrdAy05jQCI';

  Future<List<PlaceModel>> getPrediction({required String input}) async {

    var response = await http.get(Uri.parse('$baseUrl/autocomplete/json?key=$apiKey&input=$input'));

    if (response.statusCode == 200){
      var data = jsonDecode(response.body)['prediction'];
      List<PlaceModel> places = [];

      for (var item in data) {
        places.add(PlaceModel.fromJson(item));
      }
      return places;
    } else {
      throw Exception();
    }
  }
}