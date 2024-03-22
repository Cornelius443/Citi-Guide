import 'package:city_guide/shared/constants.dart';
import 'package:city_guide/shared/reset_password.dart';
import 'package:flutter/material.dart';
import '../services/auth.dart';
import '../shared/loader.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  const SignIn({super.key, required this.toggleView});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String? _email;
  String? _password;
  bool loading = false;
  String error = "";
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImages(); // Preload images when the dependencies change
  }


  void precacheImages() {
    // Preload images using precacheImage
    precacheImage(const AssetImage('assets/images/asia.jpg'), context);

  }

  void showSnack(String msg){
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(msg)
        )
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: loading ? const Loader(color: Colors.black,) :  Container(
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(
        image: DecorationImage(
          image: const AssetImage("assets/images/asia.jpg"),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.5),
            BlendMode.darken,
          ),
        ),

        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text(
              'Sign In To Your Account',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color:  Colors.blue,
                fontFamily: 'Pacifico',
              ),
            ),
            const Text(
              'Enter your credentials to login',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 183, 181, 180),
                  fontFamily: 'QuickSand'),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        style: const TextStyle(
                            color: Colors.white
                        ),
                        decoration: textInputDecoration,
                        validator: (val) => val!.isEmpty ? 'Enter an email' : null,
                        onChanged: (val){
                          setState(() {
                            _email = val;
                          });
                        },
                        cursorColor: Colors.white,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        style: const TextStyle(
                            color: Colors.white
                        ),
                        decoration: textInputDecoration.copyWith(
                            hintText: "Password",
                            prefixIcon: const Icon(Icons.password, color: Colors.white,
                            ),
                        ),
                        validator: (val) => val!.isEmpty ? 'Enter password' : null,
                        onChanged: (val){
                          setState(() {
                            _password = val;
                          });
                        },
                        cursorColor: Colors.white,
                        obscureText: true,
                      ),
                    error != "" ?  Text(
                        error,
                        style: const TextStyle(
                            color: Colors.red
                        ),
                      ) : Container(),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async{
                          if (_formKey.currentState?.validate() ?? false){
                            setState(() {
                              loading = true;
                            });
                            dynamic result = await _auth.signInWithEmailAndPassword(_email!, _password!);

                            if(result == null){
                              setState(() {
                                error = "Error signing up";
                                loading = false;
                              });
                            }else{
                              if(mounted){
                                showSnack("Welcome..");
                              }
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          shape: const StadiumBorder(),
                          padding: const EdgeInsets.symmetric(vertical: 16,
                              horizontal: 70),
                          backgroundColor: Colors.green,
                        ),
                        child: const Text(
                          'Login',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) {
                        return const PasswordResetPage();
                      },
                    ));
                  },
                  child: const Text(
                    'Forgot Password',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Dont have an account? ',
                      style: TextStyle(
                        color: Color.fromARGB(255, 183, 181, 180),
                      ),
                    ),
                    TextButton(
                        onPressed: () {
                          widget.toggleView();
                        },
                        child: const Text(
                          'Register',
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 18,
                            fontFamily: 'QuickSand',
                          ),
                        )
                    )
                  ],
                )
              ],
            )
          ],
        ),
      ),

    );
  }
}
