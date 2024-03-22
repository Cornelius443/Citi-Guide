import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/city.dart';
import '../../models/user.dart';
import '../../services/attraction_service.dart';
import '../../services/database.dart';
class LikeA extends StatefulWidget {
  final String aid;
  final Function updateState;
  final Attractions attraction;
  final String id;
  const LikeA({
    super.key,
    required this.attraction,
    required this.id,
    required this.updateState,
    required this.aid
  });

  @override
  State<LikeA> createState() => _LikeAState();
}

class _LikeAState extends State<LikeA> {
  late SharedPreferences _prefs;
  late bool liked = false;
  AttractionService attractionService = AttractionService();
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
    List<FavAttraction>? favoriteA = userData.favAttractions?.map((aData) {
      return FavAttraction(
        id: aData.id,
        name: aData.name,
        location: aData.location,
        desc: aData.desc,
        img: aData.img
      );
    }).toList();
    // Check if the current city is present in the user's favorite cities
    bool? aIsLiked = favoriteA?.any((attract) => attract.id == widget.aid);
    setState(() {
      liked = aIsLiked ??
          false; // Update liked state based on whether the city is liked by the user
    });
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
        var attraction = FavAttraction(
          id: widget.aid,
          name: widget.attraction.name,
          desc: widget.attraction.desc,
          location: widget.attraction.location,
          img: widget.attraction.img
        );
        await DatabaseService(uid: widget.id).addFavoriteAttraction(attraction);
        int likes = await attractionService.addLikeToAttraction(widget.aid);
        widget.updateState(likes);
        if (mounted) {
          showSnack("Added to favorites");
        }
      } else {
        var attraction = FavAttraction(
            id: widget.aid,
            name: widget.attraction.name,
            desc: widget.attraction.desc,
            location: widget.attraction.location,
            img: widget.attraction.img
        );
        await DatabaseService(uid: widget.id).removeFavoriteAttraction(attraction);
        int likes = await attractionService.unlikeAttraction(widget.aid);
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
