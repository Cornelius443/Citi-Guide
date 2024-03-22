import 'package:city_guide/services/hotel_service.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
class UpdateHotelImg extends StatefulWidget {
  final String hid;
  final String img;
  final Function updateImgState;
  const UpdateHotelImg({
    super.key,
    required this.hid,
    required this.img,
    required this.updateImgState

  });

  @override
  State<UpdateHotelImg> createState() => _UpdateHotelImgState();
}

class _UpdateHotelImgState extends State<UpdateHotelImg> {
  String? _imageUrl;
  File? _pickedImage;
  bool loading = false;
  HotelService hotelService = HotelService();

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
                ? loading ? const Text("Uploading ..") : Image.file(
              _pickedImage!,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            )
                : Container(),
            _pickedImage != null ? Container() : TextButton.icon(
              style: TextButton.styleFrom(
                  backgroundColor: Colors.amber
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
                    color: Colors.black
                ),
              ),
              icon: const Icon(Icons.image, color: Colors.black,),

            ),

            _pickedImage != null ? loading ?
            const Center
              (child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
            ),) : ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black
                ),
                onPressed: ()async{
                  setState(() {
                    loading = true;
                  });
                  _imageUrl =  await hotelService.updateHotelImg(widget.hid, widget.img, _pickedImage!);
                  widget.updateImgState(_imageUrl ?? widget.img);
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
