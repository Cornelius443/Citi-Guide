import 'package:city_guide/admin/event/event_detail.dart';
import 'package:city_guide/services/event_service.dart';
import 'package:flutter/material.dart';
import '../../models/city.dart';
import '../../services/admin_service.dart';

class EventTile extends StatelessWidget {
  final Event event;
  final AdminData admin;
  const EventTile({
    super.key,
    required this.event,
    required this.admin
  });

  @override
  Widget build(BuildContext context) {

    EventService eventService = EventService();
    return Padding(
      padding: const EdgeInsets.only(top: 9.0),
      child: Card(
        margin: const EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        child: ListTile(
          onTap: (){
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EventDetails(
                      name: event.name!,
                      eId: event.eId,
                      desc: event.desc,
                      location: event.location!,
                      cName: event.cName!,
                      email: event.email,
                      website: event.website,
                      admin: admin,
                      event: event,
                  )
              ),
            );
          },
          leading: const Icon(Icons.event),
          title: Text(
              event.name!
          ),
          subtitle: const Text(
              "View Details"
          ),
          trailing: IconButton(
            onPressed: (){
              eventService.deleteEvent(event.eId);
            },
            icon: const Icon(Icons.delete),
          ),
        ),
      ),
    );
  }
}
