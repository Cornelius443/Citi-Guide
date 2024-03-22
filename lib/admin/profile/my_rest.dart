import 'package:city_guide/admin/rest_list.dart';
import 'package:city_guide/models/city.dart';
import 'package:city_guide/services/admin_service.dart';
import 'package:city_guide/services/rest_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class MyRest extends StatefulWidget {
  final AdminData admin;
  const MyRest({super.key, required this.admin});

  @override
  State<MyRest> createState() => _MyRestState();
}

class _MyRestState extends State<MyRest> {
  RestaurantService restaurantService = RestaurantService();
  void showSnack(String msg){
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(msg)
        )
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
            "My Restaurants"
        ),
      ),
      body: StreamProvider<List<Restaurant>?>.value(
        value:  restaurantService.getRestByAdminId(widget.admin.aid!),
        catchError: (context, error) {
          // Handle the error gracefully.
          showSnack('Error fetching event data: $error');
          return null;
        },
        initialData: null,
        child: RestList(admin: widget.admin),
      ),
    );
  }
}
