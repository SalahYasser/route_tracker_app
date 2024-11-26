import 'package:route_tracker_app/models/routes_model/routes_model.dart';

class RoutesService {

  final String baseUrl = 'https://routes.googleapis.com/directions/v2:computeRoutes';

  final String apiKey = 'AIzaSyCQuBDXocPVuelRzdiVtcLnwUHo-mqA2gE';

  Future<RoutesModel> fetchRoutes() {
  }
}