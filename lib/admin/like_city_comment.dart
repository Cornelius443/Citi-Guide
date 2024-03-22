import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/city_service.dart';

class LikeCItyComment extends StatefulWidget {
  final String cid;
  final int index;

  const LikeCItyComment({
    super.key,
    required this.index,
    required this.cid,

  });

  @override
  State<LikeCItyComment> createState() => _LikeCItyCommentState();
}

class _LikeCItyCommentState extends State<LikeCItyComment> {
  late SharedPreferences _prefs;
  late bool liked = false;
  CityService cityService = CityService();

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
  String get _likeKey => 'like_${widget.cid}_${widget.index}';


  void showSnack(String msg){
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(msg)
        )
    );
  }
  @override
  Widget build(BuildContext context) {
    return  IconButton(
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
        await cityService.addLikeToComment(widget.cid, widget.index);
      } else {
        await cityService.unlikeComment(widget.cid, widget.index);
      }
      // Store the liked state persistently
      await _prefs.setBool(_likeKey, like);
    } catch (e) {
      showSnack(e.toString());
    }
  }

}
