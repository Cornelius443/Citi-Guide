import 'package:city_guide/services/attraction_service.dart';
import 'package:city_guide/services/city_service.dart';
import 'package:city_guide/services/event_service.dart';
import 'package:city_guide/services/hotel_service.dart';
import 'package:city_guide/services/rest_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/travelers.dart';
import '../models/city.dart';
import '../models/user.dart';
import 'dart:io';
class DatabaseService{
  final String? uid;
  DatabaseService({this.uid});


  final CollectionReference userInformation = FirebaseFirestore.instance.collection('userInformation');




  Future updateUserData(
      String fName,
      String lName,
      String img,
      String email,
      String phone,
      String country,
      List<FavCity> favCities,
      List<Comment> likedComments,
      List<FavRest> favRestaurants,
      List<FavHotel> favHotels,
      List<FavEvent> favEvents,
      List<FavAttraction> favAttractions
      )async{
    try{
      return await userInformation.doc(uid).set({
        'id': uid,
        'fName': fName,
        'lName': lName,
        'img': img,
        'email': email,
        'phone': phone,
        'country': country,
        'favCities': favCities,
        'favRestaurants': favRestaurants,
        'favHotels': favHotels,
        'favEvents': favEvents,
        'favAttractions': favAttractions,
        'favComments': likedComments
      });
    }catch(e){
      print(e.toString());
      return null;
    }
  }

List<Travelers> _travelerListFromSnapshot(QuerySnapshot snapshot){
  return snapshot.docs.map((doc){
    return Travelers(
        uid: doc['id'],
        fName: doc['fName'] ?? "",
        lName: doc['lName'] ?? "",
        img: doc['img'] ?? "",
        email: doc['email'] ?? ""
    );
  }).toList();
}







