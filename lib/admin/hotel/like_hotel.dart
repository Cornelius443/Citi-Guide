import 'package:city_guide/services/hotel_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
class LikeHotel extends StatefulWidget {
  final String hid;
  final Function updateState;
  const LikeHotel({super.key, required this.hid, required this.updateState});

  @override
  State<LikeHotel> createState() => _LikeHotelState();
}

class _LikeHotelState extends State<LikeHotel> {
  late SharedPreferences _prefs;
  late bool liked = false;
  HotelService hotelService = HotelService();


  @override
  void initState() {
    super.initState();
    initializePreferences();
  }


  Future<void> initializePreferences() async {
    _prefs = await SharedPreferences.getInstance();
    liked = _prefs.getBool(_likeKey) ?? false;
    setState(() {}); // Update the UI with the initial liked state
  }
  String get _likeKey => 'like_${widget.hid}';


  void showSnack(String msg){
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
        color: liked ? Colors.red : null,
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
        int likes = await hotelService.addLikeToHotel(widget.hid);
        widget.updateState(likes);
      } else {
        int likes = await hotelService.unlikeHotel(widget.hid);
        widget.updateState(likes);
      }
      // Store the liked state persistently
      await _prefs.setBool(_likeKey, like);
    } catch (e) {
      showSnack(e.toString());
    }
  }
}
