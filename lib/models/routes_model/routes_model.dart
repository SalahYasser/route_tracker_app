import 'route.dart';

class RoutesInfoModel {
  List<RouteModel>? routes;

  RoutesInfoModel({this.routes});

  factory RoutesInfoModel.fromJson(Map<String, dynamic> json) => RoutesInfoModel(
        routes: (json['routes'] as List<dynamic>?)
            ?.map((e) => RouteModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'routes': routes?.map((e) => e.toJson()).toList(),
      };
}
