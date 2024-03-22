import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/city.dart';
import '../../models/user.dart';
import '../../services/database.dart';
import '../../services/event_service.dart';
class LikeE extends StatefulWidget {
  final String eid;
  final Function updateState;
  final Event event;
  final String id;
  const LikeE({
    super.key,
    required this.id,
    required this.updateState,
    required this.event,
    required this.eid

  });

  @override
  State<LikeE> createState() => _LikeEState();
}

class _LikeEState extends State<LikeE> {
  late SharedPreferences _prefs;
  late bool liked = false;
  EventService eventService = EventService();
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
    List<FavEvent>? favoriteEvent = userData.favEvents?.map((eData) {
      return FavEvent(
        eId: eData.eId,
        name: eData.name,
        desc: eData.desc,
        location: eData.location,
        img: eData.img
      );
    }).toList();
    // Check if the current city is present in the user's favorite cities
    bool? eventIsLiked = favoriteEvent?.any((event) => event.eId== widget.eid);
    setState(() {
      liked = eventIsLiked ??
          false; // Update liked state based on whether the city is liked by the user
    });
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
        var event = FavEvent(
          eId: widget.eid,
          name: widget.event.name,
          desc: widget.event.desc,
          location: widget.event.location,
          img: widget.event.img
        );
        await DatabaseService(uid: widget.id).addFavoriteEvent(event);
        int likes = await eventService.addLikeToEvent(widget.eid);
        widget.updateState(likes);
        if (mounted) {
          showSnack("Added to favorites");
        }
      } else {
        var event = FavEvent(
            eId: widget.eid,
            name: widget.event.name,
            desc: widget.event.desc,
            location: widget.event.location,
            img: widget.event.img
        );
        await DatabaseService(uid: widget.id).removeFavoriteEvent(event);
        int likes = await eventService.unlikeEvent(widget.eid);
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
