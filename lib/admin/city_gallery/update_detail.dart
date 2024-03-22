import 'package:flutter/material.dart';
import '../../services/city_service.dart';
import '../../shared/constants.dart';
class UpdateCityDesc extends StatefulWidget {
  final String cid;
  final Function updateDetail;
  const UpdateCityDesc({super.key, required this.cid, required this.updateDetail});

  @override
  State<UpdateCityDesc> createState() => _UpdateCityDescState();
}

class _UpdateCityDescState extends State<UpdateCityDesc> {
  CityService cityService = CityService();
  String? desc;
  bool loading = false;
  final _formKey = GlobalKey<FormState>();
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
              "Update Info",
              style: TextStyle(
                  fontSize: 18.0
              ),
            ),
            const SizedBox(height: 20.0,),
            TextFormField(
              maxLines: null,
              keyboardType: TextInputType.multiline,
              decoration: addInputDecoration.copyWith(
                  hintText: "New Description",
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

            loading ? const Text("Processing..")
                : ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black
                ),
                onPressed: ()async{
                  setState(() {
                    loading = true;
                  });
                  // Check if the form is valid
                  if (_formKey.currentState?.validate() ?? false){

                   String det = await cityService.updateCityDetail(widget.cid, desc!);
                   widget.updateDetail(det);
                    if(mounted){
                      Navigator.pop(context);
                      showSnack("Updates made successfully..");
                    }

                  }else{
                    setState(() {
                      loading = false;
                    });
                  }

                },
                icon: const Icon(Icons.add, color: Colors.white,),
                label: const Text(
                  "Update",
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
