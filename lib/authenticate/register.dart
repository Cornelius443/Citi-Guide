
import 'dart:convert';

import 'package:city_guide/shared/constants.dart';
import 'package:city_guide/shared/loader.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import '../services/auth.dart';
import 'package:http/http.dart' as http;


class Register extends StatefulWidget {
  final Function toggleView;
  const Register({super.key, required this.toggleView});

  @override
  State<Register> createState() => _RegisterState();
}


class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String _fName = "";
  String _lName = "";
  String _email = "";
  String _password = "";
  String _phone = "";
  String? _country;
  String _confirmPass = "";
  String error = "";
  String matchError = "";
  bool loading = true;
  bool _isAdmin = false;
  List<String> countries = [];

  void showSnack(String msg){
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(msg)
        )
    );
  }

  @override
  void initState() {

    super.initState();
    fetchCountries();

  }



  Future<void> fetchCountries() async {
    try {
      final response = await http.get(Uri.parse('https://restcountries.com/v3.1/all'));
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
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black54,
        title: loading ? null : const Text(
          "Create Your CityGuide Account",
          style: TextStyle(
            fontSize: 23,
            fontFamily: "Pacifico",
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
      ),
      body: loading ? const Loader(
        color: Colors.white,
      ) : SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(24.0),
          decoration:  BoxDecoration(
            image: DecorationImage(
              image: const AssetImage("assets/images/asia.jpg"),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.7),
                BlendMode.darken,
              ),
            ),
        
          ),
        
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 120,
              ),
               Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  style: const TextStyle(
                      color: Colors.white
                  ),
                  validator: (val) => val!.isEmpty ? 'Please enter first name' : null,
                  decoration: textInputDecoration.copyWith(
                    hintText: "First Name",
                    prefixIcon: const Icon(Icons.person, color: Colors.white,),

                  ),
                  onChanged: (val){
                    setState(() {
                      _fName = val;
                    });
                  },
                  cursorColor: Colors.white,

                ),
                const SizedBox(height: 20),
                TextFormField(
                  style: const TextStyle(
                      color: Colors.white
                  ),
                  decoration: textInputDecoration.copyWith(
                    hintText: "Last Name",
                    prefixIcon: const Icon(Icons.person, color: Colors.white,),
                  ),
                  validator: (val) => val!.isEmpty ? 'Please enter last name' : null,
                  onChanged: (val){
                    setState(() {
                      _lName = val;
                    });
                  },
                  cursorColor: Colors.white,

                ),
                const SizedBox(height: 20),
                TextFormField(
                  style: const TextStyle(
                      color: Colors.white
                  ),
                  decoration: textInputDecoration.copyWith(
                      hintText: "Email",
                      prefixIcon: const Icon(Icons.email, color: Colors.white,)
                  ),
                  validator: (val) => val!.isEmpty ? 'Enter an email' : null,
                  onChanged: (val){
                    setState(() {
                      _email = val;
                    });
                  },
                  cursorColor: Colors.white,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  style: const TextStyle(
                      color: Colors.white
                  ),
                  decoration: textInputDecoration.copyWith(
                    hintText: "Mobile/Phone Number",
                    prefixIcon: const Icon(Icons.phone, color: Colors.white,),
                  ),
                  validator: (val) => val!.isEmpty ? 'Enter phone number' : null,
                  onChanged: (val){
                    setState(() {
                      _phone = val;
                    });
                  },
                  cursorColor: Colors.white,

                ),
                const SizedBox(height: 20),
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
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ))
                        .toList(),
                    value: _country ?? countries.first,
                    onChanged: (value) {
                      setState(() {
                        _country = value!;
                      });
                    },
                    buttonStyleData: ButtonStyleData(
                      height: 50,
                      width: 360,
                      padding: const EdgeInsets.only(left: 14, right: 14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: Colors.white,
                        ),
                        color: Colors.transparent,
                      ),

                    ),
                    iconStyleData: const IconStyleData(
                      icon: Icon(
                        Icons.arrow_forward_ios_outlined,
                        color: Colors.white,
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
                        color: Colors.black,
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
                const SizedBox(height: 20),
                TextFormField(
                  style: const TextStyle(
                      color: Colors.white
                  ),
                  decoration: textInputDecoration.copyWith(
                      hintText: "Password",
                      prefixIcon: const Icon(Icons.password, color: Colors.white,)
                  ),
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Enter password';
                    }
                    if (val.length != 8) {
                      return 'Password must be 8 digits';
                    }
                    return null; // Return null if validation passes
                  },
                  onChanged: (val){
                    setState(() {
                      _password = val;
                    });
                  },
                  obscureText: true,
                  cursorColor: Colors.white,
                ),
                const SizedBox(height: 20),
              matchError != "" ? Text(
                  matchError,
                  style: const TextStyle(
                      color: Colors.red
                  ),
                ) : Container(),
                TextFormField(
                  style: const TextStyle(
                      color: Colors.white
                  ),
                  decoration: textInputDecoration.copyWith(
                      hintText: "Confirm Password",
                      prefixIcon: const Icon(Icons.password, color: Colors.white,)
                  ),
                  validator: (val) => val!.isEmpty ? 'Please enter first name' : null,
                  onChanged: (val){
                    setState(() {
                      _confirmPass = val;
                    });
                  },
                  obscureText: true,
                  cursorColor: Colors.white,
                ),
               error != "" ? Text(
                error,
                  style: const TextStyle(
                    color: Colors.red
                  ),
                ) : Container(),

                Row(
                  children: [
                    const Text(
                      "Registering as : ",
                      style: TextStyle(
                          color: Colors.white
                      ),
                    ),
                    Radio(
                      activeColor: Colors.blue,
                      value: false,
                      groupValue: _isAdmin,
                      onChanged: (value) {
                        setState(() {
                          _isAdmin = value as bool;
                        });
                      },
                    ),
                   const Text(
                       'Tourist',
                     style: TextStyle(
                         color: Colors.white
                     ),
                   ),
                    Radio(
                      activeColor: Colors.blue,
                      value: true,
                      groupValue: _isAdmin,
                      onChanged: (value) {
                        setState(() {
                          _isAdmin = value as bool;
                        });
                      },
                    ),
                   const Text(
                       'Admin',
                     style: TextStyle(
                         color: Colors.white
                     ),
                   ),
                  ],
                ),
                const SizedBox(height: 20),



                ElevatedButton(
                  onPressed: () async {
                    // Check if the form is valid
                    if (_formKey.currentState?.validate() ?? false) {
                      // Check if a country has been selected
                      if (_country!.isEmpty) {
                        setState(() {
                          error = "Please select a country"; // Display error message
                        });
                      } else {
                        setState(() {
                          loading = true;
                        });
                        if (_password == _confirmPass) {
                          dynamic res = await _auth.registerWithEmailAndPassword(_fName, _lName, "", _email,
                              _password, _phone, _country!, _isAdmin);
                          if(mounted){
                            showSnack("Registration Successful..");
                          }
                          if (res == null) {
                           if(mounted){
                             setState(() {
                               error = "Error signing up";
                               loading = false;
                             });
                           }
                          }
                        } else {
                          if (mounted) { // Check if the widget is mounted before calling setState
                            setState(() {
                              matchError = "Passwords don't match";
                              loading = false;
                            });
                          }
                        }
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 16),
                    backgroundColor: Colors.green,
                  ),
                  child: const Text(
                    "Register",
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontFamily: "QuickSand"
                    ),
                  ),
                ),
              ],
            ),
          ),
              const SizedBox(
                height: 5,
              ),
              const SizedBox(
                height: 5,
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Already have an account?',
                    style: TextStyle(
                      color: Color.fromARGB(255, 183, 181, 180),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      widget.toggleView();
                    },
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 15,
                          fontFamily: "QuickSand"
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }


}