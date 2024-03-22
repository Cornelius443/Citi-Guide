import 'package:city_guide/services/hotel_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
class LikeHotelComment extends StatefulWidget {
  final String hid;
  final int index;
  const LikeHotelComment({super.key, required this.hid, required this.index});

  @override
  State<LikeHotelComment> createState() => _LikeHotelCommentState();
}

class _LikeHotelCommentState extends State<LikeHotelComment> {
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
  String get _likeKey => 'like_${widget.hid}_${widget.index}';

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
        await hotelService.addLikeToComment(widget.hid, widget.index);
      } else {
        await hotelService.addLikeToComment(widget.hid, widget.index);
      }
      // Store the liked state persistently
      await _prefs.setBool(_likeKey, like);
    } catch (e) {
      showSnack(e.toString());
    }
  }
}
