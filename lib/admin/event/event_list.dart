import 'package:city_guide/admin/event/event_tile.dart';
import '../../models/city.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/admin_service.dart';
class EventList extends StatefulWidget {
  final AdminData admin;
  const EventList({super.key, required this.admin});

  @override
  State<EventList> createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  @override
  Widget build(BuildContext context) {
    final events = Provider.of<List<Event>?>(context);
    return events != null && events.isNotEmpty
        ? ListView.builder(
        shrinkWrap: true,
        itemCount: events.length,
        itemBuilder: (context, index){
          return EventTile(event: events[index], admin: widget.admin);
        }
    ) : const Center(
      child: Text(
        'No events added yet',
        style: TextStyle(fontSize: 18),
      ),
    );
  }
}
