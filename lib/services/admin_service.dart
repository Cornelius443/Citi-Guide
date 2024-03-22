import 'package:city_guide/services/rest_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

import 'attraction_service.dart';
import 'city_service.dart';
import 'event_service.dart';
import 'hotel_service.dart';
class AdminService{
  final String? aid;
  AdminService({this.aid});

  final CollectionReference adminInformation = FirebaseFirestore.instance.collection('admin');

  Future updateAdminData(
      String fName,
      String lName,
      String img,
      String email,
      String phone,
      String country,
      )async{
    try{
      return await adminInformation.doc(aid).set({
        'id': aid,
        'fName': fName,
        'lName': lName,
        'img': img,
        'email': email,
        'phone': phone,
        'country': country
      });
    }catch(e){
      print(e.toString());
      return null;
    }
  }

  // get data data stream
  Stream<AdminData> get adminData{
    return adminInformation.doc(aid).snapshots().map(_adminDataFromSnapshot);
  }



  // admin data from snapshot
  AdminData _adminDataFromSnapshot(DocumentSnapshot snapshot){
    return AdminData(
        aid: aid,
        fName: snapshot['fName'],
        lName: snapshot['lName'],
        img: snapshot['img'],
        email: snapshot['email'],
        phone: snapshot['phone'],
        country: snapshot['country'],

    );
  }

  Future<String> updateAdminImg(String aid, String prevImg, File newImg)
  async{
    try{
      String url = await uploadImgToFirebase(newImg);
      await adminInformation.doc(aid).update({
        'img': url
      });

      // Delete the previous image from Firebase Storage
      if (prevImg.isNotEmpty) {
        await deleteImageFromFirebase(prevImg);
        await CityService().removeImgFromAllComments(prevImg, url);
        await RestaurantService().removeImgFromAllComments(prevImg, url);
        await HotelService().removeImgFromAllComments(prevImg, url);
        await EventService().removeImgFromAllComments(prevImg, url);
        await AttractionService().removeImgFromAllComments(prevImg, url);

      }
      return url;
    }catch(e){
      print(e.toString());
      return "error";
    }
  }

  Future updateAdmin(String aid, String fName,
      String lName, String country, String phone)async{
    try{
      await adminInformation.doc(aid).update({
        'fName': fName,
        'lName': lName,
        'country': country,
        'phone': phone
      });
    }catch(e){
      print(e.toString());
      return "error";
    }
  }



  Future<String> uploadImgToFirebase(File imageFile) async {
    String? url;
    try {
      // Create a reference to the location you want to upload to in Firebase Storage
      Reference storageReference = FirebaseStorage.instance.ref().child('admin/${DateTime.now().millisecondsSinceEpoch}');

      // Upload the file to Firebase Storage
      UploadTask uploadTask = storageReference.putFile(imageFile);

      // Await the completion of the upload task
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);

      // Check if the upload is complete
      if (taskSnapshot.state == TaskState.success) {
        // Getting the download URL of the uploaded file
        String downloadURL = await storageReference.getDownloadURL();
        url = downloadURL;
      } else {
        print('Error uploading image: Upload task not completed');
        // Handling errors gracefully
      }
    } catch (error) {
      // Handling  errors gracefully
      print(error.toString());
    }
    return url!;
  }



  Future<void> deleteImageFromFirebase(String imageUrl) async {
    try {
      // Create a reference to the image in Firebase Storage
      Reference imageReference = FirebaseStorage.instance.refFromURL(imageUrl);

      // Delete the image from Firebase Storage
      await imageReference.delete();

      print('Image deleted successfully');
    } catch (error) {
      // Handle errors
      print('Error deleting image: $error');
    }
  }
}

class AdminData{
  final String? aid;
  String? fName;
  String? lName;
  String img;
  final String? email;
  String? phone;
  String? country;

  AdminData({
    this.aid,
    this.fName,
    this.lName,
    this.img = '',
    this.email,
    this.phone,
    this.country
  });
}