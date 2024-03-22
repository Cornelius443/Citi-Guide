import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:rxdart/rxdart.dart';
import '../models/city.dart';
import '../models/user.dart';
import 'dart:io';
class CityService{

  final String? cid;
  CityService({
    this.cid
});

  final CollectionReference cityInformation = FirebaseFirestore.instance.collection('cities');

  Stream<City> get cityData{

    return cityInformation.doc(cid).snapshots().map(_cityDataFromSnapshot);
  }

  Future createCity(City city) async {
    final docCity = cityInformation.doc();
    city.cid = docCity.id;
    final json = city.toJson();
    await docCity.set(json);
  }

  Future<int> addLikeToCity(String cityId) async {
    final DocumentReference cityRef = cityInformation.doc(cityId);
    final DocumentSnapshot citySnapshot = await cityRef.get();

    if (citySnapshot.exists) {
      // If the city document exists, get the current likes count
      int currentLikes = citySnapshot['likes'] ?? 0;

      // Increment the likes count
      int updatedLikes = currentLikes + 1;

      // Update the city document with the updated likes count
      await cityRef.update({'likes': updatedLikes});
      return updatedLikes;
    } else {
      throw Exception("City with ID $cityId does not exist");
    }
  }

  Future<int> unlikeCity(String cityId) async {
    final DocumentReference cityRef = cityInformation.doc(cityId);
    final DocumentSnapshot citySnapshot = await cityRef.get();

    if (citySnapshot.exists) {
      // If the city document exists, get the current likes count
      int currentLikes = citySnapshot['likes'] ?? 0;

      // Increment the likes count
      int updatedLikes = currentLikes - 1;

      // Update the city document with the updated likes count
      await cityRef.update({'likes': updatedLikes});
      return updatedLikes;
    } else {
      throw Exception("City with ID $cityId does not exist");
    }
  }

  Future<String> updateCityDetail(String cid, String desc)
  async{
    try{
      await cityInformation.doc(cid).update({
        'desc': desc
      });
      return desc;
    }catch(e){
      print(e.toString());
      return "error";
    }
  }

