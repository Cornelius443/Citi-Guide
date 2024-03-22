import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/city.dart';
import '../../models/user.dart';
import '../../services/city_service.dart';
import '../../services/database.dart';

class LikeCiti extends StatefulWidget {
  final City city;
  final Function updateState;
  final String id;

  const LikeCiti({super.key,
    required this.id,
    required this.city,
    required this.updateState
  });

  @override
  State<LikeCiti> createState() => _LikeCitiState();
}

class _LikeCitiState extends State<LikeCiti> {
  late bool liked = false;
  late SharedPreferences _prefs;
  CityService cityService = CityService();
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
    List<FavCity>? favoriteCities = userData.favCities?.map((cityData) {
      return FavCity(
        cid: cityData.cid,
        cName: cityData.cName,
        desc: cityData.desc,
        cLocation: cityData.cLocation,
        cImg: cityData.cImg,
      );
    }).toList();

    // Check if the current city is present in the user's favorite cities
    bool? cityIsLiked = favoriteCities?.any((city) => city.cid == widget.city.cid);

    setState(() {
      liked = cityIsLiked ?? false; // Update liked state based on whether the city is liked by the user
    });
  }



  Future<void> initializePreferences() async {
    _prefs = await SharedPreferences.getInstance();
    liked = _prefs.getBool(_likeKey) ?? false;
    setState(() {}); // Update the UI with the initial liked state
  }

  String get _likeKey => 'like_${widget.city.cid}';

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
          // Add the city to favorites
          final favCity = FavCity(
            cid: widget.city.cid,
            cName: widget.city.cName,
            cLocation: widget.city.cLocation,
            desc: widget.city.desc,
            cImg: widget.city.cImg,
          );
          await DatabaseService(uid: widget.id).addFavoriteCity(favCity);
          int likes = await cityService.addLikeToCity(widget.city.cid!);
          widget.updateState(likes);
          if(mounted){
            showSnack("Added to favorites");
          }
        } else {
          // Remove the city from favorites
          final favCity = FavCity(
            cid: widget.city.cid,
            cName: widget.city.cName,
            cLocation: widget.city.cLocation,
            desc: widget.city.desc,
            cImg: widget.city.cImg,
          );
          await DatabaseService(uid: widget.id).removeFavoriteCity(favCity);
          int likes = await cityService.unlikeCity(widget.city.cid!);
          widget.updateState(likes);
          if(mounted){
            showSnack("Removed from favorites");
          }
        }

      _prefs.setBool(_likeKey, liked); // Persist the liked state in SharedPreferences
    } catch (e) {
      showSnack(e.toString());
    }
  }
}
