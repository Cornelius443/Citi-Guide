import 'package:city_guide/models/city.dart';
import 'package:city_guide/services/attraction_service.dart';
import 'package:flutter/material.dart';

import '../../shared/constants.dart';

class AddAttraction extends StatefulWidget {
  final String cName;
  final String aid;
  const AddAttraction({
    super.key,
    required this.cName,
    required this.aid
  });

  @override
  State<AddAttraction> createState() => _AddAttractionState();
}

class _AddAttractionState extends State<AddAttraction> {

  AttractionService attractionService = AttractionService();
  final _formKey = GlobalKey<FormState>();
  String? name;
  String? desc;
  String? location;
  String? email;
  String? contact;
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
              "Add new Attraction",
              style: TextStyle(
                  fontSize: 18.0
              ),
            ),
            const SizedBox(height: 20.0,),
            TextFormField(
              validator: (val) => val!.isEmpty ? 'Please enter attraction name' : null,
              decoration: addInputDecoration.copyWith(
                  hintText: "Attraction Name"
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

                    final attraction = Attractions(
                      name: name,
                      aId: widget.aid,
                      cName: widget.cName,
                      desc: desc!,
                      location: location,
                      email: email!,
                      contact: contact!,
                      website: website!
                    );

                      await attractionService.createAttraction(attraction);
                     if(mounted){
                       Navigator.pop(context);
                       showSnack("New Attraction Added..");
                     }
                    }setState(() {
                      loading = false;
                    });
                  },
                  icon: const Icon(Icons.add, color: Colors.white,),
                  label: const Text(
                    "Add Attraction",
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
