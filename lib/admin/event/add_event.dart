import 'package:city_guide/services/event_service.dart';
import 'package:flutter/material.dart';
import '../../models/city.dart';
import '../../shared/constants.dart';

class AddEvent extends StatefulWidget {
  final String cName;
  final String aid;
  const AddEvent({
    super.key,
    required this.cName,
    required this.aid,
  });

  @override
  State<AddEvent> createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {

  EventService eventService = EventService();
  final _formKey = GlobalKey<FormState>();
  String? name;
  String? desc;
  String? location;
  String? email;
  String? website;
  bool loading = false;

  void showSnack(String msg){
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(msg)
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const Text(
              "Add new Event",
              style: TextStyle(
                  fontSize: 18.0
              ),
            ),
            const SizedBox(height: 20.0,),
            TextFormField(
              validator: (val) => val!.isEmpty ? 'Please enter event name' : null,
              decoration: addInputDecoration.copyWith(
                  hintText: "Event Name"
              ),
              cursorColor: Colors.black,
              onChanged: (val){
                setState(() {
                  name = val;
                });
              },
            ),
            const SizedBox(height: 20.0,),
            TextFormField(
              maxLines: null,
              keyboardType: TextInputType.multiline,
              decoration: addInputDecoration.copyWith(
                  hintText: "Description",
                  prefixIcon: const Icon(Icons.description)
              ),
              validator: (val) => val!.isEmpty ? 'Please enter description' : null,
              onChanged: (val){
                setState(() {
                  desc = val;
                });
              },
              cursorColor: Colors.black,
            ),
            const SizedBox(height: 20.0,),
            TextFormField(

              validator: (val) => val!.isEmpty ? 'Please enter location' : null,
              decoration: addInputDecoration.copyWith(
                hintText: "Location",
                prefixIcon: const Icon(Icons.location_city),

              ),
              cursorColor: Colors.black,
              onChanged: (val){
                setState(() {
                  location = val;
                });
              },
            ),
            const SizedBox(height: 20.0,),
            TextFormField(

              validator: (val) => val!.isEmpty ? 'Please enter email' : null,
              decoration: addInputDecoration.copyWith(
                hintText: "Email",
                prefixIcon: const Icon(Icons.email),

              ),
              cursorColor: Colors.black,
              onChanged: (val){
                setState(() {
                  email = val;
                });
              },
            ),
            const SizedBox(height: 20.0,),
            TextFormField(

              validator: (val) => val!.isEmpty ? 'Please enter website' : null,
              decoration: addInputDecoration.copyWith(
                hintText: "Website",
                prefixIcon: const Icon(Icons.web),

              ),
              cursorColor: Colors.black,
              onChanged: (val){
                setState(() {
                  website = val;
                });
              },
            ),
            const SizedBox(height: 20.0,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: loading ? const Text("Processing..") : ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black
                  ),
                  onPressed: ()async{
                    setState(() {
                      loading = true;
                    });
                    // Check if the form is valid
                    if (_formKey.currentState?.validate() ?? false){

                    final event = Event(
                      name: name,
                      aId: widget.aid,
                      cName: widget.cName,
                      desc: desc!,
                      location: location,
                      email: email!,
                      website: website!
                    );

                  await eventService.createEvent(event);
                     if(mounted){
                       Navigator.pop(context);
                       showSnack("New Event Added...");
                     }
                    }setState(() {
                      loading = false;
                    });
                  },
                  icon: const Icon(Icons.add, color: Colors.white,),
                  label: const Text(
                    "Add Event",
                    style: TextStyle(
                        color: Colors.white
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
