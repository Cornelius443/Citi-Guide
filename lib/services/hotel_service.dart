import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/city.dart';
import '../models/user.dart';
import 'dart:io';
class HotelService{
  final String? hId;

  HotelService({this.hId});

  final CollectionReference hotelInformation = FirebaseFirestore.instance.collection('hotels');




  Future createHotel(Hotel hotel) async {
    final docHotel = hotelInformation.doc();
    hotel.hId = docHotel.id;
    final json = hotel.toJson();
    await docHotel.set(json);
  }

  Stream<Hotel> get hotelData{
    return hotelInformation.doc(hId).snapshots().map(_hotelDataFromSnapshot);
  }

  Stream<List<Hotel>> get hotels{
    return hotelInformation.snapshots().map(_hotelListFromSnapshot);
  }

  Stream<List<Hotel>> getHotelByAdminId(String adminId) {
    return hotelInformation
        .where('aid', isEqualTo: adminId)
        .snapshots()
        .map(_hotelListFromSnapshot);
  }

  Stream<List<Hotel>> getHotelByCityName(String cName) {
    return hotelInformation
        .where('cName', isEqualTo: cName)
        .snapshots()
        .map(_hotelListFromSnapshot);
  }

  Future<void> removeImgFromAllComments(String img, String newImg) async {
    try {
      // Fetch all documents from the collection
      QuerySnapshot querySnapshot = await hotelInformation.get();

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


  Hotel _hotelDataFromSnapshot(DocumentSnapshot snapshot){
    List<dynamic> commentsData = snapshot['comments'] ?? [];
    List<Comment> comments = commentsData.map((comment) =>
        Comment.fromJson(comment)).toList();
    List<dynamic> ratingData  = snapshot['ratings'] ?? [];
    List<Ratings> ratings = ratingData.map((rating) =>
        Ratings.fromJson(rating)).toList();
    List<dynamic> imagesData = snapshot['images'] ?? [];
    List<String> images = imagesData.map((image) => image.toString()).toList();
    return Hotel(
        hId: snapshot['hId'],
        name: snapshot['name'],
        aid: snapshot['aid'],
        cName: snapshot['cName'],
        desc: snapshot['desc'],
        location: snapshot['location'],
        contact: snapshot['contact'],
        email: snapshot['email'],
        website: snapshot['website'],
        img: snapshot['img'],
        likes: snapshot['likes'],
        comments: comments,
        ratings: ratings,
        images: images
    );

  }


  List<Hotel> _hotelListFromSnapshot(QuerySnapshot snapshot){
    return snapshot.docs.map((doc){
      List<dynamic> commentsData = doc['comments'] ?? [];
      List<Comment> comments = commentsData.map((comment) =>
          Comment.fromJson(comment)).toList();
      List<dynamic> ratingData  = doc['ratings'] ?? [];
      List<Ratings> ratings = ratingData.map((rating) =>
          Ratings.fromJson(rating)).toList();
      List<dynamic> imagesData = doc['images'] ?? [];
      List<String> images = imagesData.map((image) => image.toString()).toList();
      return Hotel(
          hId: doc['hId'],
          name: doc['name'],
          aid: doc['aid'],
          cName: doc['cName'],
          desc: doc['desc'],
          location: doc['location'],
          contact: doc['contact'],
          email: doc['email'],
          website: doc['website'],
          img: doc['img'],
          likes: doc['likes'],
          comments: comments,
          ratings: ratings,
          images: images
      );
    }).toList();
  }


  Future<int> addLikeToHotel(String hId) async {
    final DocumentReference hotelRef = hotelInformation.doc(hId);
    final DocumentSnapshot hotelSnapshot = await hotelRef.get();

    if (hotelSnapshot.exists) {
      // If the city document exists, get the current likes count
      int currentLikes = hotelSnapshot['likes'] ?? 0;

      // Increment the likes count
      int updatedLikes = currentLikes + 1;

      // Update the city document with the updated likes count
      await hotelRef.update({'likes': updatedLikes});
      return updatedLikes;
    } else {
      throw Exception("Hotel with ID $hId does not exist");
    }
  }

  Future<int> unlikeHotel(String hId) async {
    final DocumentReference hotelRef = hotelInformation.doc(hId);
    final DocumentSnapshot hotelSnapshot = await hotelRef.get();
    if (hotelSnapshot.exists) {
      // If the city document exists, get the current likes count
      int currentLikes = hotelSnapshot['likes'] ?? 0;

      // Increment the likes count
      int updatedLikes = currentLikes - 1;

      // Update the city document with the updated likes count
      await hotelRef.update({'likes': updatedLikes});
      return updatedLikes;
    } else {
      throw Exception("Hotel with ID $hId does not exist");
    }
  }

  Future<String> updateHotelDetail(String hid, String desc)
  async{
    try{
      await hotelInformation.doc(hid).update({
        'desc': desc
      });
      return desc;
    }catch(e){
      print(e.toString());
      return "error";
    }
  }

  Future<String> updateHotelImg(String hid, String prevImg, File newImg)
  async{
    try{
      String url = await uploadImgToFirebase(newImg);
      await hotelInformation.doc(hid).update({
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

  Stream<List<String>> imageStreamByHotelId(String hId){
    return hotelInformation.doc(hId).snapshots().map(_imageListFromSnapshot);
  }

  List<String> _imageListFromSnapshot(DocumentSnapshot snapshot) {
    List<dynamic> imagesData = snapshot['images'] ?? [];
    List<String> images = imagesData.map((image) => image.toString()).toList();
    return images;
  }
  Future<void> addImage(String hId, String img) async {
    final DocumentReference hotelRef = hotelInformation.doc(hId);
    final DocumentSnapshot hotelSnapshot = await hotelRef.get();
    if (hotelSnapshot.exists) {
      List<dynamic> currentImages = hotelSnapshot['images'] ?? [];
      List<String> images = currentImages.map((image) => image.toString()).toList();
      images.add(img); // Add the new image to the list
      await hotelRef.update({'images': images});
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

  Future<void> deleteImageFromHotel(String hId, String imageUrl) async {
    final DocumentReference hotelRef = hotelInformation.doc(hId);
    final DocumentSnapshot hotelSnapshot = await hotelRef.get();

    if (hotelSnapshot.exists) {
      List<dynamic> currentImages = hotelSnapshot['images'] ?? [];
      List<String> images = currentImages.map((image) => image.toString()).toList();

      // Check if the image URL exists in the images array
      if (images.contains(imageUrl)) {
        // Remove the image URL from the images array
        images.remove(imageUrl);

        // Update the city document with the updated images array
        await hotelRef.update({'images': images});

        // Delete the image from Firebase Storage
        await deleteImageFromFirebase(imageUrl);

        print('Image deleted successfully');
      } else {
        print('Image URL not found in the images array');
      }
    } else {
      throw Exception("Hotel with ID $hId does not exist");
    }
  }

  Future<void> addReview(String hId, Comment comment, Ratings ratings) async {
    final DocumentReference hotelRef = hotelInformation.doc(hId);
    final DocumentSnapshot hotelSnapshot = await hotelRef.get();
    if (hotelSnapshot.exists){
      List<dynamic> currentComment = hotelSnapshot['comments'] ?? [];

      List<Comment> commentList = currentComment.map((comment) =>
          Comment.fromJson(comment)).toList();
      commentList.add(comment);

      List<dynamic> updatedComments = commentList.map((comments) => comments.toJson()).toList();
      await hotelRef.update({'comments': updatedComments});
      addRating(hId, ratings);
    }else {
      throw Exception("Hotel with ID $hId does not exist");
    }
  }

  Future<void> addRating(String hId, Ratings ratings) async {
    final DocumentReference hotelRef = hotelInformation.doc(hId);
    final DocumentSnapshot hotelSnapshot = await hotelRef.get();
    if (hotelSnapshot.exists) {
      List<dynamic> currentRatings = hotelSnapshot['ratings'] ?? [];

      List<Ratings> ratingList = currentRatings.map((ratings) =>
          Ratings.fromJson(ratings)).toList();
      ratingList.add(ratings);

      List<dynamic> updatedRatings = ratingList.map((ratings) =>
          ratings.toJson()).toList();
      await hotelRef.update({'ratings': updatedRatings});
    }else {
      throw Exception("Hotel with ID $hId does not exist");
    }
  }

  Future<void> deleteCommentByIndex(String hId, int index) async {

    final DocumentReference hotelRef = hotelInformation.doc(hId);
    final DocumentSnapshot hotelSnapshot = await hotelRef.get();

    if (hotelSnapshot.exists) {
      // If the city document exists, get the current comments array
      List<dynamic> currentComments = hotelSnapshot['comments'] ?? [];

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
        await hotelRef.update({'comments': updatedComments});
      } else {
        throw Exception("Index $index is out of bounds");
      }
    } else {
      throw Exception("Hotel with ID $hId does not exist");
    }
  }

  Future<void> addLikeToComment(String hId, int index) async {
    final DocumentReference hotelRef = hotelInformation.doc(hId);
    final DocumentSnapshot hotelSnapshot = await hotelRef.get();

    if (hotelSnapshot.exists) {
      // If the city document exists, get the current comments array
      List<dynamic> currentComments = hotelSnapshot['comments'] ?? [];

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
        await hotelRef.update({'comments': updatedComments});
      } else {
        throw Exception("Index $index is out of bounds");
      }
    } else {
      throw Exception("Hotel with ID $hId does not exist");
    }
  }

  Future<void> unlikeComment(String hId, int index) async {
    final DocumentReference hotelRef = hotelInformation.doc(hId);
    final DocumentSnapshot hotelSnapshot = await hotelRef.get();

    if (hotelSnapshot.exists) {
      // If the city document exists, get the current comments array
      List<dynamic> currentComments = hotelSnapshot['comments'] ?? [];

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
        await hotelRef.update({'comments': updatedComments});
      } else {
        throw Exception("Index $index is out of bounds");
      }
    } else {
      throw Exception("Hotel with ID $hId does not exist");
    }
  }




  Stream<List<Comment>> commentsStreamByHotelId(String hId) {
    return hotelInformation.doc(hId).snapshots().map(_commentListFromSnapshot);
  }

  List<Comment> _commentListFromSnapshot(DocumentSnapshot snapshot) {
    List<dynamic> commentData = snapshot['comments'] ?? [];
    List<Comment> comments = commentData.map((comment) => Comment.fromJson(comment)).toList();
    return comments;
  }

  Stream<List<Ratings>> ratingsStreamByHotelId(String hId) {
    return hotelInformation.doc(hId).snapshots().map(_ratingsListFromSnapshot);
  }

  List<Ratings> _ratingsListFromSnapshot(DocumentSnapshot snapshot) {
    List<dynamic> ratingData = snapshot['ratings'] ?? [];
    List<Ratings> ratings = ratingData.map((rating) => Ratings.fromJson(rating)).toList();
    return ratings;
  }

  Future deleteHotel(String hid)async{
    final docHotel = hotelInformation.doc(hid);
    await docHotel.delete();
  }
}