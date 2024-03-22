import 'package:city_guide/admin/rest_tile.dart';
import 'package:city_guide/models/city.dart';
import 'package:city_guide/services/admin_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class RestList extends StatefulWidget {
  final AdminData admin;
  const RestList({super.key, required this.admin});

  @override
  State<RestList> createState() => _RestListState();
}

class _RestListState extends State<RestList> {
  @override
  Widget build(BuildContext context) {
    final restaurants = Provider.of<List<Restaurant>?>(context);

    return restaurants != null && restaurants.isNotEmpty
        ? ListView.builder(
      shrinkWrap: true,
      itemCount: restaurants.length,
      itemBuilder: (context, index) {
        return RestTile(restaurant: restaurants[index], admin: widget.admin,);
      },
    )
        : const Center(
      child: Text(
        'No restaurants added yet',
        style: TextStyle(fontSize: 18),
      ),
    );
  }
}

