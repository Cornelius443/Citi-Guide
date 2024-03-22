import 'package:city_guide/services/event_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
class LikeEvent extends StatefulWidget {
  final String eid;
  final Function updateState;
  const LikeEvent({super.key, required this.eid, required this.updateState});

  @override
  State<LikeEvent> createState() => _LikeEventState();
}

class _LikeEventState extends State<LikeEvent> {
  late SharedPreferences _prefs;
  late bool liked = false;
  EventService eventService = EventService();

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
  String get _likeKey => 'like_${widget.eid}';


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
        int likes = await eventService.addLikeToEvent(widget.eid);
        widget.updateState(likes);
      } else {
        int likes = await eventService.unlikeEvent(widget.eid);
        widget.updateState(likes);
      }
      // Store the liked state persistently
      await _prefs.setBool(_likeKey, like);
    } catch (e) {
      showSnack(e.toString());
    }
  }
}
