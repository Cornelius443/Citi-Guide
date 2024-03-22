import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/city.dart';
import '../models/user.dart';
import 'dart:io';
class AttractionService{
  final String? id;

  AttractionService({this.id});

  final CollectionReference aInformation = FirebaseFirestore.instance.collection('attractions');


  Stream<List<Attractions>> get attractions{
    return aInformation.snapshots().map(_aListFromSnapshot);
  }

  Stream<Attractions> get attractionData{
    return aInformation.doc(id).snapshots().map(_aDataFromSnapshot);
  }

  Future createAttraction(Attractions attraction)async{
    final docAttraction = aInformation.doc();
    attraction.id = docAttraction.id;
    final json = attraction.toJson();
    await docAttraction.set(json);
  }

  Stream<List<Attractions>> getAttractionsByCityName(String cName) {
    return aInformation
        .where('cName', isEqualTo: cName)
        .snapshots()
        .map(_aListFromSnapshot);
  }

  Stream<List<Attractions>> getAttractionsByAdminId(String aid) {
    return aInformation
        .where('aid', isEqualTo: aid)
        .snapshots()
        .map(_aListFromSnapshot);
  }

  Future<void> removeImgFromAllComments(String img, String newImg)async{
    try {
      // Fetch all documents from the collection
      QuerySnapshot querySnapshot = await aInformation.get();

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


  List<Attractions> _aListFromSnapshot(QuerySnapshot snapshot){
    return snapshot.docs.map((doc){
      List<dynamic> commentsData = doc['comments'] ?? [];
      List<Comment> comments = commentsData.map((comment) =>
          Comment.fromJson(comment)).toList();
      List<dynamic> ratingData  = doc['ratings'] ?? [];
      List<Ratings> ratings = ratingData.map((rating) =>
          Ratings.fromJson(rating)).toList();
      List<dynamic> imagesData = doc['images'] ?? [];
      List<String> images = imagesData.map((image) => image.toString()).toList();
      return Attractions(
          id: doc['id'],
          name: doc['name'],
          aId: doc['aid'],
          cName: doc['cName'],
          desc: doc['desc'],
          location: doc['location'],
          email: doc['email'],
          contact: doc['contact'],
          website: doc['website'],
          img: doc['img'],
          likes: doc['likes'],
          comments: comments,
          ratings: ratings,
          images: images
      );
    }).toList();
  }

  Attractions _aDataFromSnapshot(DocumentSnapshot snapshot){
    List<dynamic> commentsData = snapshot['comments'] ?? [];
    List<Comment> comments = commentsData.map((comment) =>
        Comment.fromJson(comment)).toList();
    List<dynamic> ratingData  = snapshot['ratings'] ?? [];
    List<Ratings> ratings = ratingData.map((rating) =>
        Ratings.fromJson(rating)).toList();
    List<dynamic> imagesData = snapshot['images'] ?? [];
    List<String> images = imagesData.map((image) => image.toString()).toList();
    return Attractions(
        id: snapshot['id'],
        name: snapshot['name'],
        aId: snapshot['aid'],
        cName: snapshot['cName'],
        desc: snapshot['desc'],
        location: snapshot['location'],
        email: snapshot['email'],
        contact: snapshot['contact'],
        website: snapshot['website'],
        img: snapshot['img'],
        likes: snapshot['likes'],
        comments: comments,
        ratings: ratings,
        images: images
    );

  }

  Future<int> addLikeToAttraction(String id) async {
    final DocumentReference aRef = aInformation.doc(id);
    final DocumentSnapshot aSnapshot = await aRef.get();

    if (aSnapshot.exists) {
      // If the city document exists, get the current likes count
      int currentLikes = aSnapshot['likes'] ?? 0;

      // Increment the likes count
      int updatedLikes = currentLikes + 1;

      // Update the city document with the updated likes count
      await aRef.update({'likes': updatedLikes});
      return updatedLikes;
    } else {
      throw Exception("Attraction with ID $id does not exist");
    }
  }

  Future<int> unlikeAttraction(String id) async {
    final DocumentReference aRef = aInformation.doc(id);
    final DocumentSnapshot aSnapshot = await aRef.get();
    if (aSnapshot.exists) {
      // If the city document exists, get the current likes count
      int currentLikes = aSnapshot['likes'] ?? 0;

      // Increment the likes count
      int updatedLikes = currentLikes - 1;

      // Update the city document with the updated likes count
      await aRef.update({'likes': updatedLikes});
      return updatedLikes;
    } else {
      throw Exception("Attraction with ID $id does not exist");
    }
  }

  Future<String> updateAttractionDetail(String aid, String desc)
  async{
    try{
      await aInformation.doc(aid).update({
        'desc': desc
      });
      return desc;
    }catch(e){
      print(e.toString());
      return "error";
    }
  }

  Future<String> updateAttractImg(String aid, String prevImg, File newImg)
  async{
    try{
      String url = await uploadImgToFirebase(newImg);
      await aInformation.doc(aid).update({
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

  Stream<List<String>> imageStreamByAid(String id){
    return aInformation.doc(id).snapshots().map(_imageListFromSnapshot);
  }

  List<String> _imageListFromSnapshot(DocumentSnapshot snapshot) {
    List<dynamic> imagesData = snapshot['images'] ?? [];
    List<String> images = imagesData.map((image) => image.toString()).toList();
    return images;
  }
  Future<void> addImage(String id, String img) async {
    final DocumentReference aRef = aInformation.doc(id);
    final DocumentSnapshot aSnapshot = await aRef.get();
    if (aSnapshot.exists) {
      List<dynamic> currentImages = aSnapshot['images'] ?? [];
      List<String> images = currentImages.map((image) => image.toString()).toList();
      images.add(img); // Add the new image to the list
      await aRef.update({'images': images});
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

  Future<void> deleteImageFromAttraction(String id, String imageUrl) async {
    final DocumentReference aRef = aInformation.doc(id);
    final DocumentSnapshot aSnapshot = await aRef.get();

    if (aSnapshot.exists) {
      List<dynamic> currentImages = aSnapshot['images'] ?? [];
      List<String> images = currentImages.map((image) => image.toString()).toList();

      // Check if the image URL exists in the images array
      if (images.contains(imageUrl)) {
        // Remove the image URL from the images array
        images.remove(imageUrl);

        // Update the city document with the updated images array
        await aRef.update({'images': images});

        // Delete the image from Firebase Storage
        await deleteImageFromFirebase(imageUrl);

        print('Image deleted successfully');
      } else {
        print('Image URL not found in the images array');
      }
    } else {
      throw Exception("Attraction with ID $id does not exist");
    }
  }

  Future<void> addReview(String id, Comment comment, Ratings ratings) async {
    final DocumentReference aRef = aInformation.doc(id);
    final DocumentSnapshot aSnapshot = await aRef.get();
    if (aSnapshot.exists){
      List<dynamic> currentComment = aSnapshot['comments'] ?? [];

      List<Comment> commentList = currentComment.map((comment) =>
          Comment.fromJson(comment)).toList();
      commentList.add(comment);

      List<dynamic> updatedComments = commentList.map((comments) => comments.toJson()).toList();
      await aRef.update({'comments': updatedComments});
      addRating(id, ratings);
    }else {
      throw Exception("Attraction with ID $id does not exist");
    }
  }

  Future<void> addRating(String id, Ratings ratings) async {
    final DocumentReference aRef = aInformation.doc(id);
    final DocumentSnapshot aSnapshot = await aRef.get();
    if (aSnapshot.exists) {
      List<dynamic> currentRatings = aSnapshot['ratings'] ?? [];

      List<Ratings> ratingList = currentRatings.map((ratings) =>
          Ratings.fromJson(ratings)).toList();
      ratingList.add(ratings);
      List<dynamic> updatedRatings = ratingList.map((ratings) =>
          ratings.toJson()).toList();
      await aRef.update({'ratings': updatedRatings});
    }else {
      throw Exception("Attraction with ID $id does not exist");
    }
  }

  Future<void> deleteCommentByIndex(String id, int index) async {

    final DocumentReference aRef = aInformation.doc(id);
    final DocumentSnapshot aSnapshot = await aRef.get();

    if (aSnapshot.exists) {
      // If the city document exists, get the current comments array
      List<dynamic> currentComments = aSnapshot['comments'] ?? [];

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
        await aRef.update({'comments': updatedComments});
      } else {
        throw Exception("Index $index is out of bounds");
      }
    } else {
      throw Exception("Attraction with ID $id does not exist");
    }
  }

  Future<void> addLikeToComment(String id, int index) async {
    final DocumentReference aRef = aInformation.doc(id);
    final DocumentSnapshot aSnapshot = await aRef.get();
    if (aSnapshot.exists) {
      // If the city document exists, get the current comments array
      List<dynamic> currentComments = aSnapshot['comments'] ?? [];

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
        await aRef.update({'comments': updatedComments});
      } else {
        throw Exception("Index $index is out of bounds");
      }
    } else {
      throw Exception("Attraction with ID $id does not exist");
    }
  }

  Future<void> unlikeComment(String id, int index) async {
    final DocumentReference aRef = aInformation.doc(id);
    final DocumentSnapshot aSnapshot = await aRef.get();
    if (aSnapshot.exists) {
      // If the city document exists, get the current comments array
      List<dynamic> currentComments = aSnapshot['comments'] ?? [];

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
        await aRef.update({'comments': updatedComments});
      } else {
        throw Exception("Index $index is out of bounds");
      }
    } else {
      throw Exception("Attraction with ID $id does not exist");
    }
  }


  Stream<List<Comment>> commentsStreamByAid(String aid) {
    return aInformation.doc(aid).snapshots().map(_commentListFromSnapshot);
  }

  List<Comment> _commentListFromSnapshot(DocumentSnapshot snapshot) {
    List<dynamic> commentData = snapshot['comments'] ?? [];
    List<Comment> comments = commentData.map((comment) => Comment.fromJson(comment)).toList();
    return comments;
  }

  Stream<List<Ratings>> ratingsStreamByAid(String aid) {
    return aInformation.doc(aid).snapshots().map(_ratingsListFromSnapshot);
  }

  List<Ratings> _ratingsListFromSnapshot(DocumentSnapshot snapshot) {
    List<dynamic> ratingData = snapshot['ratings'] ?? [];
    List<Ratings> ratings = ratingData.map((rating) => Ratings.fromJson(rating)).toList();
    return ratings;
  }



  Future deleteAttraction(String aid)async{
    final docA = aInformation.doc(aid);
    await docA.delete();
  }


}