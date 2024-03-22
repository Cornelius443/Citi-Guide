import 'package:city_guide/admin/restaurant_detail.dart';
import 'package:city_guide/models/city.dart';
import 'package:city_guide/services/admin_service.dart';
import 'package:city_guide/services/rest_service.dart';
import 'package:flutter/material.dart';


class RestTile extends StatelessWidget {
  final Restaurant restaurant;
  final AdminData admin;
  const RestTile({
    super.key,
    required this.restaurant,
    required this.admin
  });

  @override
  Widget build(BuildContext context) {
    RestaurantService restaurantService = RestaurantService();
    return Padding(
      padding: const EdgeInsets.only(top: 9.0),
      child: Card(
        margin: const EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        child: ListTile(
          onTap: (){
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RestDetail(
                rName: restaurant.rName!,
                  cName: restaurant.cName!,
                  location: restaurant.rLocation!,
                  contact: restaurant.contact,
                  email: restaurant.email,
                  website: restaurant.website,
                  rId: restaurant.rId!,
                  desc: restaurant.desc,
                  admin: admin,
                  restaurant: restaurant,
                ),
              ),
            );
          },
          leading: const Icon(Icons.restaurant),
          title: Text(
             restaurant.rName!
          ),
          subtitle: const Text(
              "View Details"
          ),
          trailing: IconButton(
            onPressed: (){
              restaurantService.deleteRest(restaurant.rId!);
            },
            icon: const Icon(Icons.delete),
          ),
        ),
      ),
    );
  }
}
