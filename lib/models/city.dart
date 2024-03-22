import 'user.dart';

class City{
  String? cid = '';
  final String? aid;
  final String? cName;
  String desc;
  final String? cLocation;
  String cImg;
  int likes = 0;
  final List<Comment>? comment;
  final List<Restaurant>? restaurants;
  final List<Hotel>? hotels;
  final List<Ratings>? ratings;
  final List<String>? images;


  City({

    this.cid = '',
    this.aid,
    this.cName,
    this.desc = '',
    this.cLocation,
    this.cImg = '',
    this.likes = 0,
    this.comment = const [],
    this.restaurants = const [],
    this.hotels = const [],
    this.ratings = const [],
    this.images = const [],


});

  static City fromJson(Map<String, dynamic> json){
    List<dynamic> commentsData = json['comment'] ?? [];
    List<Comment> comments = commentsData.map((comment) =>
        Comment.fromJson(comment)).toList();
    List<dynamic> ratingData  = json['ratings'] ?? [];
    List<Ratings> ratings = ratingData.map((rating) =>
    Ratings.fromJson(rating)).toList();
    List<dynamic> imagesData = json['images'] ?? [];
    List<String> images = imagesData.map((image) => image.toString()).toList();
    return City(
        cid: json['id'],
        aid: json['aid'],
        cName: json['cName'],
        desc: json['desc'],
        cLocation: json['location'],
        cImg: json['img'],
        likes: json['likes'] ?? 0,
        comment: comments,
        ratings: ratings,
        images: images,

    );
  }

  Map<String, dynamic> toJson() =>{
    'id': cid,
    'aid': aid,
    'cName': cName,
    'desc': desc,
    'location': cLocation,
    'img': cImg,
    'images': images,
    'likes': likes,
    'comment': comment,
    'ratings': ratings,

  };

}

class FavCity{
  String? cid = '';
  final String? cName;
  final String? desc;
  final String? cLocation;
  final String? cImg;

  FavCity({
    this.cid = '',
    this.cName,
    this.desc,
    this.cLocation,
    this.cImg
});

  Map<String, dynamic> toJson() =>{
    'cid': cid,
    'cName': cName,
    'desc': desc,
    'location': cLocation,
    'img': cImg
  };

  static FavCity fromJson(Map<String, dynamic> json){
    return FavCity(
      cid: json['cid'],
      cName: json['cName'],
      desc: json['desc'],
      cLocation: json['location'],
      cImg: json['img']
    );
  }
}

class FavRest{

  String? rId = '';
  final String? rName;
  String desc;
  final String? rLocation;
  String rImg;

  FavRest({
    this.rId = '',
    this.rName,
    this.desc = '',
    this.rLocation,
    this.rImg = '',
});

  Map<String, dynamic> toJson()=>{
    'rid': rId,
    'rName': rName,
    'desc': desc,
    'location': rLocation,
    'rImg': rImg
  };


  static FavRest fromJson(Map<String, dynamic> json){
    return FavRest(
       rId: json['rid'],
       rName: json['rName'],
       desc: json['desc'],
       rLocation: json['location'],
       rImg: json['rImg']

    );
  }


}

class Restaurant{
  String? rId = '';
  final String? rName;
  final String? aid;
  final String? cName;
  String desc;
  final String? rLocation;
  final String contact;
  final String email;
  final String website;
  String rImg;
  int likes = 0;
  final List<Comment>? comments;
  final List<Ratings>? ratings;
  final List<String>? images;


  Restaurant({
    this.rId = '',
    this.rName,
    this.aid,
    this.cName,
    this.desc = '',
    this.rLocation,
    this.contact = '',
    this.email = '',
    this.rImg = '',
    this.website = '',
    this.likes = 0,
    this.comments = const [],
    this.ratings = const [],
    this.images = const []

});

