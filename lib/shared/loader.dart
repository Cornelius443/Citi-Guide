import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
class Loader extends StatelessWidget {
final Color color;
  const Loader({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue[900],
      child: const Center(
        child: SpinKitDoubleBounce(
          color: Colors.white,
          size: 50.0,
        ),
      ),
    );
  }
}
