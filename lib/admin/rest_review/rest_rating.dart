import 'package:city_guide/services/rest_service.dart';
import 'package:flutter/material.dart';
import '../../models/user.dart';

class RestRatingView extends StatefulWidget {
  final String rId;
  const RestRatingView({
    super.key,
    required this.rId
  });

  @override
  State<RestRatingView> createState() => _RestRatingViewState();
}

class _RestRatingViewState extends State<RestRatingView> {
  @override
  Widget build(BuildContext context) {

    RestaurantService restaurantService = RestaurantService();


    return StreamBuilder<List<Ratings>>(
      stream: restaurantService.ratingsStreamByRestId(widget.rId),
      builder: (context, ratingSnapshot) {
        if (ratingSnapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (ratingSnapshot.hasError) {
          return Text('Error: ${ratingSnapshot.error}');
        } else {
          List<Ratings> ratings = ratingSnapshot.data ?? [];
          // Count occurrences of each star rating
          int fiveStarsCount = ratings.where((rating) => rating.userRating == 5).length;
          int fourStarsCount = ratings.where((rating) => rating.userRating == 4).length;
          int threeStarsCount = ratings.where((rating) => rating.userRating == 3).length;
          int twoStarsCount = ratings.where((rating) => rating.userRating == 2).length;
          int oneStarCount = ratings.where((rating) => rating.userRating == 1).length;

          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              buildStarRow(Icons.star, 5, fiveStarsCount),
              buildStarRow(Icons.star, 4, fourStarsCount),
              buildStarRow(Icons.star, 3, threeStarsCount),
              buildStarRow(Icons.star, 2, twoStarsCount),
              buildStarRow(Icons.star, 1, oneStarCount),
            ],
          );
        }
      },
    );
  }

  Widget buildStarRow(IconData icon, int starRating, int count) {
    List<Widget> starWidgets = [];
    // Add filled stars
    for (int i = 0; i < starRating; i++) {
      starWidgets.add(Icon(
        icon,
        color: i < count ? Colors.yellow : Colors.amber,
      ));
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text('$starRating Stars: '),
        Row(
          children: starWidgets,
        ),
        const SizedBox(width: 10.0),
        Text('$count'),
      ],
    );
  }
}