  static Restaurant fromJson(Map<String, dynamic> json){
    List<dynamic> commentsData = json['comments'] ?? [];
    List<Comment> comments = commentsData.map((comment) =>
        Comment.fromJson(comment)).toList();
    List<dynamic> ratingsData = json['ratings'] ?? [];
    List<Ratings> ratings = ratingsData.map((rating) =>
        Ratings.fromJson(rating)).toList();
    List<dynamic> imagesData = json['images'] ?? [];
    List<String> images = imagesData.map((image) => image.toString()).toList();
    return Restaurant(
        rId: json['rId'],
        rName: json['rName'],
        aid: json['aid'],
        cName: json['cName'],
        desc: json['desc'],
        rLocation: json['location'],
        contact: json['contact'],
        email: json['email'],
        website: json['website'],
        rImg: json['img'],
        likes: json['likes'] ?? 0,
        comments: comments,
        ratings: ratings,
        images: images


    );
  }

  Map<String, dynamic> toJson() =>{
    'rId': rId,
    'rName': rName,
    'aid': aid,
    'cName': cName,
    'desc': desc,
    'location': rLocation,
    'contact': contact,
    'email': email,
    'website': website,
    'img': rImg,
    'likes': likes,
    'comments': comments,
    'ratings': ratings,
    'images': images
  };


}

class FavHotel{
  String hId = '';
  final String? name;
  String desc;
  final String? location;
  String img;

  FavHotel({
    this.hId = '',
    this.name,
    this.desc = '',
    this.location,
    this.img = ''
});

  Map<String, dynamic> toJson()=>{
    'hid': hId,
    'name': name,
    'desc': desc,
    'location': location,
    'img': img
  };

  static FavHotel fromJson(Map<String, dynamic> json){
    return FavHotel(
      hId: json['hid'],
      name: json['name'],
      desc: json['desc'],
      location: json['location'],
      img: json['img']
    );
  }
}

class Hotel {
  String hId = '';
  final String? name;
  final String? aid;
  final String? cName;
  String desc;
  final String? location;
  String contact;
  String email;
  String website;
  String img;
  int likes = 0;
  final List<Comment>? comments;
  final List<Ratings>? ratings;
  final List<String>? images;

  Hotel({
    this.hId = '',
    this.name,
    this.aid,
    this.cName,
    this.desc = '',
    this.location,
    this.contact = '',
    this.email = '',
    this.website = '',
    this.img = '',
    this.likes = 0,
    this.comments = const [],
    this.ratings = const [],
    this.images = const []
  });

  static Hotel fromJson(Map<String, dynamic> json){
    List<dynamic> commentData = json['comments'] ?? [];
    List<Comment> comments = commentData.map((comment) =>
        Comment.fromJson(comment)).toList();
    List<dynamic> ratingsData = json['ratings'] ?? [];
    List<Ratings> ratings = ratingsData.map((rating) =>
        Ratings.fromJson(rating)).toList();
    List<dynamic> imagesData = json['images'] ?? [];
    List<String> images = imagesData.map((image) => image.toString()).toList();
    return Hotel(
        hId: json['hId'],
        name: json['name'],
        aid: json['aid'],
        cName: json['cName'],
        desc: json['desc'],
        location: json['location'],
        contact: json['contact'],
        email: json['email'],
        website: json['website'],
        img: json['img'],
        likes: json['likes'] ?? 0,
        comments: comments,
        ratings: ratings,
        images: images
    );
  }

  Map<String, dynamic> toJson() =>{
    'hId': hId,
    'name': name,
    'aid': aid,
    'cName': cName,
    'desc': desc,
    'location': location,
    'contact': contact,
    'email': email,
    'website': website,
    'img': img,
    'likes': likes,
    'comments': comments,
    'ratings': ratings,
    'images': images
  };

}

class FavEvent{
  String eId = '';
  final String? name;
  String desc;
  final String? location;
  String img;

  FavEvent({
    this.eId = '',
    this.name,
    this.desc = '',
    this.location,
    this.img = ''
});

  Map<String, dynamic> toJson() =>{
    'eid': eId,
    'name': name,
    'desc': desc,
    'location': location,
    'img': img
  };

  static FavEvent fromJson(Map<String, dynamic> json){
    return FavEvent(
      eId: json['eid'],
      name: json['name'],
      desc: json['desc'],
      location: json['location'],
      img: json['img']
    );
  }
}