  Future updateUser(String uid, String fName,
      String lName, String country, String phone)async{
    try{
      await userInformation.doc(uid).update({
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

// get Travelers stream
  Stream<List<Travelers>> get travelers{
    return userInformation.snapshots().map(_travelerListFromSnapshot);
  }

// get user data stream
  Stream<UserData> get userData{
    return userInformation.doc(uid).snapshots().map(_userDataFromSnapshot);
  }



  Future<void> addFavoriteComment(FavComment comment) async {
    try {
      await userInformation.doc(uid).update({
        'favComments': FieldValue.arrayUnion([comment.toJson()])
      });
    } catch (e) {
      print('Error adding favorite comment: $e');

    }
  }


  Future<void> removeFavoriteComment(FavComment comment) async {
    try {
      // Fetch the user document
      final DocumentReference userRef = userInformation.doc(uid);
      final DocumentSnapshot userSnapshot = await userRef.get();

      if (userSnapshot.exists) {
        // Get the current favComments array
        List<dynamic> currentFavComments = userSnapshot['favComments'] ?? [];

        // Convert dynamic list to a list of FavComment objects
        List<FavComment> currentFavCommentList = currentFavComments.map((comment) => FavComment.fromJson(comment)).toList();

        // Find the index of the comment to remove
        int indexToRemove = currentFavCommentList.indexWhere((favComment) => favComment.commentId == comment.commentId);

        if (indexToRemove != -1) {
          // Remove the comment from the list
          currentFavCommentList.removeAt(indexToRemove);

          // Convert the list back to dynamic to store in Firestore
          List<dynamic> updatedFavComments = currentFavCommentList.map((comment) => comment.toJson()).toList();

          // Update the user document with the updated favComments array
          await userRef.update({'favComments': updatedFavComments});
          print('Favorite comment removed successfully.');
        } else {
          print('Error: Comment not found in favComments array.');
        }
      } else {
        print('Error: User document with UID $uid does not exist.');
      }
    } catch (e) {
      print('Error removing favorite comment: $e');
    }
  }


  Future<void> addFavoriteCity(FavCity city) async {
    try {
      await userInformation.doc(uid).update({
        'favCities': FieldValue.arrayUnion([city.toJson()])
      });
    } catch (e) {
      print('Error adding favorite city: $e');
    }
  }

  Future<void> removeFavoriteCity(FavCity city) async {
    try {
      await userInformation.doc(uid).update({
        'favCities': FieldValue.arrayRemove([city.toJson()])
      });
    } catch (e) {
      print(e.toString());
    }
  }
  Future<void> addFavoriteRest(FavRest rest) async {
    try {
      await userInformation.doc(uid).update({
        'favRestaurants': FieldValue.arrayUnion([rest.toJson()])
      });
    } catch (e) {
      print('Error adding favorite city: $e');
    }
  }

  Future<void> removeFavoriteRest(FavRest rest) async {
    try {
      await userInformation.doc(uid).update({
        'favRestaurants': FieldValue.arrayRemove([rest.toJson()])
      });
    } catch (e) {
      print('Error adding favorite city: $e');
    }
  }

  Future<void> addFavoriteHotel(FavHotel hotel) async {
    try {
      await userInformation.doc(uid).update({
        'favHotels': FieldValue.arrayUnion([hotel.toJson()])
      });
    } catch (e) {
      print('Error adding favorite city: $e');
    }
  }

  Future<void> removeFavoriteHotel(FavHotel hotel) async {
    try {
      await userInformation.doc(uid).update({
        'favHotels': FieldValue.arrayRemove([hotel.toJson()])
      });
    } catch (e) {
      print('Error adding favorite city: $e');
    }
  }

  Future<void> addFavoriteEvent(FavEvent event) async {
    try {
      await userInformation.doc(uid).update({
        'favEvents': FieldValue.arrayUnion([event.toJson()])
      });
    } catch (e) {
      print('Error adding favorite city: $e');
    }
  }

  Future<void> removeFavoriteEvent(FavEvent event) async {
    try {
      await userInformation.doc(uid).update({
        'favEvents': FieldValue.arrayRemove([event.toJson()])
      });
    } catch (e) {
      print('Error adding favorite city: $e');
    }
  }

  Future<void> addFavoriteAttraction(FavAttraction attraction) async {
    try {
      await userInformation.doc(uid).update({
        'favAttractions': FieldValue.arrayUnion([attraction.toJson()])
      });
    } catch (e) {
      print('Error adding favorite city: $e');
    }
  }

  Future<void> removeFavoriteAttraction(FavAttraction attraction) async {
    try {
      await userInformation.doc(uid).update({
        'favAttractions': FieldValue.arrayRemove([attraction.toJson()])
      });
    } catch (e) {
      print('Error adding favorite city: $e');
    }
  }

  Stream<List<FavCity>> favoriteCitiesStream() {
    return userInformation
        .doc(uid)
        .snapshots()
        .map((snapshot) => _favoriteCitiesFromSnapshot(snapshot));
  }

  Stream<List<FavRest>> favoriteRestStream() {
    return userInformation
        .doc(uid)
        .snapshots()
        .map((snapshot) => _favoriteRestFromSnapshot(snapshot));
  }

  Stream<List<FavHotel>> favoriteHotelStream() {
    return userInformation
        .doc(uid)
        .snapshots()
        .map((snapshot) => _favoriteHotelFromSnapshot(snapshot));
  }

  Stream<List<FavEvent>> favoriteEventStream() {
    return userInformation
        .doc(uid)
        .snapshots()
        .map((snapshot) => _favoriteEventFromSnapshot(snapshot));
  }

  Stream<List<FavAttraction>> favoriteAttractionStream() {
    return userInformation
        .doc(uid)
        .snapshots()
        .map((snapshot) => _favoriteAttractionFromSnapshot(snapshot));
  }
  List<FavCity> _favoriteCitiesFromSnapshot(DocumentSnapshot snapshot) {
    final List<dynamic> favCitiesData = snapshot['favCities'] ?? [];
    return favCitiesData.map((cityData) => FavCity.fromJson(cityData)).toList();
  }

  List<FavRest> _favoriteRestFromSnapshot(DocumentSnapshot snapshot) {
    final List<dynamic> favRestData = snapshot['favRestaurants'] ?? [];
    return favRestData.map((restData) => FavRest.fromJson(restData)).toList();
  }

  List<FavHotel> _favoriteHotelFromSnapshot(DocumentSnapshot snapshot) {
    final List<dynamic> favHotelData = snapshot['favHotels'] ?? [];
    return favHotelData.map((hotelData) => FavHotel.fromJson(hotelData)).toList();
  }

  List<FavEvent> _favoriteEventFromSnapshot(DocumentSnapshot snapshot) {
    final List<dynamic> favEventData = snapshot['favEvents'] ?? [];
    return favEventData.map((eventData) => FavEvent.fromJson(eventData)).toList();
  }

  List<FavAttraction> _favoriteAttractionFromSnapshot(DocumentSnapshot snapshot) {
    final List<dynamic> favAData = snapshot['favAttractions'] ?? [];
    return favAData.map((aData) => FavAttraction.fromJson(aData)).toList();
  }
  // user data from snapshot
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot){
    List<dynamic> favCitiesData = snapshot['favCities'] ?? [];
    List<FavCity> favCities = favCitiesData.map((cityData) => FavCity.fromJson(cityData)).toList();
    List<dynamic> favRestData = snapshot['favRestaurants'] ?? [];
    List<FavRest> favRests = favRestData.map((restData) => FavRest.fromJson(restData)).toList();
    List<dynamic> favHotelData = snapshot['favHotels'] ?? [];
    List<FavHotel> favHotels = favHotelData.map((hotelData) => FavHotel.fromJson(hotelData)).toList();
    List<dynamic> favEventData = snapshot['favEvents'] ?? [];
    List<FavEvent> favEvents = favEventData.map((eventData) => FavEvent.fromJson(eventData)).toList();
    List<dynamic> favAData = snapshot['favAttractions'] ?? [];
    List<FavAttraction> favAttractions = favAData.map((aData) => FavAttraction.fromJson(aData)).toList();
    List<dynamic> favCommentData = snapshot['favComments'] ?? [];
    List<FavComment> favComments = favCommentData.map((cityData) => FavComment.fromJson(cityData)).toList();
    return UserData(
        uid: uid,
        fName: snapshot['fName'],
        lName: snapshot['lName'],
        img: snapshot['img'],
        email: snapshot['email'],
        phone: snapshot['phone'],
        country: snapshot['country'],
        favCities: favCities,
        favRestaurants: favRests,
        favHotels: favHotels,
        favEvents: favEvents,
        favAttractions: favAttractions,
        likedComments: favComments
    );


  }


  Future<String> updateUserImg(String uid, String prevImg, File newImg)
  async{
    try{
      String url = await uploadImgToFirebase(newImg);
      await userInformation.doc(uid).update({
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



  Future<String> uploadImgToFirebase(File imageFile) async {
    String? url;
    try {
      // Create a reference to the location you want to upload to in Firebase Storage
      Reference storageReference = FirebaseStorage.instance.ref().child('user/${DateTime.now().millisecondsSinceEpoch}');

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
