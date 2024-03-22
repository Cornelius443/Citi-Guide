import 'package:flutter/material.dart';
class DetailScreen extends StatelessWidget {
  final String imageUrl;
  final String name;
  const DetailScreen({super.key,required this.imageUrl, required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
backgroundColor: Colors.black,
      appBar: AppBar(
backgroundColor: Colors.black,
        title: Text(
          name,
          style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.white, // Set the color of the back icon
          size: 24.0,          // Set the size of the back icon
        ),
      ),
      body: Center(
        child: FadeInImage.assetNetwork(
          placeholder: 'assets/images/34338d26023e5515f6cc8969aa027bca.gif', // Placeholder image asset
          image: imageUrl,
          fit: BoxFit.cover,
          width: 400,
          height: 400,
        ),
      ),
    );
  }
}