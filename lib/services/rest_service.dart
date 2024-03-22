import 'package:city_guide/models/city.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/user.dart';
import 'dart:io';

// Restaurant service class
class RestaurantService{
  final String? restId;
  RestaurantService({this.restId});

  final CollectionReference restInformation = FirebaseFirestore.instance.collection('restaurants');


  // create restaurant
  Future createRestaurant(Restaurant restaurant)async{
    final docRest = restInformation.doc();
    restaurant.rId = docRest.id;
    final json = restaurant.toJson();
    await docRest.set(json);
  }

  // get restaurant data
  Stream<Restaurant> get restData{
    return restInformation.doc(restId).snapshots().map(_restDataFromSnapshot);
  }

  Stream<List<Restaurant>> get restaurants{
    return restInformation.snapshots().map(_restListFromSnapshot);
  }

  Stream<List<Restaurant>> getRestByAdminId(String adminId){
    return restInformation
        .where('aid', isEqualTo: adminId)
        .snapshots()
        .map(_restListFromSnapshot);
  }

  Stream<List<Restaurant>> getRestByCityName(String cName) {
    return restInformation
        .where('cName', isEqualTo: cName)
        .snapshots()
        .map(_restListFromSnapshot);
  }

  Restaurant _restDataFromSnapshot(DocumentSnapshot snapshot){
    List<dynamic> commentsData = snapshot['comments'] ?? [];
    List<Comment> comments = commentsData.map((comment) =>
        Comment.fromJson(comment)).toList();
    List<dynamic> ratingData  = snapshot['ratings'] ?? [];
    List<Ratings> ratings = ratingData.map((rating) =>
        Ratings.fromJson(rating)).toList();
    List<dynamic> imagesData = snapshot['images'] ?? [];
    List<String> images = imagesData.map((image) => image.toString()).toList();
    return Restaurant(
        rId: snapshot['rId'],
        rName: snapshot['rName'],
        aid: snapshot['aid'],
        cName: snapshot['cName'],
        desc: snapshot['desc'],
        rLocation: snapshot['location'],
        contact: snapshot['contact'],
        email: snapshot['email'],
        website: snapshot['website'],
        rImg: snapshot['img'],
        likes: snapshot['likes'],
        comments: comments,
        ratings: ratings,
        images: images
    );

  }

  List<Restaurant> _restListFromSnapshot(QuerySnapshot snapshot){
    return snapshot.docs.map((doc){
      List<dynamic> commentsData = doc['comments'] ?? [];
      List<Comment> comments = commentsData.map((comment) =>
          Comment.fromJson(comment)).toList();
      List<dynamic> ratingData  = doc['ratings'] ?? [];
      List<Ratings> ratings = ratingData.map((rating) =>
          Ratings.fromJson(rating)).toList();
      List<dynamic> imagesData = doc['images'] ?? [];
      List<String> images = imagesData.map((image) => image.toString()).toList();
      return Restaurant(
          rId: doc['rId'],
          rName: doc['rName'],
          aid: doc['aid'],
          cName: doc['cName'],
          desc: doc['desc'],
          rLocation: doc['location'],
          contact: doc['contact'],
          email: doc['email'],
          website: doc['website'],
          rImg: doc['img'],
          likes: doc['likes'],
          comments: comments,
          ratings: ratings,
          images: images
      );
    }).toList();
  }



