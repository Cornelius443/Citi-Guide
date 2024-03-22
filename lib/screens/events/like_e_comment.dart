import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/user.dart';
import '../../services/database.dart';
import '../../services/event_service.dart';
class LikeEComment extends StatefulWidget {
  final String eid;
  final int index;
  final Comment comment;
  final String id;
  const LikeEComment({
    super.key,
    required this.eid,
    required this.id,
    required this.comment,
    required this.index
  });

  @override
  State<LikeEComment> createState() => _LikeECommentState();
}

class _LikeECommentState extends State<LikeEComment> {
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

  Future<void> initializePreferences() async {
    _prefs = await SharedPreferences.getInstance();
    liked = _prefs.getBool(_likeKey) ?? false;
    setState(() {}); // Update the UI with the initial liked state
  }

  String get _likeKey => 'like_${widget.eid}_${widget.index}';

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
        final favComment = FavComment(
            id: widget.eid,
            commentId: widget.comment.commentId,
            senderId: widget.comment.senderId,
            senderName: widget.comment.senderName,
            senderText: widget.comment.senderText

        );
        await DatabaseService(uid: widget.id).addFavoriteComment(favComment);
        await eventService.addLikeToComment(widget.eid, widget.index);
      } else {
        final favComment = FavComment(
            id: widget.eid,
            commentId: widget.comment.commentId,
            senderId: widget.comment.senderId,
            senderName: widget.comment.senderName,
            senderText: widget.comment.senderText

        );
        await DatabaseService(uid: widget.id).removeFavoriteComment(favComment);
        await eventService.unlikeComment(widget.eid, widget.index);
      }
      // Store the liked state persistently
      await _prefs.setBool(_likeKey, like);
    } catch (e) {
      showSnack(e.toString());
    }
  }


}
