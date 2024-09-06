import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ultron/controllers/authcontroller.dart';
import 'package:ultron/controllers/providers/userprovider.dart';

// HomeScreen widget
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double currentPage = 0.0;
  final PageController _pageViewController = PageController();


  // Slide data
  final List<Map<String, String>> items = [
    {
      "header": "Learn",
      "description": "Online chat which provides its users maximum functionality to simplify the search",
      "image": "assets/images/userperminute.png"
    },
    {
      "header": "Build",
      "description": "Online chat which provides its users maximum functionality to simplify the search",
      "image": "assets/images/website.png"
    },
    {
      "header": "Launch",
      "description": "Online chat which provides its users maximum functionality to simplify the search",
      "image": "assets/images/boygirl.png"
    },
    {
      "header": "Invest",
      "description": "Online chat which provides its users maximum functionality to simplify the search",
      "image": "assets/images/girl.png"
    }
  ];



  @override
  void initState() {
    super.initState();
    Authcontroller().fetchUserData(context);
    _pageViewController.addListener(() {
      setState(() {
        currentPage = _pageViewController.page ?? 0.0;
      });
    });
  }

  @override
  void dispose() {
    _pageViewController.dispose();
    super.dispose();
  }

  // Generate slides
  List<Widget> get slides => items
      .map((item) => Container(
    padding: EdgeInsets.symmetric(horizontal: 18.0),
    child: Column(
      children: <Widget>[
        Flexible(
          flex: 1,
          fit: FlexFit.tight,
          child: Image.asset(
            item['image']!,
            fit: BoxFit.fitWidth,
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.bottomCenter,
          ),
        ),
        Flexible(
          flex: 1,
          fit: FlexFit.tight,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              children: <Widget>[
                Text(
                  item['header']!,
                  style: TextStyle(
                    fontSize: 50.0,
                    fontWeight: FontWeight.w300,
                    color: Color(0XFF3F3D56),
                    height: 2.0,
                  ),
                ),
                Text(
                  item['description']!,
                  style: TextStyle(
                    color: Colors.grey,
                    letterSpacing: 1.2,
                    fontSize: 16.0,
                    height: 1.3,
                  ),
                  textAlign: TextAlign.center,
                )
              ],
            ),
          ),
        )
      ],
    ),
  ))
      .toList();

  // Generate page indicators
  List<Widget> indicator() => List<Widget>.generate(
    slides.length,
        (index) => Container(
      margin: EdgeInsets.symmetric(horizontal: 3.0),
      height: 10.0,
      width: 10.0,
      decoration: BoxDecoration(
        color: currentPage.round() == index
            ? Color(0XFF256075)
            : Color(0XFF256075).withOpacity(0.2),
        borderRadius: BorderRadius.circular(10.0),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context,listen: false).user;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(65),
        child: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(color: Colors.blueAccent),
          ),
          title: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Spacer(),
                Image.asset("assets/images/applogo.png", height: 70, width: 220),
                Spacer(),
              ],
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                // Call logoutUser method from AuthController
                print("logout funtion called");
               Authcontroller().logoutUser(context);
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0), // Added padding for username
            child: Text(
              "Welcome Back! ${user.name}",
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Color(0XFF3F3D56),
              ),
            ),
          ),
          Expanded(
            child: Stack(
              children: <Widget>[
                PageView.builder(
                  controller: _pageViewController,
                  itemCount: slides.length,
                  itemBuilder: (BuildContext context, int index) {
                    return slides[index];
                  },
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: EdgeInsets.only(top: 70.0),
                    padding: EdgeInsets.symmetric(vertical: 40.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: indicator(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Assume you have AuthController class defined somewhere
class AuthController {
  void logoutUser(BuildContext context) {
    // Implement logout logic here
  }
}
