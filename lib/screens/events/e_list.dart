import 'package:city_guide/models/user.dart';
import 'package:city_guide/screens/events/e_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/city.dart';
class EList extends StatefulWidget {
  final UserData user;
  const EList({super.key, required this.user});

  @override
  State<EList> createState() => _EListState();
}

class _EListState extends State<EList> {
  @override
  Widget build(BuildContext context) {
    final events = Provider.of<List<Event>?>(context);
    return events != null && events.isNotEmpty
        ? ListView.builder(
        shrinkWrap: true,
        itemCount: events.length,
        itemBuilder: (context, index){
          return ETile(user: widget.user, event: events[index]);
        }
    ) : const Center(
      child: Text(
        'No event available.',
        style: TextStyle(fontSize: 18),
      ),
    );
  }
}
