import 'package:city_guide/services/rest_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
class LikeRestComment extends StatefulWidget {
  final String rid;
  final int index;
  const LikeRestComment({super.key, required this.rid, required this.index });

  @override
  State<LikeRestComment> createState() => _LikeRestCommentState();
}

class _LikeRestCommentState extends State<LikeRestComment> {
  late SharedPreferences _prefs;
  late bool liked = false;
  RestaurantService restaurantService = RestaurantService();

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
  String get _likeKey => 'like_${widget.rid}_${widget.index}';
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
        await restaurantService.addLikeToComment(widget.rid, widget.index);
      } else {
       await restaurantService.addLikeToComment(widget.rid, widget.index);
      }
      // Store the liked state persistently
      await _prefs.setBool(_likeKey, like);
    } catch (e) {
      showSnack(e.toString());
    }
  }
}
