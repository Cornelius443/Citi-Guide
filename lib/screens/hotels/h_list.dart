import 'package:city_guide/models/user.dart';
import 'package:city_guide/screens/hotels/h_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/city.dart';
class HList extends StatefulWidget {
  final UserData user;
  const HList({super.key, required this.user});

  @override
  State<HList> createState() => _HListState();
}

class _HListState extends State<HList> {
  @override
  Widget build(BuildContext context) {
    final hotels = Provider.of<List<Hotel>?>(context);
    return hotels != null && hotels.isNotEmpty
        ? ListView.builder(
        shrinkWrap: true,
        itemCount: hotels.length,
        itemBuilder: (context, index){
          return HTile(user: widget.user, hotel: hotels[index]);
        }
    ) : const Center(
      child: Text(
        'No hotel available',
        style: TextStyle(fontSize: 18),
      ),
    );
  }
}
