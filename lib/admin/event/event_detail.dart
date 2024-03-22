import 'package:city_guide/admin/event/add_image.dart';
import 'package:city_guide/admin/event/event_gallery.dart';
import 'package:city_guide/admin/event/event_rating.dart';
import 'package:city_guide/admin/event/event_review.dart';
import 'package:city_guide/admin/event/event_review_list.dart';
import 'package:city_guide/admin/event/like_event.dart';
import 'package:city_guide/admin/event/update_event_desc.dart';
import 'package:city_guide/admin/event/update_event_img.dart';
import 'package:flutter/material.dart';
import '../../services/admin_service.dart';
import '../../models/city.dart';
import '../../shared/map_screen.dart';

class EventDetails extends StatefulWidget {
  final String name;
  final String eId;
  final String desc;
  final String location;
  final String cName;
  final String email;
  final String website;
  final AdminData admin;
  final Event event;
  const EventDetails({
    super.key,
    required this.name,
    required this.eId,
    required this.desc,
    required this.location,
    required this.cName,
    required this.email,
    required this.website,
    required this.admin,
    required this.event
  });

  @override
  State<EventDetails> createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> with SingleTickerProviderStateMixin{
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
              eId: widget.eId,
              senderId: widget.admin.aid!,
              senderName: widget.admin.fName!,
              senderImg: widget.admin.img,
          )
      );
    });
  }
  void showAddImage(){
    showModalBottomSheet(context: context, isScrollControlled: true, builder: (context){
      return Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          color: Colors.grey[200],
        ),

        padding: EdgeInsets.only(top: 16, left: 16, right: 16, bottom: MediaQuery.of(context).viewInsets.bottom),
        child: AddEventImage(eId: widget.eId),
      );
    });
  }

  void showUploadImage(){
    showModalBottomSheet(context: context, isScrollControlled: true, builder: (context){
      return Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            color: Colors.grey[200],
          ),

          padding: EdgeInsets.only(top: 16, left: 16, right: 16, bottom: MediaQuery.of(context).viewInsets.bottom),
          child: UpdateEventImg(img: widget.event.img, eid: widget.eId, updateImgState: updateImgState)
      );
    });
  }

  void showUpdateDesc(){
    showModalBottomSheet(context: context, isScrollControlled: true, builder: (context){
      return Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            color: Colors.grey[200],
          ),

          padding: EdgeInsets.only(top: 16, left: 16, right: 16, bottom: MediaQuery.of(context).viewInsets.bottom),
          child: UpdateEventDesc(eid: widget.eId, updateDetail: updateDetail),
      );
    });
  }
  void updateState(int likes){
    setState(() {
      widget.event.likes = likes;
    });
  }
  void updateImgState(String url){
    setState(() {
      widget.event.img = url;
    });
  }

  void updateDetail(String desc){
    setState(() {
      widget.event.desc = desc;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
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
      )
          : _tabController.index == 1 ? FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {
          // Action to perform when the FAB is pressed on the Restaurants tab
          showAddImage();
        },
        child: const Icon(Icons.add_a_photo, color: Colors.white,),
      )   : null,
    );



  }

  Widget _buildGallery() {
    return EventGallery(eId: widget.eId, eName: widget.name);
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
                    IconButton(
                        onPressed: (){
                          showUploadImage();
                        },
                        icon: const Icon(Icons.add_a_photo)
                    ),
                    LikeEvent(eid: widget.eId, updateState: updateState),
                    Text("${widget.event.likes}")
                  ],
                ),
                const SizedBox(height: 10.0),
                Text(
                  widget.event.desc,
                  style: const TextStyle(fontSize: 16.0),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                        onPressed: (){
                          showUpdateDesc();
                        },
                        icon: const Icon(Icons.edit))
                  ],
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
                  widget.location,
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
                  widget.cName,
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
                  widget.email,
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
                  widget.website,
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
                EventRatingView(eId: widget.eId),
                const SizedBox(height: 20.0,),
                // Display reviews
                EventReviewList(eId: widget.eId),
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
