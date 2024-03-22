import 'dart:convert';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../shared/constants.dart';
import '../../shared/loader.dart';
import '../../services/admin_service.dart';

class EditProfile extends StatefulWidget {
  final AdminData admin;
  final Function updateState;
  const EditProfile({super.key,
    required this.admin,
    required this.updateState
  });

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();
  AdminService adminService = AdminService();
  String? fName;
  String? lName;
  List<String> countries = [];
  String? contact;
  String? country;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchCountries();
  }

  void showSnack(String msg){
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(msg)
        )
    );
  }
  Future<void> fetchCountries() async {
    try {
      final response =
      await http.get(Uri.parse('https://restcountries.com/v3.1/all'));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        List<String> fetchedCountries = data
            .map((country) => country['name']['common'].toString())
            .toSet()
            .toList();
        // Sort the fetched countries alphabetically
        fetchedCountries.sort();

        setState(() {
          countries = fetchedCountries;
          loading = false; // Set loading to false when fetching is complete
        });
      } else {
        setState(() {
          loading = false; // Set loading to false on error
        });
        throw Exception('Failed to load countries');
      }
    } catch (e) {
      setState(() {
        loading = false; // Set loading to false on error
      });
      // Handle error gracefully, show a message to the user or retry
      if(mounted){
        showSnack('Error fetching information try again: $e');
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Loader(color: Colors.black)
        : Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back, color: Colors.white,),
        ),
        title: const Text("Edit Profile"),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.only(top: 100.0),
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            children: [
              const Text("Edit your profile"),
              const SizedBox(height: 20,),
              TextFormField(
                style: const TextStyle(
                  color: Colors.black,
                  fontFamily: "Pacifico",
                  fontSize: 20.0,
                ),
                decoration: addInputDecoration.copyWith(
                  hintText: "First Name",
                  prefixIcon: const Icon(
                    Icons.person_2,

                  ),
                ),
                initialValue: widget.admin.fName ?? "",
                validator: (val) =>
                val?.isEmpty ?? true ? 'Please enter firstname' : null,
                onChanged: (val) {
                  setState(() {
                    fName = val;
                  });
                },
                cursorColor: Colors.white,
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                style: const TextStyle(
                  color: Colors.black,
                  fontFamily: "Pacifico",
                  fontSize: 20.0,
                ),
                decoration: addInputDecoration.copyWith(
                  hintText: "Last Name",
                  prefixIcon: const Icon(
                    Icons.person_2,

                  ),
                ),
                initialValue: widget.admin.lName ?? "",
                validator: (val) =>
                val?.isEmpty ?? true ? 'Please enter last name' : null,
                onChanged: (val) {
                  setState(() {
                    lName = val;
                  });
                },
                cursorColor: Colors.white,
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                style: const TextStyle(
                  color: Colors.black,
                  fontFamily: "Pacifico",
                  fontSize: 20.0,
                ),
                decoration: addInputDecoration.copyWith(
                  hintText: "Contact",
                  prefixIcon: const Icon(
                    Icons.person_2,

                  ),
                ),
                initialValue: widget.admin.phone ?? "",
                validator: (val) =>
                val?.isEmpty ?? true ? 'Please enter phone no' : null,
                onChanged: (val) {
                  setState(() {
                    contact = val;
                  });
                },
                cursorColor: Colors.white,
              ),
              const SizedBox(height: 20.0),
              DropdownButtonHideUnderline(
                child: DropdownButton2<String>(
                  isExpanded: true,
                  hint: const Row(
                    children: [
                      Icon(
                        Icons.list,
                        size: 16,
                        color: Colors.black,
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Expanded(
                        child: Text(
                          'Select Item',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  items: countries
                      .map((String country) => DropdownMenuItem<String>(
                    value: country,
                    child: Text(
                      country,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ))
                      .toList(),
                  value: country ?? widget.admin.country,
                  onChanged: (value) {
                    setState(() {
                      country = value;
                    });
                  },
                  buttonStyleData: ButtonStyleData(
                    height: 50,
                    width: 160,
                    padding: const EdgeInsets.only(left: 14, right: 14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: Colors.black,
                      ),
                      color: Colors.white,
                    ),

                  ),
                  iconStyleData: const IconStyleData(
                    icon: Icon(
                      Icons.arrow_forward_ios_outlined,
                      color: Colors.black,
                    ),
                    iconSize: 14,
                    iconEnabledColor: Colors.yellow,
                    iconDisabledColor: Colors.grey,
                  ),
                  dropdownStyleData: DropdownStyleData(
                    maxHeight: 300,
                    width: 400,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: Colors.white,
                    ),
                    offset: const Offset(-20, 0),
                    scrollbarTheme: ScrollbarThemeData(
                      radius: const Radius.circular(40),
                      thickness: MaterialStateProperty.all(6),
                      thumbVisibility: MaterialStateProperty.all(true),
                    ),
                  ),
                  menuItemStyleData: const MenuItemStyleData(
                    height: 40,
                    padding: EdgeInsets.only(left: 14, right: 14),
                  ),
                ),
              ),
              const SizedBox(height: 10.0,),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,

                ),
                  onPressed: ()async{

                  if (_formKey.currentState?.validate() ?? false){
                  setState(() {
                  loading = true;
                  });
                await adminService.updateAdmin(
                    widget.admin.aid!,
                    fName ?? widget.admin.fName!,
                    lName ?? widget.admin.lName!,
                    country ?? widget.admin.country!,
                    contact ?? widget.admin.phone!
                );
                  widget.updateState(
                    fName ?? widget.admin.fName!,
                    lName ?? widget.admin.lName!,
                    country ?? widget.admin.country!,
                    contact ?? widget.admin.phone!

                  );
                  if(mounted){
                    Navigator.pop(context);
                    showSnack("Profile Updated");
                  }
                  }

                  },
                  icon: const Icon(Icons.update, color: Colors.white,),
                label: const Text(
                    "update",
                  style: TextStyle(
                    color: Colors.white
                  ),
                ),

              )
            ],
          ),
        ),
      ),
    );
  }
}
