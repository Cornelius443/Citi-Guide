import 'package:city_guide/models/user.dart';
import 'package:city_guide/screens/attracts/a_list.dart';
import 'package:city_guide/screens/city/citi_gallery.dart';
import 'package:city_guide/screens/city/citi_review_list.dart';
import 'package:city_guide/screens/city/like_citi.dart';
import 'package:city_guide/screens/events/e_list.dart';
import 'package:city_guide/screens/hotels/h_list.dart';
import 'package:city_guide/screens/restaurants/r_list.dart';
import 'package:city_guide/shared/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/city.dart';
import '../../services/attraction_service.dart';
import '../../services/event_service.dart';
import '../../services/hotel_service.dart';
import '../../services/rest_service.dart';
import '../../shared/ratings_view.dart';
import '../../shared/review.dart';

class CitiDetail extends StatefulWidget {
  final UserData user;
  final City city;
  const CitiDetail({
    super.key,
    required this.user,
    required this.city
  });

  @override
  State<CitiDetail> createState() => _CitiDetailState();
}

class _CitiDetailState extends State<CitiDetail> with SingleTickerProviderStateMixin {

  late TabController _tabController;


  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
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
        child: Review(
          cid: widget.city.cid!,
          senderId: widget.user.uid!,
          senderName: widget.user.fName!,
          senderImg: widget.user.img!,
        ),
      );
    });
  }

  void updateState(int likes){
    setState(() {
      widget.city.likes = likes;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text(widget.city.cName!),
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
        length: 6,

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
                Tab(icon: Icon(Icons.description),),
                Tab(icon: Icon(Icons.restaurant)),
                Tab(icon: Icon(Icons.hotel)),
                Tab(icon: Icon(Icons.event)),
                Tab(icon: Icon(Icons.attractions)),
                Tab(icon: Icon(Icons.image)),


              ],

            ),
            Expanded(
              child: TabBarView(
                controller:_tabController,
                children: [
                  _buildDescriptionAndReviews(),
                  _buildRestaurantList(),
                  _buildHotelList(),
                  _buildEventList(),
                  _buildAttractionList(),
                  _buildGallery(),

                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _tabController.index == 0 ? FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {
          // Action to perform when the FAB is pressed on the Restaurants tab
          showAddReview();
          },
        child: const Icon(Icons.rate_review, color: Colors.white,),
      ) :  null,
    );
  }

  Widget _buildRestaurantList() {
    return StreamProvider<List<Restaurant>?>.value(
      value: RestaurantService().getRestByCityName(widget.city.cName!),
      catchError: (context, error) {
        // Handle the error gracefully.
        print('Error fetching restaurant data: $error');
        return null; // Return null to indicate that there was an error in the stream
      },
      initialData: null,
      child: Consumer<List<Restaurant>?>(
          builder: (context, snapshot, _){
            return  RList(user: widget.user);
          }

      ),
    );
  }

  Widget _buildHotelList() {
    return StreamProvider<List<Hotel>?>.value(
      value: HotelService().getHotelByCityName(widget.city.cName!),
      catchError: (context, error) {
        // Handle the error gracefully.
        print('Error fetching hotel data: $error');
        return null; // Return null to indicate that there was an error in the stream
      },
      initialData: null,
      child: Consumer<List<Hotel>?>(
        builder: (context, hotelSnapshot, _){
          return HList(user: widget.user);
        },
      ),
    );
  }

  Widget _buildEventList(){
    return StreamProvider<List<Event>?>.value(
      value: EventService().getEventByCityName(widget.city.cName!),
      catchError: (context, error) {
        // Handle the error gracefully.
        print('Error fetching event data: $error');
        return null; // Return null to indicate that there was an error in the stream
      },
      initialData: null,
      child: Consumer<List<Event>?>(
        builder: (context, eventSnapshot, _){
          return EList(user: widget.user);
        },
      ),
    );
  }

  Widget _buildAttractionList(){
    return StreamProvider<List<Attractions>?>.value(
      value: AttractionService().getAttractionsByCityName(widget.city.cName!),
      catchError: (context, error) {
        // Handle the error gracefully.
        print('Error fetching restaurant data: $error');
        return null; // Return null to indicate that there was an error in the stream
      },
      initialData: null,
      child: Consumer<List<Restaurant>?>(
          builder: (context, snapshot, _){
            return AList(user: widget.user);
          }

      ),
    );
  }

  Widget _buildGallery() {
    return CitiGallery(cid: widget.city.cid!, cName: widget.city.cName!);
  }

  Widget _buildDescriptionAndReviews() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
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
                    child: widget.city.cImg.isNotEmpty
                        ? FadeInImage.assetNetwork(
                      placeholder: 'assets/images/34338d26023e5515f6cc8969aa027bca.gif', // Path to your loading image asset
                      image: widget.city.cImg,
                      width: 200,
                      fit: BoxFit.cover, // Adjust the fit as needed
                    )
                        : const Center(
                      child: Text("No Image"),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                  LikeCiti(
                      id: widget.user.uid!,
                      city: widget.city,
                      updateState: updateState),
                      Text("${widget.city.likes}")
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    widget.city.desc,
                    style:  const TextStyle(
                      fontSize: 16.0,

                    ),
                  ),
                  const SizedBox(height: 6.0),
                  const Text(
                    'Location:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    widget.city.cLocation!,
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
                  RatingView(cid: widget.city.cid!),
                  const SizedBox(height: 20.0),
                  CitiReviewList(cid: widget.city.cid!, id: widget.user.uid!,),
                  const SizedBox(height: 100.0,),
                ],
              ),
            ),
          ),
        ),

      ],
    );
  }
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
