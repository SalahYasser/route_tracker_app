import 'package:flutter/material.dart';
import 'package:route_tracker_app/models/place_autocomplete_model/place_autocomplete_model.dart';

class CustomListView extends StatelessWidget {
  const CustomListView({super.key, required this.places});

  final List<PlaceAutocompleteModel> places;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListView.separated(
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return ListTile(
              leading: Icon(Icons.pin_drop),
              title: Text(places[index].description!),
              trailing: IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.arrow_circle_right_outlined)),
            );
          },
          separatorBuilder: (context, index) {
            return const Divider(height: 0);
          },
          itemCount: places.length),
    );
  }
}
