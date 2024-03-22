
import '../../models/user.dart';
import 'package:flutter/material.dart';
import '../../services/city_service.dart';
import '../../services/database.dart';
class LikeCitiComment extends StatefulWidget {
  final String cid;
  final int index;
  final Comment comment;
  final String id;

  const LikeCitiComment({
    super.key,
    required this.cid,
    required this.index,
    required this.comment,
    required this.id,
  });

  @override
  State<LikeCitiComment> createState() => _LikeCitiCommentState();
}

class _LikeCitiCommentState extends State<LikeCitiComment> {
  late bool liked = false;

  CityService cityService = CityService();
  late UserData userData;

  @override
  void initState() {
    super.initState();
    initializeLikedState();

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





  void showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
      ),
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
        // Add the comment to favorites
        final favComment = FavComment(
          id: widget.cid,
          commentId: widget.comment.commentId,
          senderId: widget.comment.senderId,
          senderName: widget.comment.senderName,
          senderText: widget.comment.senderText

        );
        await DatabaseService(uid: widget.id).addFavoriteComment(favComment);
        await cityService.addLikeToComment(widget.cid, widget.index);
      } else {
        DatabaseService databaseService = DatabaseService(uid: widget.id);
        final favComment = FavComment(
            id: widget.cid,
            commentId: widget.comment.commentId,
            senderId: widget.comment.senderId,
            senderName: widget.comment.senderName,
            senderText: widget.comment.senderText

        );
        // Remove the comment from favorites
        await databaseService.removeFavoriteComment(favComment);
        await cityService.unlikeComment(widget.cid, widget.index);
      }

    } catch (e) {
      showSnack(e.toString());
    }
  }
}
