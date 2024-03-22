import 'package:city_guide/admin/rest_review/like_rest_comment.dart';
import 'package:city_guide/services/rest_service.dart';
import 'package:flutter/material.dart';

import '../../models/user.dart';

class RestReviewList extends StatefulWidget {
  final String rId;
  const RestReviewList({super.key, required this.rId});

  @override
  State<RestReviewList> createState() => _RestReviewListState();
}

class _RestReviewListState extends State<RestReviewList> {

  RestaurantService restaurantService = RestaurantService();
  void showSnack(String msg){
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(msg)
        )
    );
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Comment>>(
      stream: restaurantService.commentsStreamByRestId(widget.rId),
      builder: (context, commentSnapshot) {
        if (commentSnapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (commentSnapshot.hasError) {
          return Text('Error: ${commentSnapshot.error}');
        } else {
          // Get the list of comments
          List<Comment> comments = commentSnapshot.data ?? [];

          if (comments.isEmpty) {
            // If there are no comments, display a message
            return const Center(
              child: Text('No review available.'),
            );
          }
          // Map each comment to a ListTile
          List<Widget> commentTiles = comments.asMap().entries.map((entry) {
            int index = entry.key;
            Comment comment = entry.value;
            return Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 25.0,
                  child: comment.senderImg!.isNotEmpty
                      ? ClipOval(
                    child: Image.network(
                      comment.senderImg!,
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                    ),
                  )
                      : const Icon(Icons.person_pin, size: 60.0,),
                ),
                title: Text(comment.senderName!),
                subtitle: Text(comment.senderText!),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        _deleteComment(index);
                      },
                    ),
                    LikeRestComment(rid: widget.rId, index: index),
                    Text("${comment.likes}")
                  ],
                ),
              ),
            );
          }).toList();


          // Return a ListView containing the list of comment tiles
          return ListView(
            shrinkWrap: true,
            children: commentTiles,
          );
        }
      },
    );
  }

  Future<void> _deleteComment(int index) async {
    try {
      await restaurantService.deleteCommentByIndex(widget.rId, index);
    } catch (e) {
      showSnack(e.toString());

    }
  }
}
