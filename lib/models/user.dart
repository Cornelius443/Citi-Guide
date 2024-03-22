import 'city.dart';

class Users {
  final String uid;

  Users({required this.uid});
}

class UserData {
  final String? uid;
  String? fName;
  String? lName;
  String? img;
  final String? email;
  String? phone;
  String? country;
  final List<FavCity>? favCities;
  final List<FavRest>? favRestaurants;
  final List<FavHotel>? favHotels;
  final List<FavEvent>? favEvents;
  final List<FavAttraction>? favAttractions;
  final List<FavComment>? likedComments;

  UserData({
    this.uid,
    this.fName,
    this.lName,
    this.img = '',
    this.email,
    this.phone,
    this.country,
    this.favCities = const [],
    this.favRestaurants = const [],
    this.favHotels = const [],
    this.favEvents = const [],
    this.favAttractions = const [],
    this.likedComments = const []

  });



}

class FavComment{
  final String? id;
  final String? commentId;
  final String? senderId;
  final String? senderName;
  final String? senderText;
  final String? senderImg;

  FavComment({
    this.id,
    this.commentId,
    this.senderId,
    this.senderName,
    this.senderText,
    this.senderImg
});

  static FavComment fromJson(Map<String, dynamic> json) =>
      FavComment(
        id: json['id'],
        commentId: json['commentId'],
        senderId: json['senderId'],
        senderName: json['senderName'],
        senderText: json['senderText'],
        senderImg: json['senderImg']

      );


  Map<String, dynamic> toJson() => {
    'id': id,
    'senderId': senderId,
    'senderName': senderName,
    'senderText': senderText,
    'commentId': commentId,
    'senderImg': senderImg
  };
}

class Comment{
  final String? cid;
  final String? commentId;
  final String? senderId;
  final String? senderName;
  final String? senderText;
  String? senderImg;
  int likes = 0;

  Comment({
    this.cid,
    this.commentId,
    this.senderId,
    this.senderName,
    this.senderText,
    this.senderImg,
    this.likes = 0
});




  static Comment fromJson(Map<String, dynamic> json) =>
      Comment(
        cid: json['cityId'],
        commentId: json['commentId'],
        senderId: json['senderId'],
        senderName: json['senderName'],
        senderText: json['senderText'],
        senderImg: json['senderImg'],
        likes: json['likes'] ?? 0,
      );


  Map<String, dynamic> toJson() => {
    'cityId': cid,
    'senderId': senderId,
    'senderName': senderName,
    'senderText': senderText,
    'likes': likes,
    'commentId': commentId,
    'senderImg': senderImg

  };


}

class Ratings{
  final String? uid;
  final double? userRating;

  Ratings({this.uid, this.userRating});

  static Ratings fromJson(Map<String, dynamic> json) =>
      Ratings(
        uid: json['uid'],
        userRating: json['userRating']
      );

  Map<String, dynamic> toJson() =>{
    'uid': uid,
    'userRating': userRating
  };
}

