import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../admin/admin_home.dart';
import '../authenticate/authenticate.dart';
import '../models/user.dart';
import '../services/admin_service.dart';
import '../services/auth.dart';
import '../shared/loader.dart';
import 'home.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Users?>(context);

    // return either home, admin home, or authenticate
    if (user == null) {
      return const Authenticate();
    } else {
      return FutureBuilder<bool>(
        future: AuthService().isAdmin(user.uid), // Assume this method checks if the user is an admin
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show loading indicator while checking admin status
            return const Loader(color: Colors.black);
          } else {
            if (snapshot.hasError) {
              // Handle error
              return Scaffold(
                body: Center(
                  child: Text('Error: ${snapshot.error}'),
                ),
              );
            } else {
              final bool isAdmin = snapshot.data ?? false;
              if (isAdmin) {
                // If the user is an admin, direct them to the admin home screen
                return StreamBuilder<AdminData>(
                  stream: AdminService(aid: user.uid).adminData,
                  builder: (context, snapshot){
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Loader(color: Colors.black);
                    } else if (snapshot.hasError) {
                      return const Text('Error loading data');
                    }else{
                      final admin = snapshot.data!;
                      return AdminHome(admin: admin,);
                    }
                  },
                );
              } else {
                // If the user is not an admin, direct them to the regular home screen
                return const Home();
              }
            }
          }
        },
      );
    }
  }
}

