import 'package:city_guide/models/user.dart';
import 'package:city_guide/screens/hotels/h_detail.dart';
import 'package:flutter/material.dart';
import '../../models/city.dart';
class HTile extends StatelessWidget {
  final Hotel hotel;
  final UserData user;
  const HTile({
    super.key,
    required this.user,
    required this.hotel
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
                  builder: (context) => HDetail(user: user, hotel: hotel)
              ),
            );
          },
          leading: CircleAvatar(
            backgroundColor: Colors.white,
            child: hotel.img.isNotEmpty
                ? ClipOval(
              child: Image.network(
                hotel.img,
                width: 40,
                height: 40,
                fit: BoxFit.cover,
              ),
            )
                : const Icon(Icons.location_city),
          ),
          title: Text(
              hotel.name!
          ),
          subtitle: const Text(
              "View Details"
          ),

        ),
      ),
    );
  }
}
