import 'package:city_guide/admin/city_tile.dart';
import 'package:city_guide/services/admin_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/city.dart';
class CityList extends StatefulWidget {
  final AdminData admin;
  const CityList({super.key, required this.admin});

  @override
  State<CityList> createState() => _CityListState();
}

class _CityListState extends State<CityList> {

  @override
  Widget build(BuildContext context) {
    final cities = Provider.of<List<City>?>(context);

    return cities != null && cities.isNotEmpty
        ? ListView.builder(
        shrinkWrap: true,
        itemCount: cities.length,
        itemBuilder: (context, index){
          return CityTile(city: cities[index], admin: widget.admin);
        }
    ) : const Center(
      child: Text(
        'No hotel available. Click + to add',
        style: TextStyle(fontSize: 18),
      ),
    );
  }
}
