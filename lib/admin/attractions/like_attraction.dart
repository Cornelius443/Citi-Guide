import 'package:city_guide/services/attraction_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
class LikeAttraction extends StatefulWidget {
  final String aid;
  final Function updateState;
  const LikeAttraction({super.key, required this.aid, required this.updateState});

  @override
  State<LikeAttraction> createState() => _LikeAttractionState();
}

class _LikeAttractionState extends State<LikeAttraction> {
  late SharedPreferences _prefs;
  late bool liked = false;
  AttractionService attractionService = AttractionService();


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
  String get _likeKey => 'like_${widget.aid}';


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
        int likes = await attractionService.addLikeToAttraction(widget.aid);
        widget.updateState(likes);
      } else {
        int likes = await attractionService.unlikeAttraction(widget.aid);
        widget.updateState(likes);
      }
      // Store the liked state persistently
      await _prefs.setBool(_likeKey, like);
    } catch (e) {
      showSnack(e.toString());
    }
  }
}
