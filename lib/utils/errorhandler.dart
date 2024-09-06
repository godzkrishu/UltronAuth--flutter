import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void ShowSnackBar(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
}

void httpErrorHandler({
  required BuildContext context, //provide location of widget in tree
  required http.Response response,
  required VoidCallback onSuccess,// take funtion  with name onSuccess
}) {
  switch (response.statusCode) {
    case 200:
      onSuccess(); // if sucess then onSuccess() funtion defined in auth controller
      break;
    case 400: // if error in authcontroller then show er msg
      ShowSnackBar(
          context,
          jsonDecode(response.body)[
          'msg']); // context make scankbar show on the page where error occure,
      break;
    case 500:
      ShowSnackBar(context, jsonDecode(response.body)['error']);//from authcontroller
      break;
    default:// unexpected error then show whole body
      ShowSnackBar(context, response.body);
      print(response.body);
  }
}
