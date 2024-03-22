import 'package:city_guide/admin/profile/edit_profile.dart';
import 'package:city_guide/admin/profile/update_image.dart';
import 'package:city_guide/services/admin_service.dart';
import 'package:flutter/material.dart';

class AdminProfile extends StatefulWidget {
  final AdminData admin;
  const AdminProfile({super.key, required this.admin});

  @override
  State<AdminProfile> createState() => _AdminProfileState();
}

class _AdminProfileState extends State<AdminProfile> {
  void showUploadImage(){
    showModalBottomSheet(context: context, isScrollControlled: true, builder: (context){
      return Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            color: Colors.black87,
          ),

          padding: EdgeInsets.only(top: 16, left: 16, right: 16, bottom: MediaQuery.of(context).viewInsets.bottom),
          child: UpdateImg(admin: widget.admin, updateImgState: updateImgState)
      );
    });
  }


  void updateImgState(String url){
    setState(() {
      widget.admin.img = url;
    });
  }

  void updateState(String fName, String lName, String country,
      String phone){
    setState(() {
      widget.admin.fName = fName;
      widget.admin.lName = lName;
      widget.admin.phone = phone;
      widget.admin.country = country;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back, color: Colors.white,),
        ),
        title: const Text("Profile"),
        actions: [
          PopupMenuButton<String>(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0), // Customizing the shape of the dropdown menu
            ),
            color: Colors.black87,
            iconColor: Colors.white,
            onSelected: (value){
              if (value == 'Edit profile') {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) {
                    return EditProfile(admin: widget.admin, updateState: updateState,);
                  },
                ));

              }else if(value == 'Update'){
              showUploadImage();
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(

                value: 'Edit profile',
                child: ListTile(
                  leading: Icon(Icons.edit, color: Colors.white,),
                  title: Text(
                    'Edit Profile',
                    style: TextStyle(
                        color: Colors.white
                    ),
                  ),
                ),
              ),
              const PopupMenuItem<String>(

                value: 'Update',
                child: ListTile(
                  leading: Icon(Icons.image, color: Colors.white,),
                  title: Text(
                    'Update profile picture',
                    style: TextStyle(
                        color: Colors.white
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.fromLTRB(30, 40, 30, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 40.0,
                  child: widget.admin.img.isNotEmpty
                      ? ClipOval(
                    child: Image.network(
                      widget.admin.img,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  )
                      : const Icon(Icons.person_pin, size: 60.0,),
                ),
              ),
              const Divider(
                height: 60.0,
                color: Colors.grey,
              ),
              const Text(
                "Full Name : ",
                style: TextStyle(
                  color: Colors.grey,
                  letterSpacing: 2.0,
                  fontSize: 17.0,

                ),

              ),
              const SizedBox(height: 10.0,),
              Text(
                "${widget.admin.fName} ${widget.admin.lName}",
                style: const TextStyle(
                    color: Colors.blueGrey,
                    letterSpacing: 2.0,
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: "QuickSand"


                ),

              ),
              const SizedBox(height: 10.0,),
              const Text(
                "Country : ",
                style: TextStyle(
                  color: Colors.grey,
                  letterSpacing: 2.0,
                  fontSize: 17.0,

                ),

              ),
              const SizedBox(height: 10.0,),
              Text(
                "${widget.admin.country}",
                style: const TextStyle(
                    color: Colors.blueGrey,
                    letterSpacing: 2.0,
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: "QuickSand"


                ),

              ),
              const SizedBox(height: 10.0,),
              const Text(
                "Contact : ",
                style: TextStyle(
                  color: Colors.grey,
                  letterSpacing: 2.0,
                  fontSize: 17.0,

                ),

              ),
              const SizedBox(height: 10.0,),
              Text(
                "${widget.admin.phone}",
                style: const TextStyle(
                    color:  Colors.blueGrey,
                    letterSpacing: 2.0,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: "QuickSand"


                ),

              ),
              const SizedBox(height: 16.0,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.email),
                  const SizedBox(width: 10,),
                  Text("${widget.admin.email}")
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
