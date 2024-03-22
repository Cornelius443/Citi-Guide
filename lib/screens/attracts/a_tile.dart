import 'package:city_guide/screens/attracts/a_detail.dart';
import 'package:flutter/material.dart';
import '../../models/city.dart';
import '../../models/user.dart';
class ATile extends StatelessWidget {
  final Attractions attractions;
  final UserData user;
  const ATile({
    super.key,
    required this.user,
    required this.attractions
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
                  builder: (context) => ADetail(
                      user: user,
                      attractions: attractions
                  )
              ),
            );
          },
          leading: CircleAvatar(
            backgroundColor: Colors.white,
            child: attractions.img.isNotEmpty
                ? ClipOval(
              child: Image.network(
                attractions.img,
                width: 40,
                height: 40,
                fit: BoxFit.cover,
              ),
            )
                : const Icon(Icons.location_city),
          ),
          title: Text(
              attractions.name!
          ),
          subtitle: const Text(
              "View Details"
          ),

        ),
      ),
    );
  }
}
