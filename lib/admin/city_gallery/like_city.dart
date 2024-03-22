import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/user.dart';
import '../../services/city_service.dart';

class LikeCity extends StatefulWidget {
  final String cid;
  final Function updateState;



  const LikeCity({
    super.key,
    required this.cid,
    required this.updateState,


  });

  @override
  State<LikeCity> createState() => _LikeCityState();
}

class _LikeCityState extends State<LikeCity> {
  late bool liked = false;
  late SharedPreferences _prefs;
  CityService cityService = CityService();
  late UserData userData;

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

  String get _likeKey => 'like_${widget.cid}';

  void showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return  IconButton(
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
        // Increment likes count
        int likes = await cityService.addLikeToCity(widget.cid);
        widget.updateState(likes);
      } else {
        // Decrement likes count
        int likes = await cityService.unlikeCity(widget.cid);
        widget.updateState(likes);
      }
      _prefs.setBool(_likeKey, liked); // Persist the liked state in SharedPreferences
    } catch (e) {
      showSnack(e.toString());
    }
  }
}
