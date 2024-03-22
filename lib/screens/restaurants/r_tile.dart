import 'package:city_guide/models/user.dart';
import 'package:city_guide/screens/restaurants/r_detail.dart';
import 'package:flutter/material.dart';
import '../../models/city.dart';

class RTile extends StatelessWidget {
  final Restaurant restaurant;
  final UserData user;
  const RTile({
    super.key,
    required this.user,
    required this.restaurant
  });

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.only(top: 9.0),
      child: Card(
        margin: const EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        child: ListTile(
          onTap: (){
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    RDetail(
                    user: user,
                    restaurant: restaurant
                    )
              ),
            );
          },
          leading: CircleAvatar(
            backgroundColor: Colors.white,
            child: restaurant.rImg.isNotEmpty
                ? ClipOval(
              child: Image.network(
                restaurant.rImg,
                width: 40,
                height: 40,
                fit: BoxFit.cover,
              ),
            )
                : const Icon(Icons.location_city),
          ),
          title: Text(
              restaurant.rName!
          ),
          subtitle: const Text(
              "View Details"
          ),

        ),
      ),
    );
  }
}
