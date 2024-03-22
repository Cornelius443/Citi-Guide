import 'package:city_guide/admin/attractions/attraction_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/city.dart';
import '../../services/admin_service.dart';

class AttractionList extends StatefulWidget {
  final AdminData admin;
  const AttractionList({super.key, required this.admin});

  @override
  State<AttractionList> createState() => _AttractionListState();
}

class _AttractionListState extends State<AttractionList> {
  @override
  Widget build(BuildContext context) {
    final attractions = Provider.of<List<Attractions>?>(context);
    return attractions != null && attractions.isNotEmpty
        ? ListView.builder(
        shrinkWrap: true,
        itemCount: attractions.length,
        itemBuilder: (context, index){
         return AttractionTile(attractions: attractions[index], admin: widget.admin);
        }
    ) : const Center(
      child: Text(
        'No attractions added yet',
        style: TextStyle(fontSize: 18),
      ),
    );
  }
}
