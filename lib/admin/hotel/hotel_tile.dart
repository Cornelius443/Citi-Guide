import 'package:city_guide/admin/hotel/hotel_detail.dart';
import 'package:city_guide/services/hotel_service.dart';
import 'package:flutter/material.dart';
import '../../models/city.dart';
import '../../services/admin_service.dart';
class HotelTile extends StatelessWidget {
  final Hotel hotel;
  final AdminData admin;
  const HotelTile({
    super.key,
    required this.hotel,
    required this.admin
  });

  @override
  Widget build(BuildContext context) {

    HotelService hotelService = HotelService();
    return Padding(
      padding: const EdgeInsets.only(top: 9.0),
      child: Card(
        margin: const EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        child: ListTile(
          onTap: (){
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HotelDetail(
                    hName: hotel.name!,
                    cName: hotel.cName!,
                    location: hotel.location!,
                    contact: hotel.contact,
                    email: hotel.email,
                    website: hotel.website,
                    hId: hotel.hId,
                    desc: hotel.desc,
                    admin: admin,
                hotel: hotel,)
              ),
            );
          },
          leading: const Icon(Icons.hotel),
          title: Text(
              hotel.name!
          ),
          subtitle: const Text(
              "View Details"
          ),
          trailing: IconButton(
            onPressed: (){
              hotelService.deleteHotel(hotel.hId);
            },
            icon: const Icon(Icons.delete),
          ),
        ),
      ),
    );
  }
}