  Future<void> removeImgFromAllComments(String img, String newImg) async {
    try {
      // Fetch all documents from the collection
      QuerySnapshot querySnapshot = await restInformation.get();

      // Iterate through each document in the collection
      for (var doc in querySnapshot.docs) {
        // Get the comment array from the current document
        List<dynamic> commentsData = doc['comments'] ?? [];

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
          batch.update(doc.reference, {'comments': updatedCommentsData});

          // Commit the batch
          await batch.commit();
        }
      }

      print('Image data removed from all comments successfully.');
    } catch (e) {
      print('Error removing img data from comments: $e');
    }
  }


  Future<int> addLikeToRest(String rId) async {
    final DocumentReference restRef = restInformation.doc(rId);
    final DocumentSnapshot restSnapshot = await restRef.get();

    if (restSnapshot.exists) {
      // If the city document exists, get the current likes count
      int currentLikes = restSnapshot['likes'] ?? 0;

      // Increment the likes count
      int updatedLikes = currentLikes + 1;

      // Update the city document with the updated likes count
      await restRef.update({'likes': updatedLikes});
      return updatedLikes;
    } else {
      throw Exception("Restaurant with ID $rId does not exist");
    }
  }

  Future<int> unlikeRest(String rId) async {
    final DocumentReference restRef = restInformation.doc(rId);
    final DocumentSnapshot restSnapshot = await restRef.get();
    if (restSnapshot.exists) {
      // If the city document exists, get the current likes count
      int currentLikes = restSnapshot['likes'] ?? 0;

      // Increment the likes count
      int updatedLikes = currentLikes - 1;

      // Update the city document with the updated likes count
      await restRef.update({'likes': updatedLikes});
      return updatedLikes;
    } else {
      throw Exception("Restaurant with ID $rId does not exist");
    }
  }

  Future<String> updateRestDetail(String rid, String desc)
  async{
    try{
      await restInformation.doc(rid).update({
        'desc': desc
      });
      return desc;
    }catch(e){
      print(e.toString());
      return "error";
    }
  }

  Future<String> updateRestImg(String rid, String prevImg, File newImg)
  async{
    try{
      String url = await uploadImgToFirebase(newImg);
      await restInformation.doc(rid).update({
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
  Stream<List<String>> imageStreamByRestId(String rId){
    return restInformation.doc(rId).snapshots().map(_imageListFromSnapshot);
  }

  Future<void> addReview(String rId, Comment comment, Ratings ratings) async {
    final DocumentReference restRef = restInformation.doc(rId);
    final DocumentSnapshot restSnapshot = await restRef.get();
    if (restSnapshot.exists){
      List<dynamic> currentComment = restSnapshot['comments'] ?? [];

      List<Comment> commentList = currentComment.map((comment) =>
          Comment.fromJson(comment)).toList();
      commentList.add(comment);

      List<dynamic> updatedComments = commentList.map((comments) => comments.toJson()).toList();
      await restRef.update({'comments': updatedComments});
      addRating(rId, ratings);
    }else {
      throw Exception("Restaurant with ID $rId does not exist");
    }
  }

  Future<void> addRating(String rId, Ratings ratings) async {
    final DocumentReference restRef = restInformation.doc(rId);
    final DocumentSnapshot restSnapshot = await restRef.get();
    if (restSnapshot.exists) {
      List<dynamic> currentRatings = restSnapshot['ratings'] ?? [];

      List<Ratings> ratingList = currentRatings.map((ratings) =>
          Ratings.fromJson(ratings)).toList();
      ratingList.add(ratings);

      List<dynamic> updatedRatings = ratingList.map((ratings) =>
          ratings.toJson()).toList();
      await restRef.update({'ratings': updatedRatings});
    }else {
      throw Exception("Restaurant with ID $rId does not exist");
    }
  }

  Future<void> addImage(String rId, String img) async {
    final DocumentReference restRef = restInformation.doc(rId);
    final DocumentSnapshot restSnapshot = await restRef.get();
    if (restSnapshot.exists) {
      List<dynamic> currentImages = restSnapshot['images'] ?? [];
      List<String> images = currentImages.map((image) => image.toString()).toList();
      images.add(img); // Add the new image to the list
      await restRef.update({'images': images});
    }
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

  Future<void> deleteImageFromRest(String rId, String imageUrl) async {
    final DocumentReference restRef = restInformation.doc(rId);
    final DocumentSnapshot restSnapshot = await restRef.get();

    if (restSnapshot.exists) {
      List<dynamic> currentImages = restSnapshot['images'] ?? [];
      List<String> images = currentImages.map((image) => image.toString()).toList();

      // Check if the image URL exists in the images array
      if (images.contains(imageUrl)) {
        // Remove the image URL from the images array
        images.remove(imageUrl);

        // Update the city document with the updated images array
        await restRef.update({'images': images});

        // Delete the image from Firebase Storage
        await deleteImageFromFirebase(imageUrl);

        print('Image deleted successfully');
      } else {
        print('Image URL not found in the images array');
      }
    } else {
      throw Exception("Restaurant with ID $rId does not exist");
    }
  }

  Future<void> deleteCommentByIndex(String rId, int index) async {

    final DocumentReference restRef = restInformation.doc(rId);
    final DocumentSnapshot restSnapshot = await restRef.get();

    if (restSnapshot.exists) {
      // If the city document exists, get the current comments array
      List<dynamic> currentComments = restSnapshot['comments'] ?? [];

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
        await restRef.update({'comments': updatedComments});
      } else {
        throw Exception("Index $index is out of bounds");
      }
    } else {
      throw Exception("restaurant with ID $rId does not exist");
    }
  }

  Future<void> addLikeToComment(String rId, int index) async {
    final DocumentReference restRef = restInformation.doc(rId);
    final DocumentSnapshot restSnapshot = await restRef.get();


    if (restSnapshot.exists) {
      // If the city document exists, get the current comments array
      List<dynamic> currentComments = restSnapshot['comments'] ?? [];

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
        await restRef.update({'comments': updatedComments});
      } else {
        throw Exception("Index $index is out of bounds");
      }
    } else {
      throw Exception("restaurant with ID $rId does not exist");
    }
  }


  Future<void> unlikeComment(String rId, int index) async {
    final DocumentReference restRef = restInformation.doc(rId);
    final DocumentSnapshot restSnapshot = await restRef.get();


    if (restSnapshot.exists) {
      // If the city document exists, get the current comments array
      List<dynamic> currentComments = restSnapshot['comments'] ?? [];

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
        await restRef.update({'comments': updatedComments});
      } else {
        throw Exception("Index $index is out of bounds");
      }
    } else {
      throw Exception("restaurant with ID $rId does not exist");
    }
  }


  List<String> _imageListFromSnapshot(DocumentSnapshot snapshot) {
    List<dynamic> imagesData = snapshot['images'] ?? [];
    List<String> images = imagesData.map((image) => image.toString()).toList();
    return images;
  }

  Stream<List<Comment>> commentsStreamByRestId(String rId) {
    return restInformation.doc(rId).snapshots().map(_commentListFromSnapshot);
  }

  List<Comment> _commentListFromSnapshot(DocumentSnapshot snapshot) {
    List<dynamic> commentData = snapshot['comments'] ?? [];
    List<Comment> comments = commentData.map((comment) => Comment.fromJson(comment)).toList();
    return comments;
  }

  Stream<List<Ratings>> ratingsStreamByRestId(String rId) {
    return restInformation.doc(rId).snapshots().map(_ratingsListFromSnapshot);
  }

  List<Ratings> _ratingsListFromSnapshot(DocumentSnapshot snapshot) {
    List<dynamic> ratingData = snapshot['ratings'] ?? [];
    List<Ratings> ratings = ratingData.map((rating) => Ratings.fromJson(rating)).toList();
    return ratings;
  }
  Future deleteRest(String rid)async{
    final docRest = restInformation.doc(rid);
    await docRest.delete();
  }
}