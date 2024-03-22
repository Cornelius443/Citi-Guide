import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../../services/city_service.dart';
class UploadCityImage extends StatefulWidget {
  final String cid;
  final String img;
  final Function updateImgState;
  const UploadCityImage({
    super.key,
    required this.img,
    required this.cid,
    required this.updateImgState
  });

  @override
  State<UploadCityImage> createState() => _UploadCityImageState();
}

class _UploadCityImageState extends State<UploadCityImage> {
  String? _imageUrl;
  File? _pickedImage;
  bool loading = false;
  CityService cityService = CityService();
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
                _imageUrl =  await cityService.updateCityImg(widget.cid, widget.img, _pickedImage!);
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
