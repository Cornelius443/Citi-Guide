import 'package:city_guide/models/user.dart';
import 'package:city_guide/screens/city/citi_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/city.dart';
class CitiList extends StatefulWidget {
  final UserData user;
  const CitiList({super.key, required this.user});

  @override
  State<CitiList> createState() => _CitiListState();
}

class _CitiListState extends State<CitiList> {
  @override
  Widget build(BuildContext context) {
    final cities = Provider.of<List<City>?>(context);
    return cities != null && cities.isNotEmpty
        ? ListView.builder(
        shrinkWrap: true,
        itemCount: cities.length,
        itemBuilder: (context, index){
          return CitiTile(city: cities[index], user: widget.user);
        }
    ) : const Center(
      child: Text(
        'No City available',
        style: TextStyle(fontSize: 18),
      ),
    );
  }
}
