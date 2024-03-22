import 'package:city_guide/services/hotel_service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
class AddHotelImage extends StatefulWidget {
  final String hId;
  const AddHotelImage({super.key, required this.hId});

  @override
  State<AddHotelImage> createState() => _AddHotelImageState();
}

class _AddHotelImageState extends State<AddHotelImage> {
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

  Future<void> uploadImgToFirebase(File imageFile) async {
    try {
      // Create a reference to the location you want to upload to in Firebase Storage
      Reference storageReference = FirebaseStorage.instance.ref().child('gallery/${DateTime.now().millisecondsSinceEpoch}');

      // Upload the file to Firebase Storage
      UploadTask uploadTask = storageReference.putFile(imageFile);

      // Await the completion of the upload task
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);

      // Check if the upload is complete
      if (taskSnapshot.state == TaskState.success) {
        // Getting the download URL of the uploaded file
        String downloadURL = await storageReference.getDownloadURL();

        setState(() {
          _imageUrl = downloadURL; // Updating the imageUrl state variable
          loading = false;
        });
      } else {
        showSnack('Error uploading image: Upload task not completed');
        // Handling errors gracefully
      }
    } catch (error) {
      // Handling errors gracefully
      showSnack(error.toString());
    }
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

            _pickedImage != null ? loading ?    const Center
              (child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
            ),): ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black
                ),
                onPressed: ()async{
                  setState(() {
                    loading = true;
                  });
                  await uploadImgToFirebase(_pickedImage!);
                  await hotelService.addImage(widget.hId, _imageUrl!);
                  if(mounted){
                    Navigator.pop(context);
                    showSnack("Image uploaded..");
                  }
                },
                child: const Text(
                  "Add To Gallery",
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
