import 'package:city_guide/screens/attracts/a_gallery.dart';
import 'package:city_guide/screens/attracts/a_review_list.dart';
import 'package:city_guide/screens/attracts/like_a.dart';
import 'package:flutter/material.dart';
import '../../admin/attractions/attraction_rating.dart';
import '../../admin/attractions/attraction_rview.dart';
import '../../models/city.dart';
import '../../models/user.dart';
import '../../shared/map_screen.dart';
class ADetail extends StatefulWidget {
  final UserData user;
  final Attractions attractions;
  const ADetail({super.key,
  required this.user,
    required this.attractions
  });

  @override
  State<ADetail> createState() => _ADetailState();
}

class _ADetailState extends State<ADetail> with SingleTickerProviderStateMixin{
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
          child: AttractionReview(
              aId: widget.attractions.id,
              senderId: widget.user.uid!,
              senderName: widget.user.fName!,
              senderImg: widget.user.img!,
          )
      );
    });
  }

  void updateState(int likes){
    setState(() {
      widget.attractions.likes = likes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.attractions.name!),
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
      ) : null,
    );
  }
  Widget _buildGallery() {
    return AGallery(name: widget.attractions.name!, id: widget.attractions.id);
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
                  child: widget.attractions.img.isNotEmpty
                      ? FadeInImage.assetNetwork(
                    placeholder: 'assets/images/34338d26023e5515f6cc8969aa027bca.gif', // Path to your loading image asset
                    image: widget.attractions.img,
                    fit: BoxFit.cover, // Adjust the fit as needed
                  )
                      : const Center(
                    child: Text("No Image"),
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [

                    LikeA(
                        attraction: widget.attractions,
                        id: widget.user.uid!,
                        updateState: updateState,
                        aid: widget.attractions.id),
                    Text("${widget.attractions.likes}")
                  ],
                ),
                const SizedBox(height: 10.0),
                Text(
                  widget.attractions.desc,
                  style: const TextStyle(fontSize: 16.0),
                ),

                const SizedBox(height: 5.0),
                const Text(
                  'Location:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
                const SizedBox(height: 10.0),
                Text(
                  widget.attractions.location!,
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
                  widget.attractions.cName!,
                  style: const TextStyle(fontSize: 16.0),
                ),
                const SizedBox(height: 20.0),
                const Text(
                  'Contact:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
                const SizedBox(height: 10.0),
                Text(
                  widget.attractions.contact,
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
                  widget.attractions.email,
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
                  widget.attractions.website,
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
                AttractionRatingView(aId: widget.attractions.id),
                const SizedBox(height: 20.0,),
                // Display reviews
               AReviewList(id: widget.user.uid!, aId: widget.attractions.id),
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
