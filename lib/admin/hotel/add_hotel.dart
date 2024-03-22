import 'package:city_guide/services/hotel_service.dart';
import 'package:flutter/material.dart';

import '../../models/city.dart';
import '../../shared/constants.dart';
class AddHotel extends StatefulWidget {
  final String cName;
  final String aid;
  const AddHotel({
    super.key,
    required this.cName,
    required this.aid
  });

  @override
  State<AddHotel> createState() => _AddHotelState();
}

class _AddHotelState extends State<AddHotel> {
  HotelService hotelService = HotelService();
  final _formKey = GlobalKey<FormState>();
  String? hName;
  String? desc;
  String? hLocation;
  String? contact;
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
              "Add new hotel",
              style: TextStyle(
                  fontSize: 18.0
              ),
            ),
            const SizedBox(height: 20.0,),
            TextFormField(
              validator: (val) => val!.isEmpty ? 'Please enter a name' : null,
              decoration: addInputDecoration.copyWith(
                  hintText: "Name"
              ),
              cursorColor: Colors.black,
              onChanged: (val){
                setState(() {
                  hName = val;
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
                  hLocation = val;
                });
              },
            ),
            const SizedBox(height: 20.0,),
            TextFormField(

              validator: (val) => val!.isEmpty ? 'Please enter contact' : null,
              decoration: addInputDecoration.copyWith(
                hintText: "Contact",
                prefixIcon: const Icon(Icons.phone),

              ),
              cursorColor: Colors.black,
              onChanged: (val){
                setState(() {
                  contact = val;
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

                      final hotel = Hotel(
                        name: hName,
                        aid: widget.aid,
                        cName: widget.cName,
                        desc: desc!,
                        location: hLocation,
                        contact: contact!,
                        email: email!,
                        website: website!
                      );

                      await hotelService.createHotel(hotel);
                      if(mounted){
                        Navigator.pop(context);
                        showSnack("New Hotel Added..");
                      }
                    }setState(() {
                      loading = false;
                    });
                  },
                  icon: const Icon(Icons.add, color: Colors.white,),
                  label: const Text(
                    "Add Hotel",
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
