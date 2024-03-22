import 'package:city_guide/admin/hotel/hotel_list.dart';
import 'package:city_guide/services/admin_service.dart';
import 'package:city_guide/services/hotel_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/city.dart';
class MyHotels extends StatefulWidget {
  final AdminData admin;
  const MyHotels({super.key, required this.admin});

  @override
  State<MyHotels> createState() => _MyHotelsState();
}

class _MyHotelsState extends State<MyHotels> {
  HotelService hotelService = HotelService();
  void showSnack(String msg){
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(msg)
        )
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
            "My Hotels"
        ),
      ),
      body: StreamProvider<List<Hotel>?>.value(
        value: hotelService.getHotelByAdminId(widget.admin.aid!),
        catchError: (context, error) {
          // Handle the error gracefully.
          showSnack('Error fetching event data: $error');
          return null;
        },
        initialData: null,
        child: HotelList(admin: widget.admin),
      ),
    );
  }
}
