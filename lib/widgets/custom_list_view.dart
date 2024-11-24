import 'package:flutter/material.dart';
import 'package:route_tracker_app/models/place_autocomplete_model/place_autocomplete_model.dart';

class CustomListView extends StatelessWidget {
  const CustomListView({super.key, required this.places});

  final List<PlaceAutocompleteModel> places;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Text(places[index].description!);
        },
        separatorBuilder: (context, index) {
          return Divider();
        },
        itemCount: places.length);
  }
}
