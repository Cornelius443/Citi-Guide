import 'package:city_guide/screens/events/like_e_comment.dart';
import 'package:flutter/material.dart';
import '../../models/user.dart';
import '../../services/event_service.dart';
class EReviewList extends StatefulWidget {
  final String eId;
  final String id;
  const EReviewList({super.key, required this.id, required this.eId});

  @override
  State<EReviewList> createState() => _EReviewListState();
}

class _EReviewListState extends State<EReviewList> {
  EventService eventService = EventService();
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
      stream: EventService().commentsStreamByEventId(widget.eId),
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
                    LikeEComment(
                        eid: widget.eId,
                        id: widget.id,
                        comment: comment,
                        index: index),
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
}
