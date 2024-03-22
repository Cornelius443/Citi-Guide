import 'dart:io';
import 'package:city_guide/services/admin_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
class UpdateImg extends StatefulWidget {
  final AdminData admin;
  final Function updateImgState;
  const UpdateImg({
    super.key,
    required this.admin,
    required this.updateImgState
  });

  @override
  State<UpdateImg> createState() => _UpdateImgState();
}

class _UpdateImgState extends State<UpdateImg> {
  AdminService adminService = AdminService();
  String? _imageUrl;
  File? _pickedImage;
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

        child: Column(
          children: <Widget>[
            // Display the picked image
            _pickedImage != null
                ? loading ? const Text("Uploading ..",
              style: TextStyle(
                  color: Colors.white
        ),) : Image.file(
              _pickedImage!,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            )
                : Container(),
            _pickedImage != null ? Container() : TextButton.icon(
              style: TextButton.styleFrom(
                  backgroundColor: Colors.black54
              ),
              onPressed: () async {

                final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
                if (pickedImage != null) {
                  setState(() {
                    _pickedImage = File(pickedImage.path);
                  });
                }
              },
              label: const Text(
                "Pick Image",
                style: TextStyle(
                    color: Colors.white
                ),
              ),
              icon: const Icon(Icons.add_a_photo, color: Colors.white,),

            ),

            _pickedImage != null ? loading ?
            const Center
              (child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),) : ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black54
                ),
                onPressed: ()async{
                  setState(() {
                    loading = true;
                  });
                  _imageUrl =  await adminService.updateAdminImg(widget.admin.aid!, widget.admin.img, _pickedImage!);
                  widget.updateImgState(_imageUrl ?? widget.admin.img);
                  if(mounted){
                    Navigator.pop(context);
                    showSnack("Image uploaded..");
                  }
                },
                child: const Text(
                  "Update Image",
                  style: TextStyle(
                      color: Colors.white
                  ),
                ))  : Container()
          ],
        ),
      ),
    );
  }
}