  Future<String> updateCityImg(String cid, String prevImg, File newImg)
  async{
        try{
          String url = await uploadImgToFirebase(newImg);
          await cityInformation.doc(cid).update({
            'img': url
          });

          // Delete the previous image from Firebase Storage
          if (prevImg.isNotEmpty) {
            await deleteImageFromFirebase(prevImg);

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
      Reference storageReference = FirebaseStorage.instance.ref().child('image/${DateTime.now().millisecondsSinceEpoch}');

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

  City _cityDataFromSnapshot(DocumentSnapshot snapshot){
    List<dynamic> commentsData = snapshot['comment'] ?? [];
    List<Comment> comments = commentsData.map((comment) =>
        Comment.fromJson(comment)).toList();
    List<dynamic> ratingData  = snapshot['ratings'] ?? [];
    List<Ratings> ratings = ratingData.map((rating) =>
        Ratings.fromJson(rating)).toList();
    List<dynamic> imagesData = snapshot['images'] ?? [];
    List<String> images = imagesData.map((image) => image.toString()).toList();
    return City(
        cid: snapshot['id'],
        aid: snapshot['aid'],
        cName: snapshot['cName'],
        desc: snapshot['desc'],
        cLocation: snapshot['location'],
        cImg: snapshot['img'],
        likes: snapshot['likes'],
        comment: comments,
        ratings: ratings,
        images: images
    );

  }


  Stream<List<City>> get cities{
    return cityInformation.snapshots().map(_cityListFromSnapshot);
  }

  List<City> _cityListFromSnapshot(QuerySnapshot snapshot){
    return snapshot.docs.map((doc){
      List<dynamic> commentsData = doc['comment'] ?? [];
      List<Comment> comments = commentsData.map((comment) =>
          Comment.fromJson(comment)).toList();
      List<dynamic> ratingData  = doc['ratings'] ?? [];
      List<Ratings> ratings = ratingData.map((rating) =>
          Ratings.fromJson(rating)).toList();
      List<dynamic> imagesData = doc['images'] ?? [];
      List<String> images = imagesData.map((image) => image.toString()).toList();
      return City(
          cid: doc['id'],
          aid: doc['aid'],
          cName: doc['cName'],
          desc: doc['desc'],
          cLocation: doc['location'],
          cImg: doc['img'],
          likes: doc['likes'],
          comment: comments,
          ratings: ratings,
          images: images

      );
    }).toList();
  }


  Stream<List<City>> getCitiesByAdminId(String adminId) {
    return cityInformation
        .where('aid', isEqualTo: adminId)
        .snapshots()
        .map(_cityListFromSnapshot);
  }



  Future<void> removeImgFromAllComments(String img, String newImg) async {
    try {
      // Fetch all documents from the collection
      QuerySnapshot querySnapshot = await cityInformation.get();

      // Iterate through each document in the collection
      for (var doc in querySnapshot.docs) {
        // Get the comment array from the current document
        List<dynamic> commentsData = doc['comment'] ?? [];

        // Check if any comment in the array has the specified image URL
        bool imgFound = commentsData.any((comment) => comment['senderImg'] == img);

        // If the image URL is found in any comment of the current document, remove it
        if (imgFound) {
          // Create a batch to perform the update
          WriteBatch batch = FirebaseFirestore.instance.batch();

          // Remove the img field from each comment with matching img
          List<dynamic> updatedCommentsData = commentsData.map((comment) {
            // Check if the comment's senderImg matches the provided img
            // If it matches, remove the senderImg field
            if (comment['senderImg'] == img) {
              comment['senderImg'] = newImg;
            }
            return comment;
          }).toList();

          // Update the document in the batch with the updated comments
          batch.update(doc.reference, {'comment': updatedCommentsData});

          // Commit the batch
          await batch.commit();
        }
      }

      print('Image data removed from all comments successfully.');
    } catch (e) {
      print('Error removing img data from comments: $e');
    }
  }






  Future<void> addReview(String cityId, Comment comment, Ratings ratings) async {
    final DocumentReference cityRef = cityInformation.doc(cityId);
    final DocumentSnapshot citySnapshot = await cityRef.get();
    if (citySnapshot.exists){
      List<dynamic> currentComment = citySnapshot['comment'] ?? [];

      List<Comment> commentList = currentComment.map((comment) =>
      Comment.fromJson(comment)).toList();
      commentList.add(comment);

      List<dynamic> updatedComments = commentList.map((comments) => comments.toJson()).toList();
      await cityRef.update({'comment': updatedComments});
      addRating(cityId, ratings);
    }else {
      throw Exception("City with ID $cityId does not exist");
    }
  }

  Future<void> addRating(String cityId, Ratings ratings) async {
    final DocumentReference cityRef = cityInformation.doc(cityId);
    final DocumentSnapshot citySnapshot = await cityRef.get();
    if (citySnapshot.exists) {
      List<dynamic> currentRatings = citySnapshot['ratings'] ?? [];

      List<Ratings> ratingList = currentRatings.map((ratings) =>
          Ratings.fromJson(ratings)).toList();
      ratingList.add(ratings);

      List<dynamic> updatedRatings = ratingList.map((ratings) =>
          ratings.toJson()).toList();
      await cityRef.update({'ratings': updatedRatings});
    }else {
      throw Exception("City with ID $cityId does not exist");
    }
  }

  Future<void> addImage(String cityId, String img) async {
    final DocumentReference cityRef = cityInformation.doc(cityId);
    final DocumentSnapshot citySnapshot = await cityRef.get();
    if (citySnapshot.exists) {
      List<dynamic> currentImages = citySnapshot['images'] ?? [];
      List<String> images = currentImages.map((image) => image.toString()).toList();
      images.add(img); // Add the new image to the list
      await cityRef.update({'images': images});
    }
  }


  Stream<List<String>> imageStreamByCityId(String cId){
    return cityInformation.doc(cId).snapshots().map(_imageListFromSnapshot);
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

  Future<void> deleteImageFromCity(String cityId, String imageUrl) async {
    final DocumentReference cityRef = cityInformation.doc(cityId);
    final DocumentSnapshot citySnapshot = await cityRef.get();

    if (citySnapshot.exists) {
      List<dynamic> currentImages = citySnapshot['images'] ?? [];
      List<String> images = currentImages.map((image) => image.toString()).toList();

      // Check if the image URL exists in the images array
      if (images.contains(imageUrl)) {
        // Remove the image URL from the images array
        images.remove(imageUrl);

        // Update the city document with the updated images array
        await cityRef.update({'images': images});

        // Delete the image from Firebase Storage
        await deleteImageFromFirebase(imageUrl);

        print('Image deleted successfully');
      } else {
        print('Image URL not found in the images array');
      }
    } else {
      throw Exception("City with ID $cityId does not exist");
    }
  }


  List<String> _imageListFromSnapshot(DocumentSnapshot snapshot) {
    List<dynamic> imagesData = snapshot['images'] ?? [];
    List<String> images = imagesData.map((image) => image.toString()).toList();
    return images;
  }

  Future<void> addLikeToComment(String cityId, int index) async {
    final DocumentReference cityRef = cityInformation.doc(cityId);
    final DocumentSnapshot citySnapshot = await cityRef.get();

    if (citySnapshot.exists) {
      // If the city document exists, get the current comments array
      List<dynamic> currentComments = citySnapshot['comment'] ?? [];

      // Convert dynamic list to a list of Comment objects
      List<Comment> currentCommentList =
      currentComments.map((comment) => Comment.fromJson(comment)).toList();

      if (index >= 0 && index < currentCommentList.length) {
        // Increment the likes count for the comment at the specified index
        currentCommentList[index].likes++;

        // Convert the list back to dynamic to store in Firestore
        List<dynamic> updatedComments =
        currentCommentList.map((comment) => comment.toJson()).toList();

        // Update the city document with the updated comments array
        await cityRef.update({'comment': updatedComments});
      } else {
        throw Exception("Index $index is out of bounds");
      }
    } else {
      throw Exception("City with ID $cityId does not exist");
    }
  }

  Future<void> unlikeComment(String cityId, int index) async {
    final DocumentReference cityRef = cityInformation.doc(cityId);
    final DocumentSnapshot citySnapshot = await cityRef.get();

    if (citySnapshot.exists) {
      // If the city document exists, get the current comments array
      List<dynamic> currentComments = citySnapshot['comment'] ?? [];

      // Convert dynamic list to a list of Comment objects
      List<Comment> currentCommentList =
      currentComments.map((comment) => Comment.fromJson(comment)).toList();

      if (index >= 0 && index < currentCommentList.length) {
        // Increment the likes count for the comment at the specified index
        currentCommentList[index].likes--;

        // Convert the list back to dynamic to store in Firestore
        List<dynamic> updatedComments =
        currentCommentList.map((comment) => comment.toJson()).toList();

        // Update the city document with the updated comments array
        await cityRef.update({'comment': updatedComments});
      } else {
        throw Exception("Index $index is out of bounds");
      }
    } else {
      throw Exception("City with ID $cityId does not exist");
    }
  }

  Future<void> deleteCommentByIndex(String cityId, int index) async {
    final DocumentReference cityRef = cityInformation.doc(cityId);
    final DocumentSnapshot citySnapshot = await cityRef.get();

    if (citySnapshot.exists) {
      // If the city document exists, get the current comments array
      List<dynamic> currentComments = citySnapshot['comment'] ?? [];

      // Convert dynamic list to a list of Comment objects
      List<Comment> currentCommentList =
      currentComments.map((comment) => Comment.fromJson(comment)).toList();

      if (index >= 0 && index < currentCommentList.length) {
        // Remove the comment at the specified index
        currentCommentList.removeAt(index);

        // Convert the list back to dynamic to store in Firestore
        List<dynamic> updatedComments =
        currentCommentList.map((comment) => comment.toJson()).toList();

        // Update the city document with the updated comments array
        await cityRef.update({'comment': updatedComments});
      } else {
        throw Exception("Index $index is out of bounds");
      }
    } else {
      throw Exception("City with ID $cityId does not exist");
    }
  }

  Stream<List<Comment>> commentsStreamByCityId(String cityId) {
    return cityInformation.doc(cityId).snapshots().map(_commentListFromSnapshot);
  }

  List<Comment> _commentListFromSnapshot(DocumentSnapshot snapshot) {
    List<dynamic> commentData = snapshot['comment'] ?? [];
    List<Comment> comments = commentData.map((comment) => Comment.fromJson(comment)).toList();
    return comments;
  }

  Stream<List<Ratings>> ratingsStreamByCityId(String cityId) {
    return cityInformation.doc(cityId).snapshots().map(_ratingsListFromSnapshot);
  }

  List<Ratings> _ratingsListFromSnapshot(DocumentSnapshot snapshot) {
   List<dynamic> ratingData = snapshot['ratings'] ?? [];
   List<Ratings> ratings = ratingData.map((rating) => Ratings.fromJson(rating)).toList();
   return ratings;
  }


  Future deleteCity(String cid)async{
    final docCity = cityInformation.doc(cid);
    await docCity.delete();
  }
}


class CityFilterBloc {
  final BehaviorSubject<String> _filterController = BehaviorSubject<String>();
  Stream<String> get filter => _filterController.stream;

  // Stream to emit filtered cities
  final BehaviorSubject<List<City>> _filteredCitiesController = BehaviorSubject<List<City>>();
  Stream<List<City>> get filteredCities => _filteredCitiesController.stream;

  // Property to store initial list of cities
  List<City> initialCities = [];

  CityFilterBloc(List<City> initialCities) {
    _filterController.stream.listen((filterText) {
      // Implement your logic to filter cities based on the input text
      // For now, let's just print the filter text
      print("Filter Text: $filterText");

      // You can update this logic as per your requirements
      // For example, you can filter the cities list based on the city name
      List<City> filteredCities = initialCities;

      if (filterText.isNotEmpty) {
        filteredCities = initialCities.where((city) =>
        city.cName?.toLowerCase().contains(filterText.toLowerCase()) ?? false).toList();
      }

      // Add filtered cities to the stream
      _filteredCitiesController.add(filteredCities);
    });
  }

  void filterCities(String filterText) {
    _filterController.add(filterText);
  }

  void dispose() {
    _filterController.close();
    _filteredCitiesController.close();
  }
}

