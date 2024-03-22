import 'package:city_guide/screens/events/e_detail.dart';

import '../../models/city.dart';
import 'package:city_guide/models/user.dart';
import 'package:flutter/material.dart';
class ETile extends StatelessWidget {
  final Event event;
  final UserData user;
  const ETile({super.key, required this.user, required this.event});

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
                  builder: (context) => EDetail(event: event, user: user)
              ),
            );
          },
          leading: CircleAvatar(
            backgroundColor: Colors.white,
            child: event.img.isNotEmpty
                ? ClipOval(
              child: Image.network(
                event.img,
                width: 40,
                height: 40,
                fit: BoxFit.cover,
              ),
            )
                : const Icon(Icons.location_city),
          ),
          title: Text(
              event.name!
          ),
          subtitle: const Text(
              "View Details"
          ),

        ),
      ),
    );
  }
}
