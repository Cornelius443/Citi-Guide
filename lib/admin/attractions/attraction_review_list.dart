import 'package:city_guide/admin/attractions/attraction_like_comment.dart';
import 'package:city_guide/services/attraction_service.dart';
import 'package:flutter/material.dart';
import '../../models/user.dart';

class AttractionReviewList extends StatefulWidget {
  final String aId;
  const AttractionReviewList({super.key, required this.aId});

  @override
  State<AttractionReviewList> createState() => _AttractionReviewListState();
}

class _AttractionReviewListState extends State<AttractionReviewList> {
  AttractionService attractionService = AttractionService();

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
      stream: attractionService.commentsStreamByAid(widget.aId),
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
                  AttractionLikeComment(id: widget.aId, index: index),
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
      await attractionService.deleteCommentByIndex(widget.aId, index);
    } catch (e) {
      showSnack(e.toString());

    }
  }
}
