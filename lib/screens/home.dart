import 'package:city_guide/screens/favorites/favorites.dart';
import 'package:city_guide/screens/profile/user_profile.dart';
import 'package:city_guide/services/database.dart';
import 'package:city_guide/shared/constants.dart';
import 'package:city_guide/shared/loader.dart';
import 'package:city_guide/shared/reset_password.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/city.dart';
import '../models/user.dart';
import '../services/auth.dart';
import '../services/city_service.dart';
import 'city/citi_detail.dart';


class Home extends StatefulWidget {

  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();

  late CityFilterBloc _cityFilterBloc;
  List<City> initialCities = []; // Declare a list to store initial cities
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    // Initialize _cityFilterBloc with an empty list of cities
    _cityFilterBloc = CityFilterBloc([]);
    // Fetch the initial list of cities from your service
    CityService().cities.listen((cities) {
      print('Received cities: $cities'); // Debug print
      setState(() {
        initialCities = cities;
        print('Initial cities set: $initialCities'); // Debug print
        _cityFilterBloc = CityFilterBloc(initialCities); // Initialize with the fetched list
      });
    });
  }



  @override
  Widget build(BuildContext context) {
    // storing the logged in user
    final user = Provider.of<Users?>(context);
    UserData? userData;

    void showSnack(String msg){
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(msg)
          )
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text(
            "Citi Guide",
          style: TextStyle(
              fontFamily: "Pacifico"
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0), // Customizing the shape of the dropdown menu
            ),
            color: Colors.black87,
            iconColor: Colors.white,
            onSelected: (value) async {
              if (value == 'logout') {
                // Handle logout
                await _auth.signOut();
              } else if (value == 'profile') {
                // Handle profile view
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => UserProfile(user: userData!)
                  ),
                );
              }else if(value == 'Reset password'){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PasswordResetPage()
                  ),
                );
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(

                value: 'profile',
                child: ListTile(
                  leading: Icon(Icons.person, color: Colors.white,),
                  title: Text(
                      'View Profile',
                    style: TextStyle(
                        color: Colors.white
                    ),
                  ),
                ),
              ),
              const PopupMenuItem<String>(

                value: 'Reset password',
                child: ListTile(
                  leading: Icon(Icons.password, color: Colors.white,),
                  title: Text(
                    'Reset password',
                    style: TextStyle(
                        color: Colors.white
                    ),
                  ),
                ),
              ),
              const PopupMenuItem<String>(
                value: 'logout',
                child: ListTile(
                  leading: Icon(Icons.exit_to_app, color: Colors.red,),
                  title: Text(
                      'Logout',
                    style: TextStyle(
                      color: Colors.white
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.redAccent,
        onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Favorites(user: userData!)
            ),
          );
        },
        child: const Icon(Icons.favorite, color: Colors.white,),
      ),
      body: StreamBuilder<UserData>(
        // getting the logged in user data
        stream: DatabaseService(uid: user?.uid).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData? user = snapshot.data;
            userData = user;
            return CustomScrollView(

              slivers: [

                SliverAppBar(
                  pinned: true,
                  floating: true,
                  title: TextFormField(
                    style: const TextStyle(
                      color: Colors.white
                    ),
                    onChanged: (val){
                      setState(() {
                        isSearching = true;
                      });
                      _cityFilterBloc.filterCities(val);
                    },
                    decoration: textInputDecoration.copyWith(
                      hintText: "Search",
                      prefixIcon: IconButton(
                          onPressed: (){

                          },
                          icon: const Icon(Icons.search, color: Colors.white,)
                      ),
                      border: InputBorder.none



                    ),
                    cursorColor: Colors.white,
                  ),
                  actions: [
                    IconButton(
                      onPressed: () {

                      },
                      icon: const Icon(Icons.filter_list, color: Colors.white,),
                    ),
                  ],
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 20.0),
                          // Header
                          Container(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Text(
                                'Hi ${user?.fName}!',
                                style: const TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "QuickSand"
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 5.0),
                          const Center(
                            child: Text(
                                "Hot New Cities",
                              style: TextStyle(
                                fontFamily: "QuickSand",
                                fontSize: 15
                              ),
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          // StreamProvider...
                          StreamProvider<List<City>?>.value(
                            value: isSearching ? _cityFilterBloc.filteredCities : CityService().cities,
                            catchError: (context, error) {
                              // Handle the error gracefully.
                              showSnack('Error fetching city data: $error');
                              return null;
                            },
                            initialData: null,
                            child:  Consumer<List<City>?>(
                          builder: (context, cities, _) {
                          return cities != null  && cities.isNotEmpty ?  ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: cities.length,
                          itemBuilder: (context, index) {
                          final city = cities[index];

                          return  Card(
                            margin: const EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
                            child: ListTile(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CitiDetail(
                                          user: user!,
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
                          );
                          },
                          ) : const Center(child: Text(
                            "City Not Found"
                          ),);
                          },
                          ),
                          ),



                        ],
                      );
                    },
                    childCount: 1,
                  ),
                ),
              ],
            );
          } else {
            return const Loader(color: Colors.black);
          }
        },

      ),
    );
  }

  @override
  void dispose() {
    _cityFilterBloc.dispose(); // Dispose of CityFilterBloc
    super.dispose();
  }
}



