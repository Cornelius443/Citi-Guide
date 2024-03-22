import 'package:city_guide/admin/profile/admin_profile.dart';
import 'package:city_guide/admin/profile/my_attractions.dart';
import 'package:city_guide/admin/profile/my_events.dart';
import 'package:city_guide/admin/profile/my_hotels.dart';
import 'package:city_guide/admin/profile/my_rest.dart';
import 'package:city_guide/services/database.dart';
import 'package:city_guide/shared/reset_password.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/city.dart';
import '../models/user.dart';
import '../services/admin_service.dart';
import '../services/auth.dart';
import '../services/city_service.dart';
import 'add_city.dart';
import 'city_list.dart';

class AdminHome extends StatefulWidget {
  final AdminData admin;
  const AdminHome({super.key, required this.admin});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> with SingleTickerProviderStateMixin {
  final AuthService _auth = AuthService();
  late TabController _tabController;
  int totalCities = 0;
  int totalVisitors = 0;
  bool _isMounted = false;
  @override
  void initState() {
    super.initState();
    _isMounted = true;
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabSelection);
    _fetchData();
    _fetchAdminData();
  }


  void _fetchData() {
    // Fetch data for total visitors
    DatabaseService().travelers.listen((travelers) {
      if (_isMounted) {
        setState(() {
          totalVisitors = travelers.length;
        });
      }
    });
  }

  void _fetchAdminData() {
    CityService().getCitiesByAdminId(widget.admin.aid!).listen((cities) {
      if (_isMounted) {
        setState(() {
          totalCities = cities.length;
        });
      }
    });
  }

  void _handleTabSelection() {
    if (_isMounted && _tabController.index == 0) {
      _fetchData();
      _fetchAdminData();
    }
    if (_isMounted) {
      setState(() {
        // Rebuild the UI when the tab changes
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Users?>(context);

    void showAddPanel() {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              color: Colors.grey[200],
            ),
            padding: EdgeInsets.only(
              top: 16,
              left: 16,
              right: 16,
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: AddCity(aid: user!.uid),
          );
        },
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          "   Welcome ${widget.admin.fName}",
          style: const TextStyle(
            fontFamily: "Pacifico",
            fontSize: 20.0,
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
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) {
                    return AdminProfile(admin: widget.admin);
                  },
                ));
              } else if (value == 'Reset password') {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) {
                    return const PasswordResetPage();
                  },
                ));
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'profile',
                child: ListTile(
                  leading: Icon(Icons.person, color: Colors.white),
                  title: Text(
                    'View Profile',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const PopupMenuItem<String>(
                value: 'Reset password',
                child: ListTile(
                  leading: Icon(Icons.password, color: Colors.white),
                  title: Text(
                    'Reset password',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const PopupMenuItem<String>(
                value: 'logout',
                child: ListTile(
                  leading: Icon(Icons.exit_to_app, color: Colors.red),
                  title: Text(
                    'Logout',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: _tabController.index == 1
          ? FloatingActionButton(

                  backgroundColor: Colors.black,
                  onPressed: () {
          showAddPanel();
                  },
                  child: const Icon(Icons.add, color: Colors.white),
                )
          : null,
      body: DefaultTabController(
        length: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Colors.blue[900],
              child: TabBar(
                indicatorColor: Colors.green,
                labelColor: Colors.blue, // Color of the active icon
                unselectedLabelColor: Colors.white,
                controller: _tabController,
                tabs: const [
                  Tab(icon: Icon(Icons.person_2)),
                  Tab(
                    child: Text(
                      "Cities",
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildAdminData(),
                  _buildCityList(widget.admin),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminData() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 30.0),
          Padding(
            padding: const EdgeInsets.all(13.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              shrinkWrap: true,
              itemCount: 4,
              itemBuilder: (BuildContext context, int index) {
                return LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    return Card(
                      elevation: 4.0,
                      child: TextButton.icon(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.grey[100],
                          padding: EdgeInsets.zero,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                        onPressed: () {
                          // Action for each button
                          switch (index) {
                            case 0:
                            // Events button pressed
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) {
                        return MyEvents(admin: widget.admin);
                      },
                    ));
                              break;
                            case 1:
                            // Hotels button pressed
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) {
                        return MyHotels(admin: widget.admin);
                      },
                    ));
                              break;
                            case 2:
                            // Restaurants button pressed
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) {
                      return MyRest(admin: widget.admin);
                    },
                  ));
                              break;
                            case 3:
                            // Attractions button pressed
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) {
                      return MyAttract(admin: widget.admin);
                    },
                  ));
                              break;
                            default:
                          }
                        },
                        icon: Icon(
                          index == 0 ? Icons.event : index == 1 ? Icons.hotel : index == 2 ? Icons.restaurant : Icons.attractions,
                          color: index == 0 ? Colors.redAccent : index == 1 ? Colors.blue : index == 2 ? Colors.grey : Colors.purple,
                        ),
                        label: Text(
                          index == 0 ? "Events" : index == 1 ? "Hotels" : index == 2 ? "Restaurants" : "Attractions",
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(width: 24.0),
              const Icon(Icons.location_city_outlined),
              const SizedBox(width: 10.0),
              Text(
                "Your Total Cities:   $totalCities",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: "QuickSand",
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(width: 24.0),
              const Icon(Icons.people_alt),
              const SizedBox(width: 10.0),
              Text(
                "Visitors Count:     $totalVisitors",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: "QuickSand",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCityList(AdminData admin) {
    return StreamProvider<List<City>?>.value(
      value: CityService().getCitiesByAdminId(admin.aid!).map((cities) {
        // Create a Set to store unique city names
        final uniqueCityNames = <String>{};
        // Filter out duplicate cities by checking the city name
        final uniqueCities = cities.where((city) => uniqueCityNames.add(city.cName!)).toList();
        return uniqueCities;
      }),
      catchError: (context, error) {
        // Handle the error gracefully.
        print('Error fetching city data: $error');
        return null;
      },
      initialData: null,
      child: CityList(admin: admin),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _isMounted = false;
    super.dispose();
  }

}
