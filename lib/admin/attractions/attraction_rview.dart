import 'package:city_guide/services/attraction_service.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../models/user.dart';
import '../../shared/constants.dart';
class AttractionReview extends StatefulWidget {
  final String aId;
  final String senderId;
  final String senderName;
  final String senderImg;

  const AttractionReview({
    super.key,
    required this.aId,
    required this.senderId,
    required this.senderName,
    required this.senderImg
  });

  @override
  State<AttractionReview> createState() => _AttractionReviewState();
}

class _AttractionReviewState extends State<AttractionReview> {
  double _userRating = 0.0;
  String comment = "";
  String error = "";
  bool loading = false;
  final Uuid uuid = const Uuid();
  final TextEditingController _reviewController = TextEditingController();
  void showSnack(String msg){
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(msg)
        )
    );
  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Text(
              'Add Your Review:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
            const SizedBox(height: 10.0),
            TextField(
                controller: _reviewController,
                onChanged: (val){
                  setState(() {
                    comment = val;
                  });
                },
                decoration: addInputDecoration.copyWith(
                    hintText: "your Review",
                    prefixIcon: const Icon(Icons.reviews_outlined)
                )
            ),
            Text(
              error,
              style: const TextStyle(
                  color: Colors.red
              ),
            ),
            const SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Your Rating:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                const SizedBox(height: 5.0),
                // Star rating
                _buildStarRating(),
              ],
            ),
            const SizedBox(height: 10.0),
            loading ? const Text("Updating..") : ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[100],
              ),
              onPressed: () async {
                setState(() {
                  loading = true;
                });
                if(comment == ""){
                  setState(() {
                    error = "Add review";
                    loading = false;
                  });
                }else{
                  final review = Comment(
                      cid: widget.aId,
                      commentId: uuid.v4(),
                      senderId: widget.senderId,
                      senderName: widget.senderName,
                      senderText: comment,
                      senderImg: widget.senderImg
                  );
                  final rating = Ratings(
                      uid: widget.senderId,
                      userRating: _userRating
                  );

                  await AttractionService().addReview(widget.aId, review, rating);
                 if(mounted){
                   Navigator.pop(context);
                   showSnack("Review sent");
                 }
                }
              },
              child: const Text('Submit',
                style: TextStyle(color: Colors.black),),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  Widget _buildStarRating() {
    return Row(
      children: List.generate(
        5,
            (index) => IconButton(
          icon: Icon(
            index < _userRating ? Icons.star : Icons.star_border,
            color: Colors.amber,
          ),
          onPressed: () {
            setState(() {
              _userRating = index + 1.0;
            });
          },
        ),
      ),
    );
  }
}
