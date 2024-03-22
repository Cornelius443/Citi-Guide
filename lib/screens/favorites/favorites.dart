import 'package:city_guide/screens/attracts/a_detail.dart';
import 'package:city_guide/screens/events/e_detail.dart';
import 'package:city_guide/screens/hotels/h_detail.dart';
import 'package:city_guide/screens/restaurants/r_detail.dart';
import 'package:city_guide/services/attraction_service.dart';
import 'package:city_guide/services/city_service.dart';
import 'package:city_guide/services/database.dart';
import 'package:city_guide/services/event_service.dart';
import 'package:city_guide/services/hotel_service.dart';
import 'package:city_guide/services/rest_service.dart';
import 'package:city_guide/shared/loading.dart';
import 'package:flutter/material.dart';
import '../../models/city.dart';
import '../../models/user.dart';
import '../city/citi_detail.dart';

class Favorites extends StatefulWidget {
  final UserData user;
  const Favorites({super.key, required this.user});

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> with SingleTickerProviderStateMixin  {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: const Text(
            "Favorites",
          style: TextStyle(
            fontFamily: "Pacifico",
            fontSize: 24.0
          ),
        ),

      ),

      body: DefaultTabController(
        length: 5,

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10.0),
            TabBar(

              indicatorColor: Colors.green,
              dividerColor: Colors.grey[400],
              labelColor: Colors.black, // Color of the active icon
              labelStyle: const TextStyle(fontSize: 12),
              unselectedLabelColor: Colors.black,
              controller: _tabController,
              tabs: const [
                Tab(text: "Favorite", icon: Icon(Icons.location_city),),
                Tab(text: "Favorite", icon: Icon(Icons.restaurant),),
                Tab(text: "Favorite", icon: Icon(Icons.hotel),),
                Tab(text: "Favorite", icon: Icon(Icons.event),),
                Tab(text: "Favorite", icon: Icon(Icons.attractions),),



              ],

            ),
            Expanded(
              child: TabBarView(
                controller:_tabController,
                children: [
              _buildFavoriteCities(),
              _buildFavoriteRest(),
              _buildFavoriteHotel(),
              _buildFavoriteEvent(),
              _buildFavoriteAttraction()
                ],
              ),
            ),
          ],
        ),
      ),

    );


  }

  Widget _buildFavoriteCities(){
   return StreamBuilder<List<FavCity>>(
      stream: DatabaseService(uid: widget.user.uid!).favoriteCitiesStream(),
       builder: (context, snapshot){
         if (snapshot.connectionState == ConnectionState.waiting) {
           return const Center(child: Loading());
         }else if (!snapshot.hasData || snapshot.data!.isEmpty) {
           return const Center(
             child: Text('Your favorite cities will appear here'),
           );
         }else{
           var favorite = snapshot.data;
           return ListView.builder(
               itemCount: favorite?.length,
               itemBuilder: (context, index){
                 FavCity? favCity = favorite?[index];
                 return StreamBuilder<City>(
                     stream: CityService(cid: favCity?.cid).cityData,
                     builder: (context, citySnapshot){
                       if (citySnapshot.connectionState == ConnectionState.waiting) {
                         return const Center(child: Loading());
                       } else if (!citySnapshot.hasData) {
                         return const Text('City not found');
                       } else {
                         City city = citySnapshot.data!;
                         return Padding(
                           padding: const EdgeInsets.only(top: 9.0),
                           child: Card(
                             margin: const EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
                             child: ListTile(
                               onTap: () {
                                 Navigator.push(
                                   context,
                                   MaterialPageRoute(
                                       builder: (context) => CitiDetail(
                                           user: widget.user,
                                           city: city
                                       )
                                   ),
                                 );
                               },
                               leading: CircleAvatar(
                                 backgroundColor: Colors.white,
                                 child: city.cImg.isNotEmpty
                                     ? ClipOval(
                                   child: Image.network(
                                     city.cImg,
                                     width: 40,
                                     height: 40,
                                     fit: BoxFit.cover,
                                   ),
                                 )
                                     : const Icon(Icons.location_city),
                               ),
                               title: Text(city.cName!),
                               subtitle: const Text("View Details"),
                             ),
                           ),
                         );
                       }
                     }
                 );
               }
           );

         }
       }
    );
  }

  Widget _buildFavoriteRest(){
    return StreamBuilder<List<FavRest>>(
        stream: DatabaseService(uid: widget.user.uid!).favoriteRestStream(),
        builder: (context, snapshot){
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: Loading());
          }else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('Your favorite restaurants will appear here'),
            );
          }else{
            var favorite = snapshot.data;
            return ListView.builder(
                itemCount: favorite?.length,
                itemBuilder: (context, index){
                  FavRest? favRest = favorite?[index];
                  return StreamBuilder<Restaurant>(
                      stream: RestaurantService(restId: favRest?.rId).restData,
                      builder: (context, restSnapshot){
                        if (restSnapshot.connectionState == ConnectionState.waiting) {
                          return const Loading();
                        } else if (!restSnapshot.hasData) {
                          return const Text('City not found');
                        } else {
                         Restaurant restaurant = restSnapshot.data!;
                          return Padding(
                            padding: const EdgeInsets.only(top: 9.0),
                            child: Card(
                              margin: const EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
                              child: ListTile(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => RDetail(
                                            user: widget.user,
                                            restaurant:
                                            restaurant)
                                    ),
                                  );
                                },
                                leading: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: restaurant.rImg.isNotEmpty
                                      ? ClipOval(
                                    child: Image.network(
                                      restaurant.rImg,
                                      width: 40,
                                      height: 40,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                      : const Icon(Icons.location_city),
                                ),
                                title: Text(restaurant.rName!),
                                subtitle: const Text("View Details"),
                              ),
                            ),
                          );
                        }
                      }
                  );
                }
            );

          }
        }
    );
  }

  Widget _buildFavoriteHotel(){
    return StreamBuilder<List<FavHotel>>(
        stream: DatabaseService(uid: widget.user.uid!).favoriteHotelStream(),
        builder: (context, snapshot){
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loading();
          }else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('Your favorite hotels will appear here'),
            );
          }else{
            var favorite = snapshot.data;
            return ListView.builder(
                itemCount: favorite?.length,
                itemBuilder: (context, index){
                  FavHotel? favHotel = favorite?[index];
                  return StreamBuilder<Hotel>(
                      stream: HotelService(hId: favHotel?.hId).hotelData,
                      builder: (context, hotelSnapshot){
                        if (hotelSnapshot.connectionState == ConnectionState.waiting) {
                          return const Loading();
                        } else if (!hotelSnapshot.hasData) {
                          return const Text('City not found');
                        } else {
                          Hotel hotel = hotelSnapshot.data!;
                          return Padding(
                            padding: const EdgeInsets.only(top: 9.0),
                            child: Card(
                              margin: const EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
                              child: ListTile(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HDetail(
                                            user: widget.user,
                                            hotel: hotel)
                                    ),
                                  );
                                },
                                leading: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: hotel.img.isNotEmpty
                                      ? ClipOval(
                                    child: Image.network(
                                      hotel.img,
                                      width: 40,
                                      height: 40,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                      : const Icon(Icons.location_city),
                                ),
                                title: Text(hotel.name!),
                                subtitle: const Text("View Details"),
                              ),
                            ),
                          );
                        }
                      }
                  );
                }
            );

          }
        }
    );
  }



  Widget _buildFavoriteEvent(){
    return StreamBuilder<List<FavEvent>>(
        stream: DatabaseService(uid: widget.user.uid!).favoriteEventStream(),
        builder: (context, snapshot){
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loading();
          }else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('Your favorite events will appear here'),
            );
          }else{
            var favorite = snapshot.data;
            return ListView.builder(
                itemCount: favorite?.length,
                itemBuilder: (context, index){
                  FavEvent? favEvent = favorite?[index];
                  return StreamBuilder<Event>(
                      stream: EventService(eId: favEvent?.eId).eventData,
                      builder: (context, eventSnapshot){
                        if (eventSnapshot.connectionState == ConnectionState.waiting) {
                          return const Loading();
                        } else if (!eventSnapshot.hasData) {
                          return const Text('City not found');
                        } else {
                          Event event = eventSnapshot.data!;
                          return Padding(
                            padding: const EdgeInsets.only(top: 9.0),
                            child: Card(
                              margin: const EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
                              child: ListTile(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EDetail(
                                            event: event,
                                            user: widget.user)
                                    ),
                                  );
                                },
                                leading: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: event.img.isNotEmpty
                                      ? ClipOval(
                                    child: Image.network(
                                      event.img,
                                      width: 40,
                                      height: 40,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                      : const Icon(Icons.location_city),
                                ),
                                title: Text(event.name!),
                                subtitle: const Text("View Details"),
                              ),
                            ),
                          );
                        }
                      }
                  );
                }
            );

          }
        }
    );
  }


  Widget _buildFavoriteAttraction(){
    return StreamBuilder<List<FavAttraction>>(
        stream: DatabaseService(uid: widget.user.uid!).favoriteAttractionStream(),
        builder: (context, snapshot){
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loading();
          }else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('Your favorite attractions will appear here'),
            );
          }else{
            var favorite = snapshot.data;
            return ListView.builder(
                itemCount: favorite?.length,
                itemBuilder: (context, index){
                  FavAttraction? favAttraction = favorite?[index];
                  return StreamBuilder<Attractions>(
                      stream: AttractionService(id: favAttraction?.id).attractionData,
                      builder: (context, aSnapshot){
                        if (aSnapshot.connectionState == ConnectionState.waiting) {
                          return const Loading();
                        } else if (!aSnapshot.hasData) {
                          return const Text('City not found');
                        } else {
                          Attractions attractions = aSnapshot.data!;
                          return Padding(
                            padding: const EdgeInsets.only(top: 9.0),
                            child: Card(
                              margin: const EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
                              child: ListTile(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ADetail(user: widget.user,
                                                attractions: attractions)
                                    ),
                                  );
                                },
                                leading: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: attractions.img.isNotEmpty
                                      ? ClipOval(
                                    child: Image.network(
                                        attractions.img,
                                        width: 40,
                                        height: 40,
                                        fit: BoxFit.cover,
                                    ),
                                  )
                                      : const Icon(Icons.location_city),
                                ),
                                title: Text(attractions.name!),
                                subtitle: const Text("View Details"),
                              ),
                            ),
                          );
                        }
                      }
                  );
                }
            );

          }
        }
    );
  }
}