class Event{
  String eId = '';
  final String? name;
  final String? aId;
  final String? cName;
  String email;
  String website;
  String desc;
  final String? location;
  String img;
  int likes = 0;
  final List<Comment>? comments;
  final List<Ratings>? ratings;
  final List<String>? images;


  Event({
    this.eId = '',
    this.name,
    this.aId,
    this.cName,
    this.desc = '',
    this.location,
    this.email = '',
    this.website = '',
    this.img = '',
    this.likes = 0,
    this.comments = const [],
    this.ratings = const [],
    this.images = const [],

  });



  static Event fromJson(Map<String, dynamic> json){
    List<dynamic> commentData = json['comments'] ?? [];
    List<Comment> comments = commentData.map((comment) =>
        Comment.fromJson(comment)).toList();
    List<dynamic> ratingsData = json['ratings'] ?? [];
    List<Ratings> ratings = ratingsData.map((rating) =>
        Ratings.fromJson(rating)).toList();
    List<dynamic> imagesData = json['images'] ?? [];
    List<String> images = imagesData.map((image) => image.toString()).toList();
    return Event(
      eId: json['eId'],
      name: json['name'],
      aId: json['aid'],
      cName: json['cName'],
      desc: json['desc'],
      location: json['location'],
      email: json['email'],
      website: json['website'],
      img: json['img'],
      likes: json['likes'] ?? 0,
      comments: comments,
      ratings: ratings,
      images: images

    );
  }


  Map<String, dynamic> toJson()=>{
    'eId': eId,
    'name': name,
    'aid': aId,
    'cName': cName,
    'desc': desc,
    'location': location,
    'email': email,
    'website': website,
    'img': img,
    'likes': likes,
    'comments': comments,
    'ratings': ratings,
    'images': images,

  };

}

class FavAttraction{
  String id = '';
  final String? name;
  String desc;
  final String? location;
  String img;

  FavAttraction({
    this.id = '',
    this.name,
    this.desc = '',
    this.location,
    this.img = ''
});


  Map<String, dynamic> toJson()=>{
    'id': id,
    'name': name,
    'desc': desc,
    'location': location,
    'img': img
  };

  static FavAttraction fromJson(Map<String, dynamic> json){
    return FavAttraction(
      id: json['id'],
      name: json['name'],
      desc: json['desc'],
      location: json['location'],
      img: json['img']
    );
  }
}


class Attractions{
  String id = '';
  final String? name;
  final String? aId;
  final String? cName;
  String desc;
  final String? location;
  String email;
  String contact;
  String website;
  String img;
  int likes = 0;
  final List<Comment>? comments;
  final List<Ratings>? ratings;
  final List<String>? images;

  Attractions({
    this.id = '',
    this.name,
    this.aId,
    this.cName,
    this.desc = '',
    this.location,
    this.email = '',
    this.contact = '',
    this.website = '',
    this.img = '',
    this.likes = 0,
    this.comments = const [],
    this.ratings = const [],
    this.images = const [],
});



  static Attractions fromJson(Map<String, dynamic> json){
    List<dynamic> commentData = json['comments'] ?? [];
    List<Comment> comments = commentData.map((comment) =>
        Comment.fromJson(comment)).toList();
    List<dynamic> ratingsData = json['ratings'] ?? [];
    List<Ratings> ratings = ratingsData.map((rating) =>
        Ratings.fromJson(rating)).toList();
    List<dynamic> imagesData = json['images'] ?? [];
    List<String> images = imagesData.map((image) => image.toString()).toList();
    return Attractions(
      id: json['id'],
      name: json['name'],
      aId: json['aid'],
      cName: json['cName'],
      desc: json['desc'],
      location: json['location'],
      email: json['email'],
      contact: json['contact'],
      website: json['website'],
      img: json['img'],
      likes: json['likes'] ?? 0,
      comments: comments,
      ratings: ratings,
      images: images
    );
  }

  Map<String, dynamic> toJson()=>{
    'id': id,
    'name': name,
    'aid': aId,
    'cName': cName,
    'desc': desc,
    'location': location,
    'email': email,
    'contact': contact,
    'website': website,
    'img': img,
    'likes': likes,
    'comments': comments,
    'ratings': ratings,
    'images': images,
  };


}