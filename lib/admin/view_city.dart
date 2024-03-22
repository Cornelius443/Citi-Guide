import 'package:city_guide/services/admin_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/city.dart';
import '../services/city_service.dart';
import 'add_city.dart';
import 'city_list.dart';
class ViewCity extends StatefulWidget {
  final AdminData admin;
  const ViewCity({super.key, required this.admin});

  @override
  State<ViewCity> createState() => _ViewCityState();
}

class _ViewCityState extends State<ViewCity> {


  void showAddPanel() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            color: Colors.grey[200],
          ),
          padding: EdgeInsets.only(
            top: 16,
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: AddCity(aid: widget.admin.aid!), // Removed unnecessary null check
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cities"),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {
          showAddPanel();
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: StreamProvider<List<City>?>.value(
        value: CityService().getCitiesByAdminId(widget.admin.aid!).map((cities) {
          // Create a Set to store unique city names
          final uniqueCityNames = <String>{};
          // Filter out duplicate cities by checking the city name
          final uniqueCities = cities.where((city) => uniqueCityNames.add(city.cName!)).toList();
          return uniqueCities;
        }),
        catchError: (context, error) {
          // Handle the error gracefully.
          print('Error fetching city data: $error');
          return null;
        },
        initialData: null,
        child: CityList(admin: widget.admin),
      ),
    );
  }
}
