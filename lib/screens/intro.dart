import 'package:carousel_slider/carousel_slider.dart';
import 'package:city_guide/shared/loading.dart';
import 'package:flutter/material.dart';

class Intro extends StatefulWidget {
  const Intro({super.key});

  @override
  State<Intro> createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  final CarouselController _carouselController = CarouselController();
  int _currentPage = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    // Simulate loading delay
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _isLoading = false; // Set loading state to false after 2 seconds
      });
    }
    );
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImages(); // Preload images when the dependencies change
  }

  void precacheImages() {
    // Preload images using precacheImage
    precacheImage(const AssetImage('assets/images/city.jpeg'), context);
    precacheImage(const AssetImage('assets/images/african.jpeg'), context);
    precacheImage(const AssetImage('assets/images/asianCity.jpeg'), context);
    precacheImage(const AssetImage('assets/images/asia.jpg'), context);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),

      body:  Stack(
    children: <Widget>[
      Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: _currentPage == 0 ? const AssetImage('assets/images/city.jpeg') :
            _currentPage == 1 ? const AssetImage('assets/images/african.jpeg') : const AssetImage('assets/images/asianCity.jpeg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.7),
              BlendMode.darken,
            ),
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            const  SizedBox(
                height: 170,
              ),
            const  CircleAvatar(
                backgroundImage: AssetImage("assets/images/earth.png"),
                backgroundColor: Colors.transparent,
                radius: 60.0,
              ),
             const SizedBox(
                height: 20.0,
              ),
             Text(

              "CITI\tGUIDE",
                style: TextStyle(
                  color: _currentPage == 0 ? Colors.white : _currentPage == 1
                      ? Colors.amber : Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                  fontFamily: "Lemon",
                ),
                textAlign: TextAlign.center,
              ),
            const  SizedBox(
                height: 40,
              ),
              _isLoading
                  ? const Loading(
              ): CarouselSlider(
                carouselController: _carouselController,
                  items:  [
                   _currentPage == 0 ? Container(
                      width: 900.0,

                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(30),

                      ),
                      child:  SingleChildScrollView(
                        child: Column(
                          children: [
                            const SizedBox(height: 15.0,),
                            const  Text(
                              "Welcome To Citi Guide",
                              style: TextStyle(
                                  color: Colors.white,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            const SizedBox(
                              height: 5.0,
                            ),
                            Card(
                                color: Colors.transparent,
                                child: Column(
                                  children: [
                                    const  Padding(
                                      padding:  EdgeInsets.all(3.0),
                                      child:  Text(
                                        "Whether you're a seasoned traveler or "
                                            "embarking on your first travel adventure, "
                                            "this guide promises to be your ultimate companion,"
                                            " offering invaluable insights, practical tips, "
                                            "and unparalleled inspiration for exploring the "
                                            "vibrant tapestry of beautiful cities. ",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 13.0,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "QuickSand"
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 200.0),
                                      child: IconButton(
                                          onPressed: (){
                                            _carouselController.animateToPage(1);
                                          },
                                          icon:  Icon(
                                            Icons.navigate_next, color: Colors.blue[200],
                                          )
                                      ),
                                    )
                                  ],
                                )
                            )
                          ],
                        ),
                      ),
                    ) : Container(),
                   _currentPage == 1 ? Container(
                      width: 900.0,

                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(30),

                      ),
                      child:  Column(
                        children: [
                          const SizedBox(height: 15.0,),
                       const  Text(
                            "Explore Africa",
                            style: TextStyle(
                                color: Colors.white,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        const SizedBox(
                            height: 5.0,
                          ),
                          Card(
                            color: Colors.transparent,
                            child: Column(
                              children: [
                             const  Padding(
                                 padding:  EdgeInsets.all(3.0),
                                 child:  Text(
                                    "Explore the heart of Africa, "
                                        "where bustling cities merge seamlessly "
                                        "with rich cultural heritage, captivating "
                                        "landscapes, and a tapestry of diverse "
                                        "communities..",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13.0,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "QuickSand"
                                    ),
                                  ),
                               ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 200.0),
                                  child: IconButton(
                                      onPressed: (){
                                        _carouselController.animateToPage(2);
                                      },
                                      icon: const Icon(
                                        Icons.navigate_next, color: Colors.amber,
                                      )
                                  ),
                                )
                              ],
                            )
                          )
                        ],
                      ),
                    ) : Container(),
                    _currentPage == 2 ? Container(
                      width: 900.0,

                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(30),

                      ),
                      child: const SingleChildScrollView(
                        child: Column(
                          children: [
                             SizedBox(height: 15.0,),
                            Text(
                              "Explore Asia",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                             SizedBox(
                              height: 5.0,
                            ),
                            Card(
                                color: Colors.transparent,
                                child: Column(
                                  children: [
                                     Padding(
                                      padding:  EdgeInsets.all(3.0),
                                      child:  Text(
                                        "Explore the mesmerizing realm of Asia, "
                                            "a continent steeped in history, adorned"
                                            " with architectural marvels, and alive with"
                                            " the vibrant energy of its cities. "
                                            "In this comprehensive guide,"
                                            " we embark on an odyssey through "
                                            "the bustling streets and cultural wonders"
                                            " of some of Asia's most captivating urban"
                                            " centers. ",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 13.0,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "QuickSand"
                                        ),
                                      ),
                                    ),

                                  ],
                                )
                            )
                          ],
                        ),
                      ),
                    ) : Container(),
                  ],
                  options: CarouselOptions(
                    height: 200.0,
                    enlargeCenterPage: true,
                    autoPlay: false,
                    aspectRatio: 16 / 9,
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enableInfiniteScroll: false,
                    autoPlayAnimationDuration: const Duration(milliseconds: 800),
                    viewportFraction: 0.8,
                    onPageChanged: (index, reason) {
                    setState(() {
                    _currentPage = index;
                    });
                    },
                    ),
                  ),
              const SizedBox(
                height: 1.0,
              ),
           !_isLoading && _currentPage == 0 ? TextButton(
                 onPressed: (){
                   _carouselController.animateToPage(1);
                 },
                 child: const Text(
                     "Next",
                   style: TextStyle(
                     color: Colors.blue
                   ),
                 )
             ) : Container(),
             _currentPage == 1 || _currentPage == 2 ? TextButton(
               style: TextButton.styleFrom(
                 backgroundColor: _currentPage == 2 ? Colors.green : Colors.amber
               ),
                  onPressed: (){
                 Navigator.pushReplacementNamed(context, "/wrapper");
                  },
                  child:  Text(
                   _currentPage == 2 ? "Go" : "Skip",
                    style:  TextStyle(
                      color: _currentPage == 2 ? Colors.white : Colors.black
                    ),
                  )
              ) : Container(),
              const SizedBox(
                height: 15.0,
              ),
              _isLoading
                  ? Container() :   Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i = 0; i < 3; i++)
                  GestureDetector(
                    onTap: () {
                      _carouselController.animateToPage(i);
                    },
                    child: Container(

                      width: 10,
                      height: 5,
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentPage == i
                            ? Colors.white
                            : Colors.white.withOpacity(0.5),
                      ),
                      child: Container(
                        width: 200.0,
                      ),
                    ),
                  ),
              ],
            )

            ],
          ),

        ),
      ),

    ],

      )
    );
  }
}
