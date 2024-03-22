import 'package:city_guide/admin/hotel/hotel_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/city.dart';
import '../../services/admin_service.dart';
class HotelList extends StatefulWidget {
  final AdminData admin;
  const HotelList({super.key, required this.admin});

  @override
  State<HotelList> createState() => _HotelListState();
}

class _HotelListState extends State<HotelList> {
  @override
  Widget build(BuildContext context) {
    final hotels = Provider.of<List<Hotel>?>(context);
    return hotels != null && hotels.isNotEmpty
        ? ListView.builder(
      shrinkWrap: true,
      itemCount: hotels.length,
        itemBuilder: (context, index){
        return HotelTile(hotel: hotels[index], admin: widget.admin,);
        }
    ) : const Center(
      child: Text(
        'No hotels added yet',
        style: TextStyle(fontSize: 18),
      ),
    );
  }
}
