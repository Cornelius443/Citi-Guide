import 'package:city_guide/services/event_service.dart';
import 'package:flutter/material.dart';

import '../../shared/image_detail.dart';
class EventGallery extends StatefulWidget {
  final String eId;
  final String eName;
  const EventGallery({super.key, required this.eId, required this.eName});

  @override
  State<EventGallery> createState() => _EventGalleryState();
}

class _EventGalleryState extends State<EventGallery> {
  EventService eventService = EventService();

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
      stream: eventService.imageStreamByEventId(widget.eId),
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
                return Stack(
                  children: [
                    // Image
                    GestureDetector(
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailScreen(imageUrl: images[index], name: widget.eName,),
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
                    ),
                    // Delete icon button
                    Positioned(

                      child: IconButton(
                        icon:  const Icon(Icons.delete, color: Colors.white,),
                        onPressed: () {
                          // Call delete image function from CityService
                        eventService.deleteImageFromEvent(widget.eId, images[index]);
                          showSnack("Image removed");
                        },
                      ),
                    ),
                  ],
                );
              },
            ),

          )
              : const Center(
            child: Text(
              'No image available. Click + to add',
              style: TextStyle(fontSize: 18),
            ),
          );
        }
      },
    );
  }
}
