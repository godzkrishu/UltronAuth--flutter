import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ultron/constants/globalvalue.dart';
import 'package:ultron/controllers/providers/userprovider.dart';
import 'package:ultron/models/user.dart';
import 'package:ultron/utils/errorhandler.dart';
import 'package:ultron/views/authscreen.dart';
import 'package:ultron/views/homescreen.dart';

class Authcontroller {

////logout user funtion

  Future<void> logoutUser(BuildContext context) async {
    try {
      print("logout funtion called");
      SharedPreferences sharedPreferences = await SharedPreferences
          .getInstance();
      String? stampbeforeRemoval = sharedPreferences.getString('stamp');
      print("before logout ${stampbeforeRemoval}");
      // Remove the stamp from local storage
      await sharedPreferences.remove('stamp');
      // Reset the user in the UserProvider
      Provider.of<UserProvider>(context, listen: false).clearUser();//delete user

      // Navigate to the SignIn screen (assuming you have a SignIn screen)

      String? stampAfterRemoval = sharedPreferences.getString('stamp');
      ShowSnackBar(context, "Logout Successfully , here is stamp value  ${stampAfterRemoval} ");
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const AuthScreen()),
            (
            route) => false, // Removes all previous routes (sign out completely)
      );
    } catch (e) {
      ShowSnackBar(context, "Error Occurred during logout: ${e.toString()}");
      print(e.toString());
    }
  }

/////signup funtion

  Future<void> UserSignUp(//user se data lo as argument
          {required BuildContext context,
        required String name,
        required String email,
        required String password}) async {
    try {
      User user = User(
        // uss data ka object banao / model constructor ka use kar ke
        id: '',
        email: email,
        name: name,
        password: password,
        stamp: '',
      );
      http.Response res = await http.post(
          Uri.parse("$uri/api/signup"), //server ko connect karo
          body: jsonEncode(user.fromAppToDB()),
          //aur object ko bhej do mongoDb pe save hone ke liye
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          }); //this uri from global constant
      httpErrorHandler(
          context: context,
          response: res,
          onSuccess: () {
            //passing the funtion
            ShowSnackBar(context,
                "Account Created Successfully!.Please login with same credential");
          });
    } catch (e) {
      ShowSnackBar(context, "Error Occured -${e.toString()}");
    }
  }
    ///signin user funtion


  Future<void> signInUser({required BuildContext context, required String email, required String password}) async {
    try {
      print("signined funtion in authcontroller");
      http.Response res = await http.post(Uri.parse("$uri/api/signin"),
          body: jsonEncode({"email": email, "password": password}),
          headers: {'Content-Type': 'application/json; charset=UTF-8'});

      httpErrorHandler(
        context: context,
        response: res,
        onSuccess: () async {
          SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
          var responseBody = jsonDecode(res.body);

          Provider.of<UserProvider>(context, listen: false).setUser(res.body);
          await sharedPreferences.setString("stamp", responseBody['stamp']);
          final userstamp=Provider.of<UserProvider>(context,listen: false).user.stamp;
         print("user stamp after loging ${userstamp}");
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        },
      );
    } catch (e) {
      ShowSnackBar(context, "Error Occurred: ${e.toString()}");
      print(e.toString());
    }
  }


////validate stamp
  Future<void> fetchUserData(BuildContext context) async {
    try {
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      String? stamp = sharedPreferences.getString("stamp"); // Get saved stamp

      if (stamp == null || stamp.isEmpty) {
        // If no stamp, user is not logged in
        print("No stamp found, user is not logged in");
        return;
      }

      // Validate the stamp by sending it to the backend
      var stampRes = await http.post(
        Uri.parse("$uri/validateStamp"),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'stamp': stamp,
        },
      );

      var isValidStamp = jsonDecode(stampRes.body);

      if (isValidStamp) {
        // Fetch user data since stamp is valid
        http.Response userRes = await http.get(Uri.parse("$uri/"),
            headers: {'Content-Type': 'application/json; charset=UTF-8', 'stamp': stamp});

        if (userRes.statusCode == 200) {
          Provider.of<UserProvider>(context, listen: false).setUser(userRes.body);
        }
      } else {
        print("Invalid stamp, user needs to log in again");
        // Clear the invalid stamp
        await sharedPreferences.remove('stamp');
      }
    } catch (e) {
      ShowSnackBar(context, "Error occurred while fetching user data: ${e.toString()}");
      print(e.toString());
    }
  }
}
