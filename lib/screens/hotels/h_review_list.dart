import 'package:city_guide/screens/hotels/like_h_comments.dart';
import 'package:flutter/material.dart';
import '../../models/user.dart';
import '../../services/hotel_service.dart';
class HReviewList extends StatefulWidget {
  final String hId;
  final String id;
  const HReviewList({super.key, required this.hId, required this.id});

  @override
  State<HReviewList> createState() => _HReviewListState();
}

class _HReviewListState extends State<HReviewList> {

  HotelService hotelService = HotelService();

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
      stream: hotelService.commentsStreamByHotelId(widget.hId),
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
              LikeHComments(index: index, hid: widget.hId, comment: comment, id: widget.id),
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
