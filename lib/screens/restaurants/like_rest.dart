import 'package:city_guide/models/city.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/user.dart';
import '../../services/database.dart';
import '../../services/rest_service.dart';
class LikeR extends StatefulWidget {
  final String rid;
  final Restaurant restaurant;
  final Function updateState;
  final String id;
  const LikeR({
    super.key,
  required this.updateState,
    required this.restaurant,
    required this.id,
    required this.rid
  });

  @override
  State<LikeR> createState() => _LikeRState();
}

class _LikeRState extends State<LikeR> {
  late SharedPreferences _prefs;
  late bool liked = false;
  RestaurantService restaurantService = RestaurantService();
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
    List<FavRest>? favoriteRest = userData.favRestaurants?.map((restData) {
      return FavRest(
        rId: restData.rId,
        rName: restData.rName,
        desc: restData.desc,
        rLocation: restData.rLocation,
        rImg: restData.rImg
      );
    }).toList();

    // Check if the current city is present in the user's favorite cities
    bool? restIsLiked = favoriteRest?.any((rest) => rest.rId == widget.rid);

    setState(() {
      liked = restIsLiked ?? false; // Update liked state based on whether the city is liked by the user
    });
  }

  Future<void> initializePreferences() async {
    _prefs = await SharedPreferences.getInstance();
    liked = _prefs.getBool(_likeKey) ?? false;
    setState(() {}); // Update the UI with the initial liked state
  }
  String get _likeKey => 'like_${widget.rid}';


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
        final favRest = FavRest(
          rId: widget.restaurant.rId,
          rName: widget.restaurant.rName,
          rImg: widget.restaurant.rImg,
          desc: widget.restaurant.desc,
          rLocation: widget.restaurant.rLocation
        );
        await DatabaseService(uid: widget.id).addFavoriteRest(favRest);
        int likes = await restaurantService.addLikeToRest(widget.rid);
        widget.updateState(likes);
        if(mounted){
          showSnack("Added to favorites");
        }
      } else {
        final favRest = FavRest(
            rId: widget.restaurant.rId,
            rName: widget.restaurant.rName,
            rImg: widget.restaurant.rImg,
            desc: widget.restaurant.desc,
            rLocation: widget.restaurant.rLocation
        );
        await DatabaseService(uid: widget.id).removeFavoriteRest(favRest);
        int likes = await restaurantService.unlikeRest(widget.rid);
        widget.updateState(likes);
        if(mounted){
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
