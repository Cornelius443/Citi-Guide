import 'package:city_guide/admin/city_desc.dart';
import 'package:city_guide/services/admin_service.dart';
import 'package:city_guide/services/city_service.dart';
import 'package:flutter/material.dart';
import '../models/city.dart';


class CityTile extends StatelessWidget {
  final City city;
  final AdminData admin;
  const CityTile({super.key, required this.city, required this.admin});

  @override
  Widget build(BuildContext context) {
    CityService cityService = CityService();

    return Padding(
      padding: const EdgeInsets.only(top: 9.0),
      child: Card(
        margin: const EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        child: ListTile(
          onTap: (){
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CityDetail(
                    cityName: city.cName!,
                    cid: city.cid!,
                    desc: city.desc,
                    location: city.cLocation!,
                    admin: admin,
                    city: city,
                ),
              ),
            );
          },
          leading: const Icon(Icons.location_city),
          title: Text(
            city.cName!
          ),
          subtitle: const Text(
            "View Details"
          ),
          trailing: IconButton(
            onPressed: (){
              cityService.deleteCity(city.cid!);
              },
            icon: const Icon(Icons.delete),
          ),
        ),
      ),
    );
  }
}
