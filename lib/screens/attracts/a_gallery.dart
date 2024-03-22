import 'package:flutter/material.dart';
import '../../services/attraction_service.dart';
import '../../shared/image_detail.dart';
class AGallery extends StatefulWidget {
  final String id;
  final String name;
  const AGallery({super.key,
  required this.name,
    required this.id
  });

  @override
  State<AGallery> createState() => _AGalleryState();
}

class _AGalleryState extends State<AGallery> {
  AttractionService attractionService = AttractionService();
  void showSnack(String msg){
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(msg)
        )
    );
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<String>>(
      stream: attractionService.imageStreamByAid(widget.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final List<String>? images = snapshot.data;
          return images != null && images.isNotEmpty
              ? Padding(
            padding: const EdgeInsets.all(20.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Number of columns
                crossAxisSpacing: 8.0, // Spacing between columns
                mainAxisSpacing: 8.0, // Spacing between rows
              ),
              itemCount: images.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailScreen(imageUrl: images[index], name: widget.name,),
                      ),
                    );
                  },
                  child: FadeInImage.assetNetwork(
                    placeholder: 'assets/images/34338d26023e5515f6cc8969aa027bca.gif', // Placeholder image asset
                    image: images[index],
                    fit: BoxFit.cover,
                    width: 200,
                    height: 200,
                  ),
                );
              },
            ),

          )
              : const Center(
            child: Text(
              'No image available',
              style: TextStyle(fontSize: 18),
            ),
          );
        }
      },
    );
  }
}
