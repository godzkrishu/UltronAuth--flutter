import 'package:flutter/material.dart';
import 'package:ultron/controllers/authcontroller.dart';
import 'package:ultron/controllers/providers/userprovider.dart';
import 'package:ultron/views/authscreen.dart';
import 'package:ultron/views/homescreen.dart';
import 'package:ultron/views/splashScreen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import this to access SharedPreferences

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()), // Add your UserProvider here
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLoading = true;
  fetchuserdata()async{

     await Authcontroller().fetchUserData(context);
     setState(() {
       isLoading=false;
     });
  }
  @override
  void initState() {
    super.initState();
    fetchuserdata(); // Load user data from SharedPreferences
  }





  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context,listen: false).user;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: isLoading
          ? SplashScreen()
          : user.stamp.isNotEmpty
          ? HomeScreen()
          : AuthScreen(), // Decide based on the user's login state
    );
  }
}
