import 'package:city_guide/admin/add_restaurant.dart';
import 'package:city_guide/admin/attractions/add_attractions.dart';
import 'package:city_guide/admin/attractions/attraction_list.dart';
import 'package:city_guide/admin/city_gallery/add_image.dart';
import 'package:city_guide/admin/city_gallery/city_gallery_grid.dart';
import 'package:city_guide/admin/city_gallery/like_city.dart';
import 'package:city_guide/admin/city_gallery/update_detail.dart';
import 'package:city_guide/admin/city_gallery/upload_image.dart';
import 'package:city_guide/admin/event/add_event.dart';
import 'package:city_guide/admin/event/event_list.dart';
import 'package:city_guide/admin/hotel/add_hotel.dart';
import 'package:city_guide/admin/hotel/hotel_list.dart';
import 'package:city_guide/admin/rest_list.dart';
import 'package:city_guide/services/admin_service.dart';
import 'package:city_guide/services/attraction_service.dart';
import 'package:city_guide/services/event_service.dart';
import 'package:city_guide/services/hotel_service.dart';
import 'package:city_guide/services/rest_service.dart';
import 'package:city_guide/shared/ratings_view.dart';
import 'package:city_guide/shared/review.dart';
import 'package:city_guide/shared/review_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/city.dart';
import '../shared/map_screen.dart';


class CityDetail extends StatefulWidget {
  final String cityName;
  final String cid;
  final String desc;
  final String location;
  final AdminData admin;
  final City city;


  // List of image URLs for the gallery

  const CityDetail({
    super.key,
    required this.cityName,
    required this.cid,
    required this.desc,
    required this.location,
    required this.admin,
    required this.city

  });

  @override
  State<CityDetail> createState() => _CityDetailState();
}

