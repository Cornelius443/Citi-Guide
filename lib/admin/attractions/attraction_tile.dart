import 'package:city_guide/admin/attractions/attraction_detail.dart';
import 'package:city_guide/services/attraction_service.dart';
import 'package:flutter/material.dart';
import '../../models/city.dart';
import '../../services/admin_service.dart';

class AttractionTile extends StatelessWidget {
  final Attractions attractions;
  final AdminData admin;
  const AttractionTile({
    super.key,
    required this.attractions,
    required this.admin
  });

  @override
  Widget build(BuildContext context) {

    AttractionService attractionService = AttractionService();
    return Padding(
      padding: const EdgeInsets.only(top: 9.0),
      child: Card(
        margin: const EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        child: ListTile(
          onTap: (){
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AttractionDetail(
                      name: attractions.name!,
                      aId: attractions.id,
                      location: attractions.location!,
                      cName: attractions.cName!,
                      contact: attractions.contact,
                      email: attractions.email,
                      website: attractions.website,
                      admin: admin,
                      attraction: attractions,
                      desc: attractions.desc
                  )
              ),
            );
          },
          leading: const Icon(Icons.attractions),
          title: Text(
              attractions.name!
          ),
          subtitle: const Text(
              "View Details"
          ),
          trailing: IconButton(
            onPressed: (){
              attractionService.deleteAttraction(attractions.id);
            },
            icon: const Icon(Icons.delete),
          ),
        ),
      ),
    );
  }
}
