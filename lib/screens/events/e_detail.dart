import 'package:city_guide/screens/events/e_gallery.dart';
import 'package:city_guide/screens/events/e_review_list.dart';
import 'package:city_guide/screens/events/like_e.dart';
import 'package:flutter/material.dart';
import '../../admin/event/event_rating.dart';
import '../../admin/event/event_review.dart';
import '../../models/city.dart';
import '../../models/user.dart';
import '../../shared/map_screen.dart';
class EDetail extends StatefulWidget {
  final UserData user;
  final Event event;
  const EDetail({super.key,
  required this.event,
    required this.user
  });

  @override
  State<EDetail> createState() => _EDetailState();
}

class _EDetailState extends State<EDetail> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabSelection);
  }
  void _handleTabSelection() {
    setState(() {
      // Rebuild the UI when the tab changes
    });
  }

  void showAddReview(){
    showModalBottomSheet(context: context, isScrollControlled: true, builder: (context){
      return Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            color: Colors.white,
          ),

          padding: EdgeInsets.only(top: 16, left: 16, right: 16, bottom: MediaQuery.of(context).viewInsets.bottom),
          child:   EventReview(
              eId: widget.event.eId,
              senderId: widget.user.uid!,
              senderName: widget.user.fName!,
              senderImg: widget.user.img!,
          )
      );
    });
  }

  void updateState(int likes){
    setState(() {
      widget.event.likes = likes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.event.name!),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) {
                  return const MapScreen();
                },
              ));
            },
            icon: const Icon(Icons.explore, color: Colors.white,),
          )
        ],
      ),

      body: DefaultTabController(
        length: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10.0),
            TabBar(
              indicatorColor: Colors.green,
              dividerColor: Colors.grey[400],
              labelColor: Colors.grey, // Color of the active icon
              unselectedLabelColor: Colors.black,
              controller: _tabController,
              tabs: const [
                Tab(icon: Icon(Icons.description)),
                Tab(icon: Icon(Icons.image)),


              ],

            ),
            Expanded(
              child: TabBarView(
                controller:_tabController,
                children: [
                  _buildDescriptionAndReviews(),
                  _buildGallery()

                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _tabController.index == 0
          ? FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {
          // Action to perform when the FAB is pressed on the Restaurants tab
          showAddReview();
        },
        child: const Icon(Icons.rate_review, color: Colors.white,),
      )  : null,
    );
  }
  Widget _buildGallery() {
    return EGallery(eId: widget.event.eId, eName: widget.event.name!);
  }

  Widget _buildDescriptionAndReviews() {

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20.0),
                Container(
                  width: double.infinity,
                  height: 200, // Set the height of the container as needed
                  decoration: BoxDecoration(
                    color: Colors.grey[200], // Placeholder color while loading
                  ),
                  child: widget.event.img.isNotEmpty
                      ? FadeInImage.assetNetwork(
                    placeholder: 'assets/images/34338d26023e5515f6cc8969aa027bca.gif', // Path to your loading image asset
                    image: widget.event.img,
                    fit: BoxFit.cover, // Adjust the fit as needed
                  )
                      : const Center(
                    child: Text("No Image"),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [

                    LikeE(
                        id: widget.user.uid!,
                        updateState: updateState,
                        event: widget.event,
                        eid: widget.event.eId),
                    Text("${widget.event.likes}")
                  ],
                ),
                const SizedBox(height: 10.0),
                Text(
                  widget.event.desc,
                  style: const TextStyle(fontSize: 16.0),
                ),
                const SizedBox(height: 20.0),
                const Text(
                  'Location:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
                const SizedBox(height: 10.0),
                Text(
                  widget.event.location!,
                  style: const TextStyle(fontSize: 16.0),
                ),
                const SizedBox(height: 20.0),
                const Text(
                  'City:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
                const SizedBox(height: 10.0),
                Text(
                  widget.event.cName!,
                  style: const TextStyle(fontSize: 16.0),
                ),
                const SizedBox(height: 20.0),
                const Text(
                  'Email:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
                const SizedBox(height: 10.0),
                Text(
                  widget.event.email,
                  style: const TextStyle(fontSize: 16.0),
                ),
                const SizedBox(height: 20.0),
                const Text(
                  'Website:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
                const SizedBox(height: 10.0),
                Text(
                  widget.event.website,
                  style: const TextStyle(fontSize: 16.0),
                ),
                const SizedBox(height: 20.0),
                const Text(
                  'Reviews and Ratings:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
                const SizedBox(height: 10.0),
                EventRatingView(eId: widget.event.eId),
                const SizedBox(height: 20.0,),
                // Display reviews
                EReviewList(id: widget.user.uid!, eId: widget.event.eId),
                const SizedBox(height: 100.0,),
              ],
            ),
          ),
        ],
      ),
    );
  }



  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
