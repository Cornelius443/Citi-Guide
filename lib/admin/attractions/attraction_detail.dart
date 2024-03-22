import 'package:city_guide/admin/attractions/add_image.dart';
import 'package:city_guide/admin/attractions/attraction_gallery.dart';
import 'package:city_guide/admin/attractions/attraction_rating.dart';
import 'package:city_guide/admin/attractions/attraction_review_list.dart';
import 'package:city_guide/admin/attractions/attraction_rview.dart';
import 'package:city_guide/admin/attractions/like_attraction.dart';
import 'package:city_guide/admin/attractions/update_attraction_desc.dart';
import 'package:city_guide/admin/attractions/update_attraction_img.dart';
import 'package:flutter/material.dart';
import '../../models/city.dart';
import '../../services/admin_service.dart';
import '../../shared/map_screen.dart';
class AttractionDetail extends StatefulWidget {
  final String name;
  final String aId;
  final String desc;
  final String email;
  final String cName;
  final String contact;
  final String location;
  final String website;
  final AdminData admin;
  final Attractions attraction;
  const AttractionDetail({
    super.key,
    required this.name,
    required this.aId,
    required this.email,
    required this.cName,
    required this.website,
    required this.contact,
    required this.location,
    required this.admin,
    required this.desc,
    required this.attraction
  });

  @override
  State<AttractionDetail> createState() => _AttractionDetailState();
}

class _AttractionDetailState extends State<AttractionDetail> with SingleTickerProviderStateMixin {
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
              aId: widget.aId,
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
        child: AddAttractionImage(id: widget.aId)
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
          child: UpdateAttractionImg(aid: widget.aId, img: widget.attraction.img, updateImgState: updateImgState)
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
        child: UpdateAttractionDesc(aid: widget.aId, updateDetail: updateDetail)
      );
    });
  }
  void updateState(int likes){
    setState(() {
      widget.attraction.likes = likes;
    });
  }

  void updateImgState(String url){
    setState(() {
      widget.attraction.img = url;
    });
  }

  void updateDetail(String desc){
    setState(() {
      widget.attraction.desc = desc;
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
    return AttractionGallery(id: widget.aId, name: widget.name);
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
                  child: widget.attraction.img.isNotEmpty
                      ? FadeInImage.assetNetwork(
                    placeholder: 'assets/images/34338d26023e5515f6cc8969aa027bca.gif', // Path to your loading image asset
                    image: widget.attraction.img,
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
                    LikeAttraction(aid: widget.aId, updateState: updateState),
                    Text("${widget.attraction.likes}")
                  ],
                ),
                const SizedBox(height: 10.0),
                Text(
                  widget.attraction.desc,
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
                  'Contact:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
                const SizedBox(height: 10.0),
                Text(
                  widget.contact,
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
              AttractionRatingView(aId: widget.aId),
                const SizedBox(height: 20.0,),
                // Display reviews
                AttractionReviewList(aId: widget.aId),
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
