import 'package:city_guide/admin/event/event_list.dart';
import 'package:city_guide/services/admin_service.dart';
import 'package:city_guide/services/event_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/city.dart';
class MyEvents extends StatefulWidget {
  final AdminData admin;
  const MyEvents({super.key, required this.admin});

  @override
  State<MyEvents> createState() => _MyEventsState();
}

class _MyEventsState extends State<MyEvents> {
  EventService eventService = EventService();


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
          "My Events"
        ),
      ),

      body: StreamProvider<List<Event>?>.value(
        value: eventService.getEventByAdminId(widget.admin.aid!),
        catchError: (context, error) {
          // Handle the error gracefully.
         showSnack('Error fetching event data: $error');
          return null;
        },
        initialData: null,
        child: EventList(admin: widget.admin),
      ),
    );
  }
}








