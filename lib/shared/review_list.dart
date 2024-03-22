import 'package:city_guide/admin/like_city_comment.dart';
import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/city_service.dart';

class ReviewList extends StatefulWidget {
  final String cid;
  const ReviewList({Key? key, required this.cid}) : super(key: key);

  @override
  State<ReviewList> createState() => _ReviewListState();
}

class _ReviewListState extends State<ReviewList> {

  CityService cityService = CityService();
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
      stream: cityService.commentsStreamByCityId(widget.cid),
      builder: (context, commentSnapshot) {
        if (commentSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
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
                  child: comment.senderImg != null && comment.senderImg!.isNotEmpty
                      ? ClipOval(
                    child: Image.network(
                      comment.senderImg!,
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.error, size: 40.0, color: Colors.red);
                      },
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
                    LikeCItyComment(index: index, cid: widget.cid),
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
      await cityService.deleteCommentByIndex(widget.cid, index);
    } catch (e) {
      showSnack(e.toString());

    }
  }

}
