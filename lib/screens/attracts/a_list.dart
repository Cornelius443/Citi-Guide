import 'package:city_guide/screens/attracts/a_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/city.dart';
import '../../models/user.dart';
class AList extends StatefulWidget {
  final UserData user;
  const AList({super.key, required this.user});

  @override
  State<AList> createState() => _AListState();
}

class _AListState extends State<AList> {
  @override
  Widget build(BuildContext context) {
    final attractions = Provider.of<List<Attractions>?>(context);
    return attractions != null && attractions.isNotEmpty
        ? ListView.builder(
        shrinkWrap: true,
        itemCount: attractions.length,
        itemBuilder: (context, index){
          return ATile(user: widget.user, attractions: attractions[index]);
        }
    ) : const Center(
      child: Text(
        'No attraction available.',
        style: TextStyle(fontSize: 18),
      ),
    );
  }
}
