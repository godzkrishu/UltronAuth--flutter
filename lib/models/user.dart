import 'dart:convert';

class User {
  // variable of the user object
  final String id;
  final String email;
  final String name;
  final String password;
  final String stamp;

  // final String stamp;
  User({
    // constructor to initialize
    required this.id,
    required this.email,
    required this.name,
    required this.password,
    required this.stamp,
    // required this.stamp,
  });
  Map<String, dynamic>
  fromAppToDB() // it convert data into model OBject for  mongodb to save it
  {
    return {
      'id': id,
      'email': email,
      'name': name,
      'password': password,

      'stamp': stamp,
    };
  }
//convert the map data from mongodb to object model
  factory User.fromDBtoApp(Map<String, dynamic> map) {
    return User(

      /// convert The Model Object into data

        id: map['id'] ?? '',
        email: map['email'] ?? '',
        name: map['name'] ?? '',
        password: map['password'] ?? '',
        stamp: map['stamp']??''
    );
    // stamp:map['stamp'] ?? '';
  }

  // this funtion take string API and decode into Map and make object using fromDBtoApp() funtion and return  that object
  factory User.fromJson(String source) => User.fromDBtoApp(jsonDecode(source));
}
