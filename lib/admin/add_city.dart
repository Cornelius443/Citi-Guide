import 'package:city_guide/services/city_service.dart';
import 'package:city_guide/shared/constants.dart';
import 'package:flutter/material.dart';

import '../models/city.dart';

class AddCity extends StatefulWidget {
  final String aid;
  const AddCity({super.key, required this.aid});

  @override
  State<AddCity> createState() => _AddCityState();
}

class _AddCityState extends State<AddCity> {
  CityService cityService = CityService();
  final _formKey = GlobalKey<FormState>();
   String? cName;
   String? desc;
   String? cLocation;
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
            "Add new city",
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
                cName = val;
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
                cLocation = val;
              });
            },
          ),
          const SizedBox(height: 20.0,),

          loading ? const Text("Processing..") :  ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black
            ),
              onPressed: ()async{
              setState(() {
                loading = true;
              });
                // Check if the form is valid
                if (_formKey.currentState?.validate() ?? false){
                  final city = City(
                    aid: widget.aid,
                    cName: cName,
                    desc: desc!,
                    cLocation: cLocation
                  );
                  await cityService.createCity(city);
                  if(mounted){
                    Navigator.pop(context);
                    showSnack("New City Added..");
                  }

                }else{
                  setState(() {
                    loading = false;
                  });
                }

              },
              icon: const Icon(Icons.add, color: Colors.white,),
              label: const Text(
                "Add City",
                style: TextStyle(
                  color: Colors.white
                ),
              ))
        ],
        ),
      ),
    );
  }
}
