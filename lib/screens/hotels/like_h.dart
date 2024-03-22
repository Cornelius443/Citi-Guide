import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/city.dart';
import '../../models/user.dart';
import '../../services/database.dart';
import '../../services/hotel_service.dart';
class LikeH extends StatefulWidget {
  final String hid;
  final Hotel hotel;
  final Function updateState;
  final String id;
  const LikeH({super.key,
    required this.hotel,
    required this.hid,
    required this.id,
    required this.updateState
  });

  @override
  State<LikeH> createState() => _LikeHState();
}

class _LikeHState extends State<LikeH> {
  late SharedPreferences _prefs;
  late bool liked = false;
  HotelService hotelService = HotelService();
  late UserData userData;

  @override
  void initState() {
    super.initState();
    initializeLikedState();
    initializePreferences();
  }

  Future<void> initializeLikedState() async {
    // Fetch the user's favorite cities from the database
    userData = await DatabaseService(uid: widget.id).userData.first;

    // Convert userData.favCities to List<FavCity>
    List<FavHotel>? favoriteHotel = userData.favHotels?.map((hData) {
      return FavHotel(
          hId: hData.hId,
          name: hData.name,
          desc: hData.desc,
          location: hData.location,
          img: hData.img

      );
    }).toList();

    // Check if the current city is present in the user's favorite cities
    bool? hotelIsLiked = favoriteHotel?.any((hotel) => hotel.hId == widget.hid);

    setState(() {
      liked = hotelIsLiked ??
          false; // Update liked state based on whether the city is liked by the user
    });
  }

  Future<void> initializePreferences() async {
    _prefs = await SharedPreferences.getInstance();
    liked = _prefs.getBool(_likeKey) ?? false;
    setState(() {}); // Update the UI with the initial liked state
  }

  String get _likeKey => 'like_${widget.hid}';


  void showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(msg)
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        liked ? Icons.favorite : Icons.favorite_border,
        color: liked ? Colors.red : Colors.black,
        size: 29,
      ),
      onPressed: () {
        setState(() {
          liked = !liked;
        });
        _toggleLike(liked);
      },
    );
  }

  Future<void> _toggleLike(bool like) async {
    try {
      if (like) {
        var hotel = FavHotel(
            hId: widget.hid,
            name: widget.hotel.name,
            desc: widget.hotel.desc,
            location: widget.hotel.location,
            img: widget.hotel.img
        );
        await DatabaseService(uid: widget.id).addFavoriteHotel(hotel);
        int likes = await hotelService.addLikeToHotel(widget.hid);
        widget.updateState(likes);
        if (mounted) {
          showSnack("Added to favorites");
        }
      } else {
        var hotel = FavHotel(
            hId: widget.hid,
            name: widget.hotel.name,
            desc: widget.hotel.desc,
            location: widget.hotel.location,
            img: widget.hotel.img
        );
        await DatabaseService(uid: widget.id).removeFavoriteHotel(hotel);
        int likes = await hotelService.unlikeHotel(widget.hid);
        widget.updateState(likes);
        if (mounted) {
          showSnack("Removed from favorites");
        }
      }
      // Store the liked state persistently
      await _prefs.setBool(_likeKey, like);
    } catch (e) {
      showSnack(e.toString());
    }
  }
}