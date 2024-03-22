import 'package:city_guide/admin/attractions/attraction_list.dart';
import 'package:city_guide/models/city.dart';
import 'package:city_guide/services/admin_service.dart';
import 'package:city_guide/services/attraction_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class MyAttract extends StatefulWidget {
  final AdminData admin;
  const MyAttract({super.key, required this.admin});

  @override
  State<MyAttract> createState() => _MyAttractState();
}

class _MyAttractState extends State<MyAttract> {
  AttractionService attractionService = AttractionService();
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
            "My Attractions"
        ),
      ),
      body: StreamProvider<List<Attractions>?>.value(
        value: attractionService.getAttractionsByAdminId(widget.admin.aid!),
        catchError: (context, error) {
          // Handle the error gracefully.
          showSnack('Error fetching event data: $error');
          return null;
        },
        initialData: null,
        child: AttractionList(admin: widget.admin),
      ),
    );
  }
}
