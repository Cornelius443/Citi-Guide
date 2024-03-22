import 'package:city_guide/services/admin_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user.dart';
import 'database.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create user object based on firebase user
  Users? _userFromFirebaseUser(User user){
    return Users(uid: user.uid);

  }

  // auth change user stream
  Stream<Users?> get user{
    return _auth.authStateChanges().map((User? user) => _userFromFirebaseUser(user!));
  }

  // sign in with email and password
  Future signInWithEmailAndPassword(String email, String password)async{
    try{
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;
      return _userFromFirebaseUser(user!);
    }catch(e) {
      print(e.toString());
      return null;
    }
  }


  // register with email and password
  Future registerWithEmailAndPassword(
      String fName,
      String lName,
      String img,
      String email,
      String password,
      String phone,
      String country,
      bool isAdmin
      )async{
    try{
      UserCredential userCredential = await
      _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;

      if(user != null){
        if(isAdmin){
          await AdminService(aid: user.uid).updateAdminData(
              fName, lName, img, email, phone, country);
        }else{
          // create a new document for the user with the uid
          await DatabaseService(uid: user.uid).updateUserData(
              fName,
              lName,
              img,
              email,
              phone,
              country,
              [],
              [],
              [],
              [],
              [],
              []
          );
          return _userFromFirebaseUser(user);
        }
      }

    }catch(e){
      print(e.toString());
      return null;
    }
  }
  //

  // check if the user is an admin
  Future<bool> isAdmin(String uid) async {
    try {
      // Get the document snapshot corresponding to the user's UID from the 'admins' collection
      DocumentSnapshot adminSnapshot = await FirebaseFirestore.instance.collection('admin').doc(uid).get();

      // Check if the document exists
      if (adminSnapshot.exists) {
        // User is an admin
        return true;
      } else {
        // User is not an admin
        return false;
      }
    } catch (e) {
      // Handle any errors
      print('Error checking admin status: $e');
      return false; // Assuming any error means the user is not an admin
    }
  }

  Future resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return true;
    } catch (e) {
      print('Error sending password reset email: $e');
      return false;
    }
  }


  // sign out
  Future signOut() async{
    try{
      return await _auth.signOut();
    }catch(e){
      print(e.toString());
      return null;
    }
  }
}