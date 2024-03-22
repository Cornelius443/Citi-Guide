import 'package:city_guide/services/rest_service.dart';
import 'package:flutter/material.dart';

import '../../models/user.dart';
import '../../services/database.dart';
class LikeRComments extends StatefulWidget {
  final String rId;
  final int index;
  final Comment comment;
  final String id;
  const LikeRComments({
    super.key,
    required this.rId,
    required this.index,
    required this.comment,
    required this.id
  });

  @override
  State<LikeRComments> createState() => _LikeRCommentsState();
}

class _LikeRCommentsState extends State<LikeRComments> {
  late bool liked = false;
  RestaurantService restaurantService = RestaurantService();
  late UserData userData;
  @override
  void initState() {
    super.initState();
    initializeLikedState();

  }

  void showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
      ),
    );
  }

  Future<void> initializeLikedState() async {
    try {
      // Fetch the user's favorite comments from the database
      userData = await DatabaseService(uid: widget.id).userData.first;

      // Check if the current comment is present in the user's favorite comments
      bool commentIsLiked = userData.likedComments?.any((comment) =>
      comment.commentId == widget.comment.commentId) ?? false;

      setState(() {
        liked = commentIsLiked; // Update liked state based on whether the comment is liked by the user
      });
    } catch (e) {
      // Handle any errors that occur during initialization
      if(mounted){
        showSnack('Error initializing liked state: $e');
      }
    }
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
        // Add the comment to favorites
        final favComment = FavComment(
            id: widget.rId,
            commentId: widget.comment.commentId,
            senderId: widget.comment.senderId,
            senderName: widget.comment.senderName,
            senderText: widget.comment.senderText

        );
        await DatabaseService(uid: widget.id).addFavoriteComment(favComment);
        await restaurantService.addLikeToComment(widget.rId, widget.index);
      } else {
        DatabaseService databaseService = DatabaseService(uid: widget.id);
        final favComment = FavComment(
            id: widget.rId,
            commentId: widget.comment.commentId,
            senderId: widget.comment.senderId,
            senderName: widget.comment.senderName,
            senderText: widget.comment.senderText

        );
        // Remove the comment from favorites
        await databaseService.removeFavoriteComment(favComment);
        await restaurantService.unlikeComment(widget.rId, widget.index);
      }

    } catch (e) {
      showSnack(e.toString());
    }
  }
}
