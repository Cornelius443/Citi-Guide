import 'package:city_guide/admin/hotel/add_image.dart';
import 'package:city_guide/admin/hotel/hotel_gallery.dart';
import 'package:city_guide/admin/hotel/hotel_rating.dart';
import 'package:city_guide/admin/hotel/hotel_review.dart';
import 'package:city_guide/admin/hotel/hotel_review_list.dart';
import 'package:city_guide/admin/hotel/like_hotel.dart';
import 'package:city_guide/admin/hotel/update_hotel_desc.dart';
import 'package:city_guide/admin/hotel/update_hotel_img.dart';
import 'package:city_guide/services/admin_service.dart';
import 'package:flutter/material.dart';

import '../../models/city.dart';
import '../../shared/map_screen.dart';




class HotelDetail extends StatefulWidget {
  final String hName;
  final String hId;
  final String desc;
  final String cName;
  final String location;
  final String contact;
  final String email;
  final String website;
  final AdminData admin;
  final Hotel hotel;
  const HotelDetail({
    super.key,
    required this.hName,
    required this.hId,
    required this.desc,
    required this.cName,
    required this.location,
    required this.contact,
    required this.email,
    required this.website,
    required this.admin,
    required this.hotel

  });

  @override
  State<HotelDetail> createState() => _HotelDetailState();
}

class _HotelDetailState extends State<HotelDetail> with SingleTickerProviderStateMixin  {

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
        child: HotelReview(
            hId: widget.hId,
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
          child: AddHotelImage(hId: widget.hId),
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
          child: UpdateHotelImg(hid: widget.hId, img: widget.hotel.img, updateImgState: updateImgState)
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
          child: UpdateHotelDesc(hid: widget.hId, updateDetail: updateDetail)
      );
    });
  }

  void updateImgState(String url){
    setState(() {
      widget.hotel.img = url;
    });
  }
  void updateState(int likes){
    setState(() {
      widget.hotel.likes = likes;
    });
  }
  void updateDetail(String desc){
    setState(() {
      widget.hotel.desc = desc;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.hName),
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
      )  : null,
    );



  }

  Widget _buildGallery() {
    return HotelGallery(hId: widget.hId, hName: widget.hName);
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
                  child: widget.hotel.img.isNotEmpty
                      ? FadeInImage.assetNetwork(
                    placeholder: 'assets/images/34338d26023e5515f6cc8969aa027bca.gif', // Path to your loading image asset
                    image: widget.hotel.img,
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
                    LikeHotel(hid: widget.hId, updateState: updateState),
                    Text("${widget.hotel.likes}")
                  ],
                ),
                const SizedBox(height: 10.0),
                Text(
                  widget.hotel.desc,
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
                HotelRatingView(hId: widget.hId),
                const SizedBox(height: 20.0,),
                // Display reviews
                HotelReviewList(hId: widget.hId),
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
