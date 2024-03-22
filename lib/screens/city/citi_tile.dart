import 'package:city_guide/screens/city/citi_detail.dart';
import 'package:flutter/material.dart';
import '../../models/city.dart';
import '../../models/user.dart';

class CitiTile extends StatelessWidget {
  final City city;
  final UserData user;

  const CitiTile({
    super.key,
    required this.city,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 9.0),
      child: Card(
        margin: const EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        child: ListTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CitiDetail(
                    user: user,
                    city: city
                )
              ),
            );
          },
          leading: CircleAvatar(
            backgroundColor: Colors.white,
            child: city.cImg.isNotEmpty
                ? ClipOval(
              child: Image.network(
                city.cImg,
                width: 40,
                height: 40,
                fit: BoxFit.cover,
              ),
            )
                : const Icon(Icons.location_city),
          ),
          title: Text(city.cName!),
          subtitle: const Text("View Details"),
        ),
      ),
    );
  }
}