class _CityDetailState extends State<CityDetail>  with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isMounted = false;

  @override
  void initState() {
    super.initState();
    _isMounted = true;
    _tabController = TabController(length: 6, vsync: this);
    _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    if (_isMounted) {
      setState(() {
        // Rebuild the UI when the tab changes
      });
    }
  }

  void showAddPanel(){
    showModalBottomSheet(context: context, isScrollControlled: true, builder: (context){
      return Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          color: Colors.grey[200],
        ),

        padding: EdgeInsets.only(top: 16, left: 16, right: 16, bottom: MediaQuery.of(context).viewInsets.bottom),
        child: AddRestaurant(cName: widget.cityName, aid: widget.admin.aid!,),
      );
    });
  }


  void showAddPanel1(){
    showModalBottomSheet(context: context, isScrollControlled: true, builder: (context){
      return Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          color: Colors.grey[200],
        ),

        padding: EdgeInsets.only(top: 16, left: 16, right: 16, bottom: MediaQuery.of(context).viewInsets.bottom),
        child: AddHotel(cName: widget.cityName, aid: widget.admin.aid!),
      );
    });
  }

  void showAddPanel2(){
    showModalBottomSheet(context: context, isScrollControlled: true, builder: (context){
      return Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          color: Colors.grey[200],
        ),

        padding: EdgeInsets.only(top: 16, left: 16, right: 16, bottom: MediaQuery.of(context).viewInsets.bottom),
        child: AddEvent(cName: widget.cityName, aid: widget.admin.aid!)
      );
    });
  }

  void showAddPanel3(){
    showModalBottomSheet(context: context, isScrollControlled: true, builder: (context){
      return Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            color: Colors.grey[200],
          ),

          padding: EdgeInsets.only(top: 16, left: 16, right: 16, bottom: MediaQuery.of(context).viewInsets.bottom),
          child: AddAttraction(cName: widget.cityName, aid: widget.admin.aid!),
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
          child: AddCityImage(cId: widget.cid)
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
          child: UpdateCityDesc(cid: widget.cid, updateDetail: updateDetail)
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
          child: UploadCityImage(img: widget.city.cImg, cid: widget.cid, updateImgState: updateImgState,)
      );
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
            cid: widget.cid,
            senderId: widget.admin.aid!,
            senderName: widget.admin.fName!,
            senderImg: widget.admin.img,
          ),
      );
    });
  }

  void updateImgState(String url){
    setState(() {
      widget.city.cImg = url;
    });
  }

  void updateState(int likes){
    setState(() {
      widget.city.likes = likes;
    });
  }

  void updateDetail(String desc){
    setState(() {
      widget.city.desc = desc;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text(widget.cityName),
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
              indicatorColor: Colors.blue,
              dividerColor: Colors.grey[400],
              labelColor: Colors.pink, // Color of the active icon
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
      ) : _tabController.index == 1
          ? FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {
          // Action to perform when the FAB is pressed on the Restaurants tab
          showAddPanel();
        },
        child: const Icon(Icons.add, color: Colors.white,),
      )
          : _tabController.index == 2 ? FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {
          showAddPanel1();
        },
        child: const Icon(Icons.add, color: Colors.white,),
      ) : _tabController.index == 3 ? FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {
          showAddPanel2();
        },
        child: const Icon(Icons.add, color: Colors.white,),
      ) : _tabController.index == 4 ? FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {
          showAddPanel3();
        },
        child: const Icon(Icons.add, color: Colors.white,),
      ) : _tabController.index == 5 ? FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {
          showAddImage();
        },
        child: const Icon(Icons.add_a_photo, color: Colors.white,),
      ) :  null,
    );



  }

  Widget _buildGallery() {
   return CityGallery(cid: widget.cid, cName: widget.cityName,);
  }

  Widget _buildRestaurantList() {
  return StreamProvider<List<Restaurant>?>.value(
    value: RestaurantService().getRestByCityName(widget.cityName),
    catchError: (context, error) {
      // Handle the error gracefully.
      print('Error fetching restaurant data: $error');
      return null; // Return null to indicate that there was an error in the stream
    },
    initialData: null,
    child: Consumer<List<Restaurant>?>(
        builder: (context, snapshot, _){
          return  RestList(admin: widget.admin,);
        }

    ),
  );
  }

  Widget _buildAttractionList(){
    return StreamProvider<List<Attractions>?>.value(
      value: AttractionService().getAttractionsByCityName(widget.cityName),
      catchError: (context, error) {
        // Handle the error gracefully.
        print('Error fetching restaurant data: $error');
        return null; // Return null to indicate that there was an error in the stream
      },
      initialData: null,
      child: Consumer<List<Restaurant>?>(
          builder: (context, snapshot, _){
            return AttractionList(admin: widget.admin);
          }

      ),
    );
  }

  Widget _buildHotelList() {
    return StreamProvider<List<Hotel>?>.value(
        value: HotelService().getHotelByCityName(widget.cityName),
        catchError: (context, error) {
          // Handle the error gracefully.
          print('Error fetching hotel data: $error');
          return null; // Return null to indicate that there was an error in the stream
        },
        initialData: null,
        child: Consumer<List<Hotel>?>(
          builder: (context, hotelSnapshot, _){
            return HotelList(admin: widget.admin);
          },
        ),
    );
  }

  Widget _buildEventList(){
    return StreamProvider<List<Event>?>.value(
      value: EventService().getEventByCityName(widget.cityName),
      catchError: (context, error) {
        // Handle the error gracefully.
        print('Error fetching event data: $error');
        return null; // Return null to indicate that there was an error in the stream
      },
      initialData: null,
      child: Consumer<List<Event>?>(
        builder: (context, eventSnapshot, _){
          return EventList(admin: widget.admin);
        },
      ),
    );
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
                      IconButton(
                          onPressed: (){
                            showUploadImage();
                          },
                          icon: const Icon(Icons.add_a_photo, color: Colors.black,)
                      ),
                    LikeCity(cid: widget.cid,
                        updateState: updateState,

                    ),
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
                    widget.location,
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
              RatingView(cid: widget.cid),
                  const SizedBox(height: 20.0),
               ReviewList(cid: widget.cid),
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
    _isMounted = false;
    super.dispose();
  }


}
