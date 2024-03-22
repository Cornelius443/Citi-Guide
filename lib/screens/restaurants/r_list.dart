import 'package:city_guide/screens/restaurants/r_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/city.dart';
import '../../models/user.dart';
class RList extends StatefulWidget {
  final UserData user;
  const RList({super.key, required this.user});

  @override
  State<RList> createState() => _RListState();
}

class _RListState extends State<RList> {

  @override
  Widget build(BuildContext context) {
    final restaurants = Provider.of<List<Restaurant>?>(context);
    return restaurants != null && restaurants.isNotEmpty
        ? ListView.builder(
      shrinkWrap: true,
      itemCount: restaurants.length,
      itemBuilder: (context, index) {
        return RTile(user: widget.user, restaurant: restaurants[index]);
      },
    )
        : const Center(
      child: Text(
        'No restaurant available',
        style: TextStyle(fontSize: 18),
      ),
    );
  }
}
